// lib/core/device/device_controller_proxy.dart
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

import '../../core/device/state/device_summary_state.dart';
import 'ipc/ipc_client.dart';

/// Device Controller Service IPC client.
///
/// Communication wrapper for Device Controller Service.
/// Flutter treats service as a black box: only commands + events + snapshots.
///
/// On non-Windows platforms (macOS/Web), this provides mock/preview behavior.
///
/// Web builds are UI-only preview environments per playbook rules.
class DeviceControllerProxy {
  final IpcClient _ipcClient;

  StreamSubscription<Map<String, dynamic>>? _eventSubscription;
  final StreamController<int> _cashTestAmountController = StreamController<int>.broadcast();

  DeviceControllerProxy({IpcClient? ipcClient})
    : _ipcClient = ipcClient ?? IpcClient();

  /// Checks if running on Windows platform.
  /// Returns false on Web/macOS (preview mode).
  bool get _isWindows {
    if (kIsWeb) return false;
    try {
      // Platform check will be done in IPC client
      return true; // Assume Windows if not web
    } catch (_) {
      return false;
    }
  }

  /// 연결 상태 확인 (public)
  bool get isConnected => _ipcClient.isConnected;

  /// 연결되어 있으면 true 반환, 아니면 connect 시도 후 결과 반환.
  /// 어드민 진입·자동탐지·세션 체크 등에서 재연결 시도 시 사용.
  Future<bool> ensureConnected() async {
    if (isConnected) return true;
    return connect();
  }

