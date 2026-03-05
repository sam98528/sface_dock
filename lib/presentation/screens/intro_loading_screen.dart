import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/app/sfacedock_app.dart';
import 'package:sfacedock/core/device/device_controller_proxy_provider.dart';
import 'package:sfacedock/core/admin/controllers/admin_controller.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';
import 'package:sfacedock/core/transitions/slide_animation_widget.dart';
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

  /// 1. 파이프 연결. 2. 장치 상태 검증 3. 다음 페이지.
  Future<void> _initializeAndNavigate() async {
    try {
      debugPrint('🔄 IPC 및 장치 초기화 시작');
      setState(() {
        _isConnecting = true;
      });

      // 최소 1.5초는 로딩 애니메이션을 보여줍니다.
      final loadingFuture = Future.delayed(const Duration(milliseconds: 1500));

      // 관리자 설정 최신화 확인 (초기 빈 껍데기 설정 대신 저장소 값 대기)
      await ref.read(adminControllerProvider.notifier).reload();
      final adminState = ref.read(adminControllerProvider);
      final proxy = ref.read(deviceControllerProxyProvider);

      // 디버그 모드: 장비 연결 확인 스킵 옵션 체크
      if (adminState.debugSkipDeviceConnection) {
        debugPrint('🔧 [DEBUG] 장비 연결 확인 스킵 - 바로 다음 화면으로 이동');
        await loadingFuture;
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, photoGridRouteName);
        return;
      }

      // IPC Pipe 연결 체크 - ai-kiosk-client 방식의 Exponential Backoff 재시도 로직
      bool isConnected = await proxy.ensureConnected();

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

      // 연결 성공 시 Riverpod 상태 동기화
      if (isConnected && ref.exists(connectionStateProvider)) {
        ref.read(connectionStateProvider.notifier).state = true;
      }

      await loadingFuture; // 로딩 지연 동기화

      if (!mounted) return;

      if (!isConnected) {
        debugPrint('❌ IPC Pipe 연결 실패');
        _showErrorDialog(
          'Device Service 서버(IPC)와 연결할 수 없습니다.\n프로그램이 실행 중인지 확인해주세요.',
        );
        return;
      }

      // 파이프 연결 성공. 디바이스 검증.
      bool isAllDevicesReady = true;
      final List<String> disconnectedDevices = [];

      final deviceSummary = await proxy.getDeviceSummary();
      final summary = deviceSummary.summary;

      String? findDeviceState(String deviceType) {
        if (summary == null) return null;
        for (final key in summary.keys) {
          if (key.contains(deviceType) && key.endsWith('.stateString')) {
            return summary[key]?.toString().toUpperCase();
          }
        }
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
        if (paymentState == 'DISCONNECTED' ||
            paymentState == 'ERROR' ||
            paymentState == null) {
          isAllDevicesReady = false;
          disconnectedDevices.add('결제 단말기');
          debugPrint('Warning: Payment terminal not ready: $paymentState');
        }
      }

      if (isAllDevicesReady) {
        debugPrint('✅ 장치 초기화 및 파이프 연결 확인 완료');
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, photoGridRouteName);
      } else {
        final deviceListStr = disconnectedDevices.join(', ');
        _showErrorDialog(
          '다음 장치를 연결할 수 없습니다:\n$deviceListStr\n케이블 상태를 확인해 주세요.',
        );
      }
    } catch (e) {
      debugPrint('❌ IPC 연결 중 오류: $e');
      if (!mounted) return;
      _showErrorDialog('예기치 않은 오류가 발생했습니다.\n$e');
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  void _showErrorDialog(String bodyMessage) {
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 28),
            const SizedBox(height: 12),
            Text(
              '오류가 발생했습니다',
              style: textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              bodyMessage,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  // 다시 시도
                  await _retryConnection();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF475C1), // ColorName.pink
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  '다시 시도',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, introRouteName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  '돌아가기',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _retryConnection() async {
    try {
      setState(() {
        _isConnecting = true;
      });

      final proxy = ref.read(deviceControllerProxyProvider);
      proxy.disconnect();
      debugPrint('🔄 기존 파이프 연결 해제 완료');

      await Future.delayed(const Duration(milliseconds: 1000));
      await _initializeAndNavigate();
    } catch (e) {
      debugPrint('❌ 재연결 시도 중 오류: $e');
      if (mounted) {
        _showErrorDialog('재연결 중 오류가 발생했습니다.\n$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                          // If file unavailable, it will throw. Ensure asset exists.
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
                          '잠시만 기다려주세요!',
                          style: textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
