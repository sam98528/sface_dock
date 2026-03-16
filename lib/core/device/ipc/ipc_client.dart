// lib/core/device/ipc/ipc_client.dart
import 'dart:async';
import 'dart:convert';
import 'named_pipe_client.dart';
import 'package:uuid/uuid.dart';
import '../../../utils/file_logger.dart';

class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  TimeoutException(this.message, this.timeout);

  @override
  String toString() =>
      'TimeoutException: $message (timeout: ${timeout.inSeconds}s)';
}

/// IPC 클라이언트 - Device Controller Service와 통신 (Named Pipe 기반)
class IpcClient {
  static const String protocolVersion = '1.0';

  /// Project identifier - sent to service on connection
  /// This allows a single service to support multiple kiosk projects
  static const String projectCode = 'sfacedock';

  NamedPipeClient? _pipeClient;
  StreamSubscription<Map<String, dynamic>>? _eventSubscription;
  bool _connected = false;
  final Map<String, Completer<Map<String, dynamic>>> _pendingCommands = {};

  /// 동시에 여러 connect() 호출 시 한 번만 실제 연결 시도, 나머지는 같은 Future 대기.
  Future<bool>? _connectInProgress;

  /// 결제 완료 등 서버 푸시 이벤트용. 연결 전 구독해도 connect() 후 수신 이벤트를 받음.
  StreamController<Map<String, dynamic>>? _eventController;

  /// 전체 연결. 이미 연결 중이면 진행 중인 연결을 기다려 그 결과를 반환.
  Future<bool> connect() async {
    if (_connected) {
      return true;
    }
    if (_connectInProgress != null) {
      return _connectInProgress!;
    }

    _connectInProgress = _doConnect();
    try {
      final result = await _connectInProgress!;
      return result;
    } finally {
      _connectInProgress = null;
    }
  }

  Future<bool> _doConnect() async {
    try {
      logInfo('[IPC] Starting IPC connection via Named Pipe...');
      logInfo('[IPC] Pipe name: \\\\.\\pipe\\KioroboController');
      logInfo('[IPC] Make sure Kiorobo Controller is running!');

      _pipeClient = NamedPipeClient();

      // Connect to pipe
      final connected = await _pipeClient!.connect();
      if (!connected) {
        logError('[IPC] Failed to connect to Named Pipe');
        logError('[IPC] Possible causes:');
        logError('[IPC]   1. Kiorobo Controller is not running');
        logError('[IPC]   2. Service failed to start IPC server');
        logError(
          '[IPC]   3. FFI functions not properly exported (rebuild Flutter app)',
        );
        return false;
      }

      _connected = true;
      _eventController ??= StreamController<Map<String, dynamic>>.broadcast();

      // 파이프 수신 → _handleMessage → event면 _eventController.add
      _eventSubscription = _pipeClient!.eventStream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          logError('[IPC] Error in event stream: $error');
          _handleDisconnection();
        },
        onDone: () {
          logWarn('[IPC] Event stream closed');
          _handleDisconnection();
        },
        cancelOnError: false,
      );

      logInfo('[IPC] IPC connection established successfully');

      // Send project code to configure service for this project
      try {
        logInfo('[IPC] Sending project code: $projectCode');
        final response = await sendCommand(
          type: 'set_project_code',
          payload: {'projectCode': projectCode},
          timeout: const Duration(seconds: 5),
        );

        final status = response['status'] as String?;
        if (status?.toLowerCase() == 'ok') {
          final dataFolder = response['result']?['dataFolder'] as String?;
          logInfo(
            '[IPC] Project code set successfully. Data folder: $dataFolder',
          );
        } else {
          logWarn('[IPC] Failed to set project code: $response');
          // Don't fail connection on this error - continue with default
        }
      } catch (e) {
        logWarn('[IPC] Error setting project code: $e');
        // Don't fail connection - service will use default project
      }

