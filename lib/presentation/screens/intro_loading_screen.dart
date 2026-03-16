import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/app/sfacedock_app.dart';
import 'package:sfacedock/core/device/device_controller_proxy_provider.dart';
import 'package:sfacedock/core/admin/controllers/admin_controller.dart';
import 'package:sfacedock/core/services/image_prefetch_service.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';
import 'package:sfacedock/core/transitions/slide_animation_widget.dart';
import 'package:sfacedock/presentation/screens/maintenance_screen.dart';
import 'package:shimmer/shimmer.dart';

class IntroLoadingScreen extends ConsumerStatefulWidget {
  const IntroLoadingScreen({super.key});

  @override
  ConsumerState<IntroLoadingScreen> createState() => _IntroLoadingScreenState();
}

class _IntroLoadingScreenState extends ConsumerState<IntroLoadingScreen>
    with WidgetsBindingObserver {
  bool _isConnecting = true;
  bool _hasInitialized = false;
  bool _animationReady = false;
  bool _waitingForPrefetch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Precache the GIF before starting animation to avoid jank
      await precacheImage(
        const AssetImage('assets/images/loading_logo.gif'),
        context,
      );
      if (mounted) {
        setState(() => _animationReady = true);
      }
      _initializeAndNavigate();
    });
    _hasInitialized = true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasInitialized && !_isConnecting) {
      setState(() {
        _isConnecting = false;
      });
      debugPrint('🔄 돌아옴 - 연결 상태 초기화');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  /// 1. 장치 상태 검증 2. 다음 페이지로 이동 (IPC 연결은 main.dart에서 이미 완료)
  Future<void> _initializeAndNavigate() async {
    try {
      debugPrint('🔄 장치 초기화 시작');
      setState(() {
        _isConnecting = true;
      });

      // 최소 1.5초는 로딩 애니메이션을 보여줍니다.
      final loadingFuture = Future.delayed(const Duration(milliseconds: 1500));

      // 관리자 설정 최신화 확인 (초기 빈 껍데기 설정 대신 저장소 값 대기)
      await ref.read(adminControllerProvider.notifier).reload();
      final adminState = ref.read(adminControllerProvider);
      final proxy = ref.read(deviceControllerProxyProvider);

      // 최초 설정 미완료 시 Intro로 돌아간 뒤 Admin 화면을 push.
      // Admin X 버튼(pop) 시 Intro 화면으로 자연스럽게 복귀.
      if (!adminState.setupCompleted) {
        debugPrint('⚠️ 최초 설정이 필요합니다. Admin 화면으로 이동합니다.');
        await loadingFuture;
        if (!mounted) return;
        final nav = Navigator.of(context);
        nav.pushNamedAndRemoveUntil(introRouteName, (_) => false);
        nav.pushNamed(adminRouteName);
        return;
      }

      // 디버그 모드: 장비 연결 확인 스킵 옵션 체크
      if (adminState.debugSkipDeviceConnection) {
        debugPrint('🔧 [DEBUG] 장비 연결 확인 스킵 - 바로 다음 화면으로 이동');
        await loadingFuture;
        if (!mounted) return;
        ref.read(imagePrefetchProvider.notifier).start();
        await _waitForPrefetchAndNavigate();
        return;
      }

      // IPC 연결 확인 (main.dart에서 이미 연결되어 있어야 함)
      bool isConnected = proxy.isConnected;

      if (!isConnected) {
        debugPrint('⚠️ IPC not connected, attempting to connect for device initialization...');
        // SFACE 세션을 위해 연결 시도 (장비 초기화가 필요하므로)
        isConnected = await proxy.ensureConnected();

        if (!isConnected) {
          // 서비스 프로세스가 막 시작된 경우 Named Pipe 생성까지 시간이 걸림.
          // 최대 ~15초(500+750+1000+1500+2000+2500+3000+3500ms) 대기하며 재시도.
          const retryDelays = [
            Duration(milliseconds: 500),
            Duration(milliseconds: 750),
            Duration(milliseconds: 1000),
            Duration(milliseconds: 1500),
            Duration(milliseconds: 2000),
            Duration(milliseconds: 2500),
            Duration(milliseconds: 3000),
            Duration(milliseconds: 3500),
          ];

          for (var i = 0; i < retryDelays.length && !isConnected; i++) {
            debugPrint(
              '파이프 연결 재시도 중... 대기: ${retryDelays[i].inMilliseconds}ms (${i + 1}/${retryDelays.length})',
            );
            await Future<void>.delayed(retryDelays[i]);
            isConnected = await proxy.ensureConnected();
          }
        }
      } else {
        debugPrint('✅ IPC already connected - proceeding with device initialization');
      }

      // 연결 성공 시 Riverpod 상태 동기화
      if (isConnected && ref.exists(connectionStateProvider)) {
        ref.read(connectionStateProvider.notifier).state = true;
      }

      await loadingFuture; // 로딩 지연 동기화

      if (!mounted) return;

      if (!isConnected) {
        debugPrint('❌ IPC Pipe 연결 실패');
        _navigateToMaintenance(
          [],
          errorMessage: 'Device Service 서버(IPC)와 연결할 수 없습니다.\n프로그램이 실행 중인지 확인해주세요.',
        );
        return;
      }

      // 명시적 장비 초기화 (HARDWARE_RESUME) — 타임아웃 10초
      debugPrint('🔧 Initializing hardware devices...');
      try {
        await proxy.sendCommand('hardware_resume', {},
            timeout: const Duration(seconds: 10));
      } catch (e) {
        debugPrint('⚠️ hardware_resume 타임아웃 또는 실패: $e');
      }
      if (!mounted) return;

      // 파이프 연결 성공. 디바이스 검증.
      bool isAllDevicesReady = true;
      final List<String> disconnectedDevices = [];

      // detect_hardware 명령으로 실제 장비 상태 조회 — 타임아웃 15초
      Map<String, dynamic>? summary;
      try {
        final response = await proxy.sendCommand('detect_hardware', {
          'probe': 'true',
          'payment.enabled': adminState.paymentTerminalEnabled ? '1' : '0',
          'cash.enabled': adminState.cashDeviceEnabled ? '1' : '0',
        }, timeout: const Duration(seconds: 15));
        if (response != null && response['result'] is Map) {
          summary = Map<String, dynamic>.from(response['result'] as Map);
        }
      } catch (e) {
        debugPrint('❌ detect_hardware 호출 실패: $e');
      }

      // 디버그: 전체 summary 키 출력
      if (summary != null) {
        debugPrint('📋 Device summary keys: ${summary.keys.toList()}');
        summary.forEach((key, value) {
          if (key.contains('state')) {
            debugPrint('  $key = $value');
          }
        });
      }

      String? findDeviceState(String deviceType) {
        if (summary == null) return null;
        // 정확히 "deviceType.stateString" 키를 찾음 (예: "payment.stateString")
        final stateKey = '$deviceType.stateString';
        final value = summary[stateKey]?.toString();
        if (value != null) {
          debugPrint('🔍 Device state for $deviceType: $value (key: $stateKey)');
          return value.toUpperCase();
        }
        debugPrint('⚠️ Device state key not found: $stateKey');
        return null;
      }

      // 1. 프린터 체크 (필수)
      final printerState = findDeviceState('printer');
      if (printerState == 'DISCONNECTED' ||
          printerState == 'ERROR' ||
          printerState == null) {
        isAllDevicesReady = false;
        disconnectedDevices.add('프린터');
        debugPrint('Warning: Printer not ready: $printerState');
      }

      // 2. 카메라 체크 (필수)
      final cameraState = findDeviceState('camera');
      if (cameraState == 'DISCONNECTED' ||
          cameraState == 'ERROR' ||
          cameraState == null) {
        isAllDevicesReady = false;
        disconnectedDevices.add('카메라');
        debugPrint('Warning: Camera not ready: $cameraState');
      }

      // 3. 결제 단말기 체크 (어드민 설정 조건부)
      if (adminState.paymentTerminalEnabled) {
        final paymentState = findDeviceState('payment');
        debugPrint('💳 Payment terminal state: $paymentState');

        // 정상 상태: READY, IDLE, BUSY (어드민에서 "정상 작동 중"으로 표시되는 상태)
        // 비정상 상태: DISCONNECTED, ERROR
        // null: 아직 초기화 안 됨 (재시도 필요)
        if (paymentState == 'DISCONNECTED' || paymentState == 'ERROR') {
          isAllDevicesReady = false;
          disconnectedDevices.add('결제 단말기');
          debugPrint('❌ Payment terminal ERROR: $paymentState');
        } else if (paymentState == null) {
          // null인 경우 초기화 중일 수 있으므로 2초 대기 후 재시도
          debugPrint('⏳ Payment terminal state is null, retrying after 2 seconds...');
          await Future.delayed(const Duration(seconds: 2));

          // 재시도 시에도 detect_hardware를 다시 호출하여 최신 상태 확인
          try {
            final retryResponse = await proxy.sendCommand('detect_hardware', {
              'probe': 'false',
            });
            if (retryResponse != null && retryResponse['result'] is Map) {
              summary = Map<String, dynamic>.from(retryResponse['result'] as Map);
            }
          } catch (e) {
            debugPrint('❌ detect_hardware 재시도 실패: $e');
          }

          final retryPaymentState = findDeviceState('payment');
          debugPrint('💳 Payment terminal state after retry: $retryPaymentState');

          if (retryPaymentState == 'DISCONNECTED' || retryPaymentState == 'ERROR') {
            isAllDevicesReady = false;
            disconnectedDevices.add('결제 단말기');
            debugPrint('❌ Payment terminal still ERROR after retry: $retryPaymentState');
          } else if (retryPaymentState == null) {
            // 재시도 후에도 null이면 장비 미연결로 간주
            isAllDevicesReady = false;
            disconnectedDevices.add('결제 단말기');
            debugPrint('❌ Payment terminal still null after retry (not initialized)');
          } else {
            // READY, IDLE, BUSY 등은 정상
            debugPrint('✅ Payment terminal OK after retry: $retryPaymentState');
          }
        } else {
          // READY, IDLE, BUSY 등은 정상
          debugPrint('✅ Payment terminal OK: $paymentState');
        }
      }

      if (isAllDevicesReady) {
        debugPrint('✅ 장치 초기화 및 파이프 연결 확인 완료');
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        // 장비 검증 성공 후 prefetch 시작 (첫 진입: initialLoad, 재진입: deltaSync)
        ref.read(imagePrefetchProvider.notifier).start();
        await _waitForPrefetchAndNavigate();
      } else {
        if (!mounted) return;
        _navigateToMaintenance(disconnectedDevices);
      }
    } catch (e) {
      debugPrint('❌ IPC 연결 중 오류: $e');
      if (!mounted) return;
      _navigateToMaintenance([], errorMessage: '예기치 않은 오류가 발생했습니다.\n$e');
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  /// Wait for minimal prefetch cache (~20 images) then navigate.
  /// Remaining images continue caching in background on photo_grid.
  Future<void> _waitForPrefetchAndNavigate() async {
    setState(() => _waitingForPrefetch = true);

    // Poll until minimal cache is done (check every 200ms)
    while (mounted) {
      final prefetchState = ref.read(imagePrefetchProvider);
      if (prefetchState.isMinimalCacheDone) break;
      await Future.delayed(const Duration(milliseconds: 200));
    }

    if (!mounted) return;
    setState(() => _waitingForPrefetch = false);
    Navigator.pushReplacementNamed(context, photoGridRouteName);
  }

  void _navigateToMaintenance(
    List<String> disconnectedDevices, {
    String? errorMessage,
  }) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MaintenanceScreen(
          disconnectedDevices: disconnectedDevices,
          errorMessage: errorMessage,
        ),
        settings: const RouteSettings(name: maintenanceRouteName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final prefetchState = ref.watch(imagePrefetchProvider);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(64),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
            colors: [Color(0xFFFFBFE9), Color(0xFFDEBAF6), Color(0xFFA3F0E2)],
          ),
        ),
        child: Center(
          child: !_animationReady
              ? const SizedBox.shrink()
              : SlideAnimationWidget(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 1000,
                        height: 500,
                        child: Image.asset(
                          'assets/images/loading_logo.gif',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const CircularProgressIndicator(),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: KioskColors.tertiary,
                        highlightColor: KioskColors.primary.withValues(
                          alpha: 0.9,
                        ),
                        period: const Duration(milliseconds: 3000),
                        direction: ShimmerDirection.ltr,
                        child: Text(
                          _waitingForPrefetch
                              ? '사진을 준비하고 있어요!'
                              : '잠시만 기다려주세요!',
                          style: textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      if (_waitingForPrefetch) ...[
                        const SizedBox(height: 40),
                        SizedBox(
                          width: 500,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: prefetchState.cacheProgress,
                              minHeight: 8,
                              backgroundColor: Colors.white.withValues(alpha: 0.4),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                KioskColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
