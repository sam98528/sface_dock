// lib/screens/admin/admin_screen.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../app/kiosk_navigator_observer.dart';
import '../../session/controllers/device_auth_controller.dart';
import '../../session/services/session_photo_storage_service.dart';
import '../controllers/admin_controller.dart';
import '../controllers/locale_controller.dart';
import '../models/admin_settings_model.dart';
import '../../session/controllers/session_controller.dart';
import '../../../utils/app_lifecycle.dart';
import '../../device/device_controller_proxy_provider.dart';
import '../../theme/app_theme.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_feature_section.dart';
import '../../constants/decorate_filters.dart';
import '../widgets/admin_hardware_section.dart';
import '../widgets/admin_system_section.dart';

/// Minimal 1x1 pixel JPEG (base64) for test print.
const String _kTestPrintImageBase64 =
    '/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAABAAEDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlbaWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMRAD8A8ooooA//2Q==';

/// 관리자 화면 — F1으로 진입. 하드웨어/기능/시스템 설정 (영구 저장 + 서비스 연동).
class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  int _selectedIndex = 0;
  List<String> _availableComPorts = [
    'COM1',
    'COM2',
    'COM3',
    'COM4',
    'COM5',
    'COM6',
  ];

  /// Windows에 등록된 프린터 이름 목록 (서비스에서 조회)
  List<String> _availablePrinters = [];

  /// 자동 탐지로 받은 장치 상태 (READY / DISCONNECTED / ERROR 등). null = 장비 연결 확인 필요.
  String? _cameraStatus;
  String? _printerStatus;
  String? _paymentStatus;
  String? _cashStatus;
  bool _isAutoDetecting = false;
  int _cashTestAmount = 0;
  StreamSubscription<int>? _cashTestSubscription;
  int _cashPaymentRequested = 0;
  int _cashPaymentCurrent = 0;
  bool _cashPaymentTargetReached = false;
  int _cashPaymentPresetIndex = 0;
  StreamSubscription<Map<String, dynamic>>? _cashPaymentEventSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onEnterAdmin());
  }

  @override
  void dispose() {
    _cashTestSubscription?.cancel();
    _cashPaymentEventSub?.cancel();
    super.dispose();
  }

  Future<void> _onEnterAdmin() async {
    await ref.read(adminControllerProvider.notifier).reload();
    ref.read(adminDraftProvider.notifier).syncFromApplied();
    final proxy = ref.read(deviceControllerProxyProvider);
    // 어드민 진입 시 파이프 연결 확인·재시도 (자동 복구)
    final ok = await proxy.ensureConnected();
    ref.read(connectionStateProvider.notifier).state = ok;
    _cashTestSubscription?.cancel();
    _cashTestSubscription = proxy.cashTestAmountStream.listen((int v) {
      if (mounted) setState(() => _cashTestAmount = v);
    });
    _cashPaymentEventSub?.cancel();
    _cashPaymentEventSub = proxy.eventStream.listen((event) {
      final type = event['eventType']?.toString();
      final data = event['data'] as Map<String, dynamic>?;
      if (type == 'cash_payment_target_reached') {
        final total = int.tryParse(data?['totalAmount']?.toString() ?? '') ?? 0;
        if (mounted) {
          setState(() {
            _cashPaymentCurrent = total;
            _cashPaymentTargetReached = true;
          });
        }
        return;
      }
      if (type == 'cash_bill_stacked') {
        final currentTotal =
            int.tryParse(data?['currentTotal']?.toString() ?? '') ?? 0;
        if (mounted && currentTotal >= 0) {
          setState(() => _cashPaymentCurrent = currentTotal);
        }
        return;
      }
      if (type != 'payment_complete') return;
      if (data?['transactionMedium'] != 'CASH') return;
      final amt = int.tryParse(data?['amount']?.toString() ?? '') ?? 0;
      if (mounted && amt > 0) setState(() => _cashPaymentCurrent += amt);
    });
    if (proxy.isConnected) {
      // COM 목록·장치 상태·모델명은 서비스에서 실제로 가져옴
      try {
        // 어드민 진입 시: probe=false로 경량 조회 (카메라 shutdown 없음, COM 스캔 없음)
        final response = await proxy.sendCommand('detect_hardware', {
          'probe': 'false',
        });
        if (mounted && response != null && response['result'] is Map) {
          final result = Map<String, dynamic>.from(response['result'] as Map);
          final portsStr = result['available_ports']?.toString();
          if (portsStr != null && portsStr.isNotEmpty) {
            final ports = portsStr
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            if (ports.isNotEmpty) setState(() => _availableComPorts = ports);
          }
          final paymentCom = result['payment.com_port']?.toString() ?? '';
          final cashCom = result['cash.com_port']?.toString() ?? '';
          final notifier = ref.read(adminDraftProvider.notifier);
          if (paymentCom.isNotEmpty) {
            if (!_availableComPorts.contains(paymentCom)) {
              setState(
                () =>
                    _availableComPorts = [..._availableComPorts, paymentCom]
                      ..sort(),
              );
            }
            final idx = _availableComPorts.indexOf(paymentCom);
            if (idx >= 0) {
              notifier.updateDraft(
                (d) => d.copyWith(paymentTerminalComIndex: idx),
              );
            }
          }
          if (cashCom.isNotEmpty) {
            if (!_availableComPorts.contains(cashCom)) {
              setState(
                () =>
                    _availableComPorts = [..._availableComPorts, cashCom]
                      ..sort(),
              );
            }
            final idx = _availableComPorts.indexOf(cashCom);
            if (idx >= 0) {
              notifier.updateDraft((d) => d.copyWith(cashDeviceComIndex: idx));
            }
          }
          setState(() {
            _cameraStatus = result['camera.stateString']?.toString();
            _printerStatus = result['printer.stateString']?.toString();
            _paymentStatus = result['payment.stateString']?.toString();
            _cashStatus = result['cash.stateString']?.toString();
          });
        }
      } catch (_) {}
      final config = await proxy.getConfig();
      if (!mounted) return;
      if (config != null) {
        _applyHardwareConfig(config);
        ref.read(adminDraftProvider.notifier).syncFromApplied();
      }
      final printers = await proxy.getAvailablePrinters();
      if (mounted && printers.isNotEmpty) {
        setState(() => _availablePrinters = printers);
      }
    }
    if (mounted) setState(() {});
  }

  void _applyHardwareConfig(Map<String, String> config) {
    final c = ref.read(adminControllerProvider.notifier);
    final printerName = config['printer.name'] ?? '';
    if (printerName.isNotEmpty) c.setPrinterModel(printerName);
    // 무조건 4x6 용지로 고정
    c.updateSettings((s) => s.copyWith(printerPaperSize: '4x6'));
    final marginH = int.tryParse(config['printer.margin_h'] ?? '');
    if (marginH != null) {
      c.updateSettings((s) => s.copyWith(printerMarginH: marginH));
    }
    final marginV = int.tryParse(config['printer.margin_v'] ?? '');
    if (marginV != null) {
      c.updateSettings((s) => s.copyWith(printerMarginV: marginV));
    }
    final paymentCom = config['payment.com_port'] ?? '';
    final comPorts = _comPorts;
    final paymentIndex = comPorts.indexOf(paymentCom);
    if (paymentIndex >= 0) c.setPaymentTerminalComIndex(paymentIndex);
    c.setPaymentTerminalEnabled((config['payment.enabled'] ?? '1') == '1');
    final cashCom = config['cash.com_port'] ?? '';
    final cashIndex = comPorts.indexOf(cashCom);
    if (cashIndex >= 0) c.setCashDeviceComIndex(cashIndex);
    c.setCashDeviceEnabled((config['cash.enabled'] ?? '0') == '1');
  }

  List<String> get _comPorts => _availableComPorts;

  Future<void> _saveHardwareConfig() async {
    final proxy = ref.read(deviceControllerProxyProvider);
    if (!proxy.isConnected) {
      await proxy.ensureConnected();
      if (!mounted) return;
      ref.read(connectionStateProvider.notifier).state = proxy.isConnected;
    }
    if (!mounted || !proxy.isConnected) return;

    final state = ref.read(adminControllerProvider);
    // COM 포트는 백엔드 자동 인식; 기존에 탐지된 값 유지
    final paymentCom =
        _comPorts[state.paymentTerminalComIndex.clamp(0, _comPorts.length - 1)];
    final cashCom =
        _comPorts[state.cashDeviceComIndex.clamp(0, _comPorts.length - 1)];

    final payload = <String, String>{
      'printer.name': state.printerModel,
      'printer.paper_size': state.printerPaperSize,
      'printer.margin_h': state.printerMarginH.toString(),
      'printer.margin_v': state.printerMarginV.toString(),
      // 비활성 장치의 COM 포트는 빈 값으로 저장 → 다른 장치 자동 감지 시 잘못된 제외 방지
      'payment.com_port': state.paymentTerminalEnabled ? paymentCom : '',
      'payment.enabled': state.paymentTerminalEnabled ? '1' : '0',
      'cash.com_port': state.cashDeviceEnabled ? cashCom : '',
      'cash.enabled': state.cashDeviceEnabled ? '1' : '0',
    };
    await proxy.setConfig(payload);
  }

  Future<void> _onTestPrint() async {
    final proxy = ref.read(deviceControllerProxyProvider);
    if (!proxy.isConnected) {
      final ok = await proxy.ensureConnected();
      ref.read(connectionStateProvider.notifier).state = ok;
      if (!mounted) return;
      if (!proxy.isConnected) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                '서비스에 연결되어 있지 않습니다. 먼저 Device Controller Service를 실행해 주세요.',
              ),
            ),
          );
        return;
      }
    }
    final jobId = const Uuid().v4();
    try {
      final response = await proxy.printerPrint(
        jobId: jobId,
        dataBase64: _kTestPrintImageBase64,
      );
      final status = response?['status'] as String?;
      if (mounted) {
        if (status?.toLowerCase() == 'ok') {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(content: Text('테스트 인쇄 요청을 보냈습니다.')));
        } else {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text('인쇄 실패: ${response?['error'] ?? 'unknown'}'),
              ),
            );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text('인쇄 오류: $e')));
      }
    }
  }

  /// 디버그용: .env의 DEBUG_SESSION_ID 폴더에 있는 product.jpg를 filePath로 인쇄.
  Future<void> _onPrintSessionProduct() async {
    final sessionId = dotenv.env['DEBUG_SESSION_ID']?.trim();
    if (sessionId == null || sessionId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(content: Text('DEBUG_SESSION_ID를 .env에 설정해 주세요.')),
          );
      }
      return;
    }
    final proxy = ref.read(deviceControllerProxyProvider);
    if (!proxy.isConnected) {
      final ok = await proxy.ensureConnected();
      ref.read(connectionStateProvider.notifier).state = ok;
      if (!mounted) return;
      if (!proxy.isConnected) {
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(content: Text('서비스에 연결되어 있지 않습니다.')));
        }
        return;
      }
    }
    try {
      final productPath = await getProductFilePath(sessionId);
      if (productPath == null) {
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(content: Text('세션 파일을 찾을 수 없습니다.')));
        }
        return;
      }
      final file = File(productPath);
      if (!await file.exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text('파일이 없습니다: $productPath')));
        }
        return;
      }
      final jobId = const Uuid().v4();
      debugPrint('printer_print filePath (product.jpg): $productPath');
      final response = await proxy.printerPrint(
        jobId: jobId,
        filePath: productPath,
      );
      final status = response?['status'] as String?;
      if (mounted) {
        if (status?.toLowerCase() == 'ok') {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(content: Text('현재 세션 product.jpg 인쇄 요청을 보냈습니다.')),
            );
        } else {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text('인쇄 실패: ${response?['error'] ?? 'unknown'}'),
              ),
            );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text('product.jpg 인쇄 오류: $e')));
      }
    }
  }

  Future<void> _onAutoDetect() async {
    if (_isAutoDetecting) return;
    setState(() => _isAutoDetecting = true);

    final proxy = ref.read(deviceControllerProxyProvider);
    // 자동탐지 시 파이프 미연결이면 재연결 시도 (자동 복구)
    if (!proxy.isConnected) {
      final ok = await proxy.ensureConnected();
      ref.read(connectionStateProvider.notifier).state = ok;
      if (!mounted) {
        setState(() => _isAutoDetecting = false);
        return;
      }
      if (!proxy.isConnected) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                '서비스에 연결되어 있지 않습니다. 먼저 Device Controller Service를 실행해 주세요.',
              ),
            ),
          );
        setState(() => _isAutoDetecting = false);
        return;
      }
    }

    try {
      // 현재 드래프트의 결제/현금 사용 여부를 넘겨 서비스가 결제만·현금만 검사하도록 분리
      final draftState = ref.read(adminDraftProvider);
      final d = draftState.draft;
      final payload = <String, String>{
        'probe': 'true',
        'payment.enabled': d.paymentTerminalEnabled ? '1' : '0',
        'cash.enabled': d.cashDeviceEnabled ? '1' : '0',
      };
      final response = await proxy.sendCommand(
        'detect_hardware',
        payload,
        timeout: const Duration(seconds: 90),
      );
      if (!mounted) return;

      // IPC 응답 구조: { status, result: { camera.model, printer.name, ... } }
      final result = response != null && response['result'] is Map
          ? Map<String, dynamic>.from(response['result'] as Map)
          : null;

      if (result != null && result.isNotEmpty) {
        final notifier = ref.read(adminDraftProvider.notifier);

        // 1) 사용 가능 COM 포트 목록
        final availablePortsStr = result['available_ports']?.toString();
        if (availablePortsStr != null && availablePortsStr.isNotEmpty) {
          final ports = availablePortsStr
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          if (ports.isNotEmpty) {
            setState(() => _availableComPorts = ports);
          }
        }

        // 2) 드래프트 한 번에 반영 (카메라·프린터·결제·현금)
        final cameraModel = result['camera.model']?.toString() ?? '';
        final printerName = result['printer.name']?.toString() ?? '';
        final paymentCom = result['payment.com_port']?.toString() ?? '';
        final cashCom = result['cash.com_port']?.toString() ?? '';

        int paymentIndex = 0;
        if (paymentCom.isNotEmpty) {
          if (!_availableComPorts.contains(paymentCom)) {
            setState(() {
              _availableComPorts = [..._availableComPorts, paymentCom]..sort();
            });
          }
          paymentIndex = _availableComPorts.indexOf(paymentCom);
          if (paymentIndex < 0) paymentIndex = 0;
        }

        int cashIndex = 0;
        if (cashCom.isNotEmpty) {
          if (!_availableComPorts.contains(cashCom)) {
            setState(() {
              _availableComPorts = [..._availableComPorts, cashCom]..sort();
            });
          }
          cashIndex = _availableComPorts.indexOf(cashCom);
          if (cashIndex < 0) cashIndex = 0;
        }

        notifier.updateDraft(
          (d) => d.copyWith(
            cameraModel: cameraModel.isNotEmpty ? cameraModel : d.cameraModel,
            printerModel: printerName.isNotEmpty ? printerName : d.printerModel,
            paymentTerminalComIndex: paymentCom.isNotEmpty
                ? paymentIndex
                : d.paymentTerminalComIndex,
            cashDeviceComIndex: cashCom.isNotEmpty
                ? cashIndex
                : d.cashDeviceComIndex,
          ),
        );

        // 장치별 실제 상태 (정상 작동 중 표시용)
        setState(() {
          _cameraStatus = result['camera.stateString']?.toString();
          _printerStatus = result['printer.stateString']?.toString();
          _paymentStatus = result['payment.stateString']?.toString();
          _cashStatus = result['cash.stateString']?.toString();
        });

        // 자동 탐지 결과를 그대로 적용: draft 반영 후 저장까지 해서 서비스/설정이 탐지 결과에 맞게 변경
        await notifier.apply();
        if (mounted) await _saveHardwareConfig();

        // 저장 후 서비스에 프린터 어댑터가 등록되었으므로 상태를 재조회하여 UI 갱신
        if (mounted && proxy.isConnected) {
          final refreshResp = await proxy.sendCommand('detect_hardware', {
            'probe': 'false',
          });
          if (mounted && refreshResp != null && refreshResp['result'] is Map) {
            final r = Map<String, dynamic>.from(refreshResp['result'] as Map);
            setState(() {
              _cameraStatus =
                  r['camera.stateString']?.toString() ?? _cameraStatus;
              _printerStatus =
                  r['printer.stateString']?.toString() ?? _printerStatus;
              _paymentStatus =
                  r['payment.stateString']?.toString() ?? _paymentStatus;
              _cashStatus = r['cash.stateString']?.toString() ?? _cashStatus;
            });
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text('하드웨어 탐지 완료. 카드/현금 COM이 탐지 결과에 맞게 적용·저장되었습니다.'),
              ),
            );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text('하드웨어 탐지 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _isAutoDetecting = false);
    }
  }

  Future<void> _onSaveSettings() async {
    final notifier = ref.read(adminDraftProvider.notifier);
    await notifier.apply();
    if (!mounted) return;
    await _saveHardwareConfig();
    if (!mounted) return;
    final applied = ref.read(adminControllerProvider);
    AppTheme.setThemeFromAdmin(
      background: applied.themeBackground,
      key: applied.themeKeyColor,
      text: applied.themeTextColor,
      buttonBg: applied.themeButtonBg,
      buttonText: applied.themeButtonText,
    );
    final localeCodes = ['ko', 'en', 'ja'];
    if (applied.localeIndex >= 0 && applied.localeIndex < localeCodes.length) {
      ref
          .read(localeControllerProvider.notifier)
          .setLocaleByCode(localeCodes[applied.localeIndex]);
    }
    ref.read(adminThemeVersionProvider.notifier).state++;
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text('설정이 저장되었습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final draftState = ref.watch(adminDraftProvider);
    final draft = draftState.draft;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notifier = ref.read(adminDraftProvider.notifier);

    return Theme(
      data: AdminTheme.theme(context),
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        body: SafeArea(
          child: Row(
            children: [
              // Navigation Rail
              _buildNavigationRail(context, colorScheme),
              // Content
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(context, colorScheme),
                    Expanded(
                      child: ClipRect(
                        child: IndexedStack(
                          index: _selectedIndex,
                          children: [
                            _buildHardwareTab(draft, notifier),
                            _buildFeatureTab(draft, notifier),
                            _buildSystemTab(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: draftState.dirty
            ? FloatingActionButton.extended(
                onPressed: _onSaveSettings,
                icon: const Icon(Icons.save),
                label: const Text('설정 저장'),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            _selectedIndex == 0
                ? '하드웨어 설정'
                : _selectedIndex == 1
                ? '기능 설정'
                : '시스템 관리',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            'F1: 관리자 진입 · F2: 첫 화면',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            tooltip: '닫기',
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: AdminTheme.kAdminRailWidth,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Logo or Title area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  size: 32,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Admin',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          _NavItem(
            icon: Icons.devices,
            label: '하드웨어',
            isSelected: _selectedIndex == 0,
            onTap: () => setState(() => _selectedIndex = 0),
          ),
          _NavItem(
            icon: Icons.tune,
            label: '기능 설정',
            isSelected: _selectedIndex == 1,
            onTap: () => setState(() => _selectedIndex = 1),
          ),
          _NavItem(
            icon: Icons.settings_applications,
            label: '시스템',
            isSelected: _selectedIndex == 2,
            onTap: () => setState(() => _selectedIndex = 2),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'v1.0.0',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: colorScheme.outline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHardwareTab(AdminSettings draft, AdminDraftNotifier notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: AdminHardwareSection(
        cameraModel: draft.cameraModel,
        cameraComIndex: 0,
        onCameraModelChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(cameraModel: v)),
        onCameraComChanged: (_) {},
        comPorts: _comPorts,
        cameraStatus: _cameraStatus,
        printerModel: draft.printerModel,
        availablePrinters: _availablePrinters,
        onPrinterModelChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(printerModel: v)),
        printerPaperSize: draft.printerPaperSize,
        onPrinterPaperSizeChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(printerPaperSize: v)),
        printerPaperRemaining: draft.printerPaperRemaining,
        onPrinterPaperRemainingChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(printerPaperRemaining: v)),
        onPrinterPaperReset: () =>
            notifier.updateDraft((d) => d.copyWith(printerPaperRemaining: 980)),
        printerMarginH: draft.printerMarginH,
        printerMarginV: draft.printerMarginV,
        onPrinterMarginHChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(printerMarginH: v)),
        onPrinterMarginVChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(printerMarginV: v)),
        onTestPrint: _onTestPrint,
        onPrintSessionProduct: _onPrintSessionProduct,
        printerStatus: _printerStatus,
        paymentTerminalEnabled: draft.paymentTerminalEnabled,
        onPaymentTerminalEnabledChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(paymentTerminalEnabled: v)),
        cashDeviceEnabled: draft.cashDeviceEnabled,
        onCashDeviceEnabledChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(cashDeviceEnabled: v)),
        paymentStatus: _paymentStatus,
        cashStatus: _cashStatus,
        onAutoDetect: _onAutoDetect,
        isAutoDetecting: _isAutoDetecting,
        isDebugMode: kDebugMode,
        cashTestAmount: _cashTestAmount,
        onCashTestStart: _onCashTestStart,
        onCashTestStop: _onCashTestStop,
        cashPaymentRequested: _cashPaymentRequested,
        cashPaymentCurrent: _cashPaymentCurrent,
        cashPaymentTargetReached: _cashPaymentTargetReached,
        cashPaymentPresetIndex: _cashPaymentPresetIndex,
        onCashPaymentPresetChanged: (v) =>
            setState(() => _cashPaymentPresetIndex = v),
        onCashPaymentRequest: _onCashPaymentRequest,
        rgbEnabled: draft.rgbEnabled,
        onRgbEnabledChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(rgbEnabled: v)),
        rgbProcessName: draft.rgbProcessName,
        onRgbProcessNameChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(rgbProcessName: v)),
        socketServerEnabled: draft.socketServerEnabled,
        onSocketServerEnabledChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(socketServerEnabled: v)),
        socketServerPort: draft.socketServerPort,
        onSocketServerPortChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(socketServerPort: v)),
      ),
    );
  }

  Future<void> _onCashPaymentRequest(int amount) async {
    final proxy = ref.read(deviceControllerProxyProvider);
    final res = await proxy.startCashPayment(amount);
    if (!mounted) return;
    if (res != null && res['status']?.toString().toLowerCase() != 'ok') {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '현금 결제 요청 실패: ${res['errorMessage'] ?? res['error']?['message'] ?? res['status']}',
            ),
          ),
        );
      return;
    }
    setState(() {
      _cashPaymentRequested = amount;
      _cashPaymentCurrent = 0;
      _cashPaymentTargetReached = false;
    });
  }

  Future<void> _onCashTestStart() async {
    final proxy = ref.read(deviceControllerProxyProvider);
    final res = await proxy.startCashTest();
    if (mounted &&
        res != null &&
        (res['status']?.toString().toLowerCase() != 'ok')) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '현금 테스트 시작 실패: ${res['errorMessage'] ?? res['status']}',
            ),
          ),
        );
    } else if (mounted) {
      setState(() => _cashTestAmount = 0);
    }
  }

  Future<void> _onCashTestStop() async {
    await ref.read(deviceControllerProxyProvider).cancelPayment();
  }

  Widget _buildFeatureTab(AdminSettings draft, AdminDraftNotifier notifier) {
    final colorFilterOptions = kDecorateFilterOptions
        .map((e) => e['displayName'] as String)
        .toList();
    const localeOptions = ['한국어', '영어', '일본어'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: AdminFeatureSection(
        mirrorEnabled: draft.mirrorEnabled,
        countdownEnabled: draft.countdownEnabled,
        countdownSec: draft.countdownSec,
        onMirrorChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(mirrorEnabled: v)),
        onCountdownEnabledChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(countdownEnabled: v)),
        onCountdownSecChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(countdownSec: v)),
        shotCount: draft.shotCount,
        onShotCountChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(shotCount: v)),
        delayBetweenShots: draft.delayBetweenShots,
        onDelayBetweenShotsChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(delayBetweenShots: v)),
        remoteEnabled: draft.remoteEnabled,
        remoteCountdownSec: draft.remoteCountdownSec,
        onRemoteEnabledChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(remoteEnabled: v)),
        onRemoteCountdownSecChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(remoteCountdownSec: v)),
        colorFilterNames: draft.colorFilterNames,
        onColorFilterChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(colorFilterNames: v)),
        colorFilterOptions: colorFilterOptions,
        introClipSec: draft.introClipSec,
        introGuide: draft.introGuide,
        onIntroClipSecChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(introClipSec: v)),
        onIntroGuideChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(introGuide: v)),
        printWaitDurationSeconds: draft.printWaitDurationSeconds,
        onPrintWaitDurationSecondsChanged: (v) => notifier.updateDraft(
          (d) => d.copyWith(printWaitDurationSeconds: v),
        ),
        timeoutsAndGuides: draft.timeoutsAndGuides,
        onTimeoutAndGuideChanged: (key, timeout, guide) {
          final cur = draft.timeoutsAndGuides[key];
          if (cur == null) return;
          final newMap = Map<String, ({int timeout, String guide})>.from(
            draft.timeoutsAndGuides,
          );
          newMap[key] = (
            timeout: timeout ?? cur.timeout,
            guide: guide ?? cur.guide,
          );
          notifier.updateDraft((d) => d.copyWith(timeoutsAndGuides: newMap));
        },
        backupPath: draft.backupPath,
        onBackupPathChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(backupPath: v)),
        localeIndex: draft.localeIndex,
        localeOptions: localeOptions,
        onLocaleChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(localeIndex: v)),
        themeBackground: draft.themeBackground,
        themeKeyColor: draft.themeKeyColor,
        themeTextColor: draft.themeTextColor,
        themeButtonBg: draft.themeButtonBg,
        themeButtonText: draft.themeButtonText,
        onThemeBackgroundChanged: (v) => notifier.updateDraft(
          (d) => d.copyWith(themeBackgroundValue: v.value),
        ),
        onThemeKeyColorChanged: (v) => notifier.updateDraft(
          (d) => d.copyWith(themeKeyColorValue: v.value),
        ),
        onThemeTextColorChanged: (v) => notifier.updateDraft(
          (d) => d.copyWith(themeTextColorValue: v.value),
        ),
        onThemeButtonBgChanged: (v) => notifier.updateDraft(
          (d) => d.copyWith(themeButtonBgValue: v.value),
        ),
        onThemeButtonTextChanged: (v) => notifier.updateDraft(
          (d) => d.copyWith(themeButtonTextValue: v.value),
        ),
      ),
    );
  }

  Future<void> _onAppUpdate() async {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('앱 업데이트'),
        content: const Text('업데이트 기능은 현재 개발 중입니다.\n\n백엔드 API를 설정한 후 AppUpdateService를 구현하세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemTab() {
    final draft = ref.watch(adminDraftProvider).draft;
    final notifier = ref.read(adminDraftProvider.notifier);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: AdminSystemSection(
        onFirstScreen: () {
          Navigator.of(context).popUntil((r) => r.isFirst);
          ref.read(sessionControllerProvider.notifier).resetToIdle();
        },
        onMaintenanceScreen: () {
          ref.read(maintenanceModeProvider.notifier).state = true;
          Navigator.of(context).popUntil((r) => r.isFirst);
        },
        onVerificationCheck: () {
          Navigator.of(context).pushNamed(verificationRouteName);
        },
        onDeviceKeyChange: () {
          ref.read(deviceAuthControllerProvider.notifier).logout();
          Navigator.of(context).pushNamed(verificationRouteName);
        },
        onAppRestart: restartApp,
        onAppExit: exitApp,
        onAppUpdate: _onAppUpdate,
        debugDisablePhaseTimers: draft.debugDisablePhaseTimers,
        onDebugDisablePhaseTimersChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(debugDisablePhaseTimers: v)),
        debugSkipBackendApi: draft.debugSkipBackendApi,
        onDebugSkipBackendApiChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(debugSkipBackendApi: v)),
        debugPausePhotoCapture: draft.debugPausePhotoCapture,
        onDebugPausePhotoCaptureChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(debugPausePhotoCapture: v)),
        debugSkipDeviceConnection: draft.debugSkipDeviceConnection,
        onDebugSkipDeviceConnectionChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(debugSkipDeviceConnection: v)),
        bgmVolume: draft.bgmVolume,
        onBgmVolumeChanged: (v) =>
            notifier.updateDraft((d) => d.copyWith(bgmVolume: v)),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            border: isSelected
                ? Border(
                    right: BorderSide(color: colorScheme.primary, width: 3),
                  )
                : null,
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.08)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