  /// Connects to the Device Controller Service via IPC.
  Future<bool> connect() async {
    if (!_isWindows) {
      // Preview mode: no actual service connection
      debugPrint('Preview mode: skipping service connection');
      return false;
    }

    try {
      debugPrint('DeviceControllerProxy: Starting connection to service...');
      final connected = await _ipcClient.connect();
      debugPrint('DeviceControllerProxy: Connection result: $connected');

      if (connected) {
        _startEventListening();
        debugPrint('DeviceControllerProxy: Event listening started');
      } else {
        debugPrint(
          'DeviceControllerProxy: Connection failed - Command: ${_ipcClient.isConnected}',
        );
      }

      return connected;
    } catch (e, stackTrace) {
      debugPrint('Failed to connect to device service: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 이벤트 수신 시작
  void _startEventListening() {
    _eventSubscription?.cancel();
    _eventSubscription = _ipcClient.eventStream.listen(
      _handleEvent,
      onError: (error) {
        debugPrint('Error in device event stream: $error');
      },
    );
  }

  /// 이벤트 처리
  void _handleEvent(Map<String, dynamic> event) {
    if (event['kind'] != 'event') {
      return;
    }

    final eventType = event['eventType'] as String?;
    final deviceType = event['deviceType'] as String?;

    // device_state_changed는 로그 생략 (노이즈 감소)
    if (eventType != 'device_state_changed') {
      debugPrint('Device event: $eventType (device: $deviceType)');
    }

    // Cash test: broadcast total amount for Admin debug UI
    if (eventType == 'cash_test_amount') {
      final data = event['data'] as Map<String, dynamic>?;
      final total = int.tryParse(data?['totalAmount']?.toString() ?? '') ?? 0;
      if (!_cashTestAmountController.isClosed) {
        _cashTestAmountController.add(total);
      }
    }
  }

  /// Stream of accumulated amount during cash test (debug). 1000/5000/10000 only.
  Stream<int> get cashTestAmountStream => _cashTestAmountController.stream;

  /// Start cash test mode: enable LV77, accept bills, report total via [cashTestAmountStream].
  Future<Map<String, dynamic>?> startCashTest() async {
    return await sendCommand('cash_test_start', {});
  }

  /// Gets device summary snapshot from service.
  Future<DeviceSummaryState> getDeviceSummary() async {
    if (!_isWindows) {
      return const DeviceSummaryState(connected: false, summary: null);
    }
    if (!_ipcClient.isConnected) {
      await connect();
      if (!_ipcClient.isConnected) {
        return const DeviceSummaryState(connected: false, summary: null);
      }
    }

    try {
      final response = await _ipcClient.sendCommand(type: 'get_state_snapshot');

      // 서버는 소문자 "ok"로 응답함
      final status = response['status'] as String?;
      if (status?.toLowerCase() == 'ok') {
        return DeviceSummaryState(
          connected: true,
          summary: response['result'] as Map<String, dynamic>?,
        );
      } else {
        return DeviceSummaryState(connected: true, summary: null);
      }
    } catch (e) {
      debugPrint('Error getting device summary: $e');
      return const DeviceSummaryState(connected: false, summary: null);
    }
  }

  /// Sends a command to the service.
  /// [timeout] 생략 시 기본 30초. detect_hardware(probe=true) 등 장시간 작업은 90초 권장.
  Future<Map<String, dynamic>?> sendCommand(
    String command,
    Map<String, String> params, {
    Duration? timeout,
  }) async {
    if (!_isWindows) {
      debugPrint('Preview mode: command $command ignored (not Windows)');
      return null;
    }
    if (!_ipcClient.isConnected) {
      await connect();
      if (!_ipcClient.isConnected) {
        debugPrint('Command $command ignored: not connected after connect attempt');
        return null;
      }
    }

    try {
      return await _ipcClient.sendCommand(
        type: command,
        payload: params,
        timeout: timeout ?? const Duration(seconds: 30),
      );
    } catch (e) {
      debugPrint('Error sending command $command: $e');
      rethrow;
    }
  }

  /// 결제 시작
  Future<Map<String, dynamic>?> startPayment(int amount) async {
    return await sendCommand('payment_start', {'amount': amount.toString()});
  }

  /// 현금 결제 시작 (목표 금액 지정, 초과분 반환). 어드민 테스트용.
  Future<Map<String, dynamic>?> startCashPayment(int amount) async {
    return await sendCommand('cash_payment_start', {'amount': amount.toString()});
  }

  /// 결제 취소 (진행 중인 결제 취소). 현금 테스트 중이면 현금기만 취소.
  Future<Map<String, dynamic>?> cancelPayment() async {
    return await sendCommand('payment_cancel', {});
  }

  /// 거래(승인) 취소 (이미 승인된 거래 취소)
  Future<Map<String, dynamic>?> cancelTransaction({
    required String cancelType, // '1': 요청전문 취소, '2': 마지막 거래 취소
    required int transactionType,
    required int amount,
    required String approvalNumber,
    required String originalDate, // YYYYMMDD
    required String originalTime, // hhmmss
    int tax = 0,
    int service = 0,
    int installments = 0,
    String additionalInfo = '',
  }) async {
    return await sendCommand('payment_transaction_cancel', {
      'cancelType': cancelType,
      'transactionType': transactionType.toString(),
      'amount': amount.toString(),
      'approvalNumber': approvalNumber,
      'originalDate': originalDate,
      'originalTime': originalTime,
      'tax': tax.toString(),
      'service': service.toString(),
      'installments': installments.toString(),
      'additionalInfo': additionalInfo,
    });
  }

  /// 결제 상태 확인
  Future<Map<String, dynamic>?> checkPaymentStatus() async {
    return await sendCommand('payment_status_check', {});
  }

  /// 결제 단말기 리셋
  Future<Map<String, dynamic>?> resetPaymentTerminal() async {
    return await sendCommand('payment_reset', {});
  }

  /// 결제 단말기 상태 체크
  Future<Map<String, dynamic>?> checkPaymentDevice() async {
    return await sendCommand('payment_device_check', {});
  }

  /// 카드 UID 읽기
  Future<Map<String, dynamic>?> readCardUid() async {
    return await sendCommand('payment_card_uid_read', {});
  }

  /// 마지막 승인 정보 조회
  Future<Map<String, dynamic>?> getLastApproval() async {
    return await sendCommand('payment_last_approval', {});
  }

  /// IC 카드 체크
  Future<Map<String, dynamic>?> checkIcCard() async {
    return await sendCommand('payment_ic_card_check', {});
  }

  /// 카메라 세션 설정 (저장 폴더 = base/sessionId, 이미지 = 0.jpg, 1.jpg, ...)
  Future<Map<String, dynamic>?> setCameraSession(String sessionId) async {
    return await sendCommand('camera_set_session', {'sessionId': sessionId});
  }

  /// 카메라 촬영. sessionId를 매 요청에 포함해 C++가 폴더 생성/저장 후 Complete 전송.
  Future<Map<String, dynamic>?> captureCamera({
    required String sessionId,
    required int imageIndex,
  }) async {
    final captureId = '${sessionId}_$imageIndex';
    return await sendCommand('camera_capture', {
      'sessionId': sessionId,
      'captureId': captureId,
    });
  }

  /// 카메라 재연결 (서비스 측 EDSDK 카메라 shutdown 후 재초기화)
  Future<Map<String, dynamic>?> reconnectCamera() async {
    return await sendCommand('camera_reconnect', {});
  }

  /// QR 감지 활성화/비활성화
  Future<Map<String, dynamic>?> enableQrDetection(bool enable) async {
    return await sendCommand(
      enable ? 'camera_enable_qr_detection' : 'camera_disable_qr_detection',
      {},
    );
  }

  /// QR 감지 상태 초기화 (같은 QR 재감지 허용)
  Future<Map<String, dynamic>?> resetQrDetection() async {
    return await sendCommand('camera_reset_qr_detection', {});
  }

  /// LiveView 프레임 클립 녹화 시작 (MP4 움짤용)
  Future<Map<String, dynamic>?> startClipRecording({
    required String outputDir,
    required int shotIndex,
  }) async {
    return await sendCommand('camera_start_clip_recording', {
      'outputDir': outputDir,
      'shotIndex': shotIndex.toString(),
    });
  }

  /// LiveView 프레임 클립 녹화 중지 + MP4 생성
  Future<Map<String, dynamic>?> stopClipRecording({int shotIndex = 0}) async {
    return await sendCommand('camera_stop_clip_recording', {
      'shotIndex': shotIndex.toString(),
    });
  }

  /// 다수의 MP4 클립을 하나의 영상으로 합치기 (순차 연결)
  Future<Map<String, dynamic>?> mergeClips({
    required List<String> clipPaths,
    required String outputPath,
  }) async {
    return await sendCommand('camera_merge_clips', {
      'clipPaths': clipPaths.join(';'),
      'outputPath': outputPath,
    });
  }

  /// Windows에 등록된 프린터 이름 목록 (admin 하드웨어 - 프린터 선택용)
  Future<List<String>> getAvailablePrinters() async {
    if (!_isWindows || !_ipcClient.isConnected) return [];
    try {
      final response = await _ipcClient.sendCommand(type: 'get_available_printers');
      final status = response['status'] as String?;
      if (status?.toLowerCase() != 'ok') return [];
      final result = response['result'] as Map<String, dynamic>?;
      final raw = result?['available_printers']?.toString() ?? '';
      if (raw.isEmpty) return [];
      return raw.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    } catch (e) {
      debugPrint('Error getAvailablePrinters: $e');
      return [];
    }
  }

  /// 서비스 config 조회 (admin 하드웨어 설정)
  Future<Map<String, String>?> getConfig() async {
    if (!_isWindows || !_ipcClient.isConnected) return null;
    try {
      final response = await _ipcClient.sendCommand(type: 'get_config');
      final status = response['status'] as String?;
      if (status?.toLowerCase() != 'ok') return null;
      final result = response['result'] as Map<String, dynamic>?;
      if (result == null) return null;
      return result.map((k, v) => MapEntry(k, v?.toString() ?? ''));
    } catch (e) {
      debugPrint('Error getConfig: $e');
      return null;
    }
  }

  /// 인쇄 요청. filePath 전달 시 파이프는 경로만 전송(권장). dataBase64는 소량 테스트용으로만.
  /// orientation: 선택 레이아웃에 따라 'portrait'(세로) 또는 'landscape'(가로). 생략 시 portrait.
  Future<Map<String, dynamic>?> printerPrint({
    required String jobId,
    String? filePath,
    String? dataBase64,
    String? orientation,
  }) async {
    if (filePath != null && filePath.isNotEmpty) {
      final payload = <String, String>{
        'jobId': jobId,
        'filePath': filePath,
      };
      if (orientation != null && orientation.isNotEmpty) {
        payload['orientation'] = orientation;
      }
      return await sendCommand('printer_print', payload);
    }
    if (dataBase64 != null && dataBase64.isNotEmpty) {
      return await sendCommand('printer_print', {
        'jobId': jobId,
        'data': dataBase64,
      });
    }
    throw Exception('printerPrint: provide filePath or dataBase64');
  }

  /// 서비스 config 저장 (admin 하드웨어 설정). payload 키: printer.name, payment.com_port 등.
  Future<bool> setConfig(Map<String, String> payload) async {
    if (!_isWindows || !_ipcClient.isConnected) return false;
    try {
      final response = await _ipcClient.sendCommand(
        type: 'set_config',
        payload: payload,
      );
      final status = response['status'] as String?;
      return status?.toLowerCase() == 'ok';
    } catch (e) {
      debugPrint('Error setConfig: $e');
      return false;
    }
  }

  /// 화면/소리 설정
  Future<Map<String, dynamic>?> setScreenSound({
    required int screenBrightness,
    required int soundVolume,
    required int touchSoundVolume,
  }) async {
    return await sendCommand('payment_screen_sound_setting', {
      'screenBrightness': screenBrightness.toString(),
      'soundVolume': soundVolume.toString(),
      'touchSoundVolume': touchSoundVolume.toString(),
    });
  }

  /// 이벤트 스트림 (Controller에서 사용)
  Stream<Map<String, dynamic>> get eventStream => _ipcClient.eventStream;

  /// Disconnects from the service.
  void disconnect() {
    _eventSubscription?.cancel();
    _ipcClient.disconnect();
  }
}