      return true;
    } catch (e, stackTrace) {
      logError('[IPC] Failed to connect: $e');
      logError('[IPC] Stack trace: $stackTrace');
      _connected = false;
      return false;
    }
  }

  /// Handle incoming messages
  void _handleMessage(Map<String, dynamic> message) {
    final kind = message['kind'] as String?;

    if (kind == 'response') {
      final commandId = message['commandId'] as String?;
      if (commandId != null && _pendingCommands.containsKey(commandId)) {
        final cmdType = message['type'] as String?;
        logInfo(
          '[IPC] Response received for command: $cmdType (ID: $commandId)',
        );
        _pendingCommands[commandId]!.complete(message);
        _pendingCommands.remove(commandId);
      }
    } else if (kind == 'event') {
      final eventType = message['eventType'] as String?;
      final deviceType = message['deviceType'] as String?;
      logInfo(
        '[IPC] Event received: eventType=$eventType, deviceType=$deviceType',
      );

      if (_eventController == null) {
        logWarn('[IPC] WARNING: _eventController is null, event not forwarded');
      } else if (_eventController!.isClosed) {
        logWarn(
          '[IPC] WARNING: _eventController is closed, event not forwarded',
        );
      } else {
        _eventController!.add(message);
        logInfo('[IPC] Event forwarded to stream listeners');
      }
    }
  }

  /// 의도적 disconnect 시 재연결 방지 플래그
  bool _disconnectedIntentionally = false;

  /// Handle disconnection
  void _handleDisconnection() {
    _connected = false;

    // Complete all pending commands with error
    for (var completer in _pendingCommands.values) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Connection lost'));
      }
    }
    _pendingCommands.clear();

    // 의도적 disconnect (shutdown/exit)이면 재연결 시도 안 함
    if (!_disconnectedIntentionally) {
      _reconnect();
    }
  }

  /// Reconnect to pipe
  void _reconnect() {
    if (_connected) {
      return;
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (!_connected) {
        logWarn('[IPC] Attempting to reconnect...');
        connect();
      }
    });
  }

  /// 연결 해제
  Future<void> disconnect() async {
    _disconnectedIntentionally = true;
    _connected = false;

    await _eventSubscription?.cancel();
    _eventSubscription = null;

    _pipeClient?.disconnect();
    _pipeClient = null;

    _eventController?.close();
    _eventController = null;

    // Complete all pending commands with error
    for (var completer in _pendingCommands.values) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Disconnected'));
      }
    }
    _pendingCommands.clear();

    logInfo('[IPC] IPC disconnected');
  }

  bool get isConnected => _connected && _pipeClient?.isConnected == true;

  /// 명령어 전송
  Future<Map<String, dynamic>> sendCommand({
    required String type,
    Map<String, String> payload = const {},
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (!_connected || _pipeClient == null) {
      throw Exception('Not connected to IPC server');
    }

    final commandId = const Uuid().v4();
    final command = {
      'protocolVersion': protocolVersion,
      'kind': 'command',
      'commandId': commandId,
      'type': type,
      'timestampMs': DateTime.now().millisecondsSinceEpoch,
      'payload': payload,
    };

    try {
      logInfo(
        '[IPC] Sending command: $type (ID: $commandId, payload: $payload)',
      );

      // Create completer for response
      final completer = Completer<Map<String, dynamic>>();
      _pendingCommands[commandId] = completer;

      // Send command
      final commandJson = jsonEncode(command);
      final sent = await _pipeClient!.sendMessage(commandJson);

      if (!sent) {
        _pendingCommands.remove(commandId);
        logError('[IPC] Failed to send command: $type');
        throw Exception('Failed to send command');
      }

      // Wait for response with timeout
      final response = await completer.future.timeout(
        timeout,
        onTimeout: () {
          _pendingCommands.remove(commandId);
          logError('[IPC] Command timeout: $type (${timeout.inSeconds}s)');
          throw TimeoutException('Command timeout: $type', timeout);
        },
      );

      // printer_status 명령에 대해 자세한 로그 추가
      if (type == 'printer_status') {
        logInfo('[IPC] printer_status 응답 전체: $response');
        logInfo('[IPC] printer_status 응답 keys: ${response.keys.toList()}');
        logInfo('[IPC] printer_status status 필드: ${response['status']}');

        final responseMap = response['responseMap'];
        if (responseMap != null) {
          logInfo('[IPC] printer_status responseMap 타입: ${responseMap.runtimeType}');
          logInfo('[IPC] printer_status responseMap 내용: $responseMap');
          if (responseMap is Map) {
            logInfo('[IPC] printer_status responseMap keys: ${responseMap.keys.toList()}');
          }
        } else {
          logWarn('[IPC] printer_status responseMap이 null입니다!');
        }

        final error = response['error'];
        if (error != null) {
          logError('[IPC] printer_status error: $error');
        }
      }

      final status = response['status'] as String?;
      if (status?.toLowerCase() == 'ok') {
        logInfo('[IPC] Command SUCCESS: $type');
      } else {
        logWarn(
          '[IPC] Command response: $type -> $status (error: ${response['error']})',
        );
      }
      return response;
    } catch (e, stackTrace) {
      logError('[IPC] Error sending command $type: $e');
      logError('[IPC] Stack trace: $stackTrace');
      _pendingCommands.remove(commandId);
      rethrow;
    }
  }

  /// 이벤트 스트림. 연결 전에 구독해도 connect() 완료 후 서버에서 오는 이벤트를 받음.
  Stream<Map<String, dynamic>> get eventStream {
    _eventController ??= StreamController<Map<String, dynamic>>.broadcast();
    return _eventController!.stream;
  }
}
