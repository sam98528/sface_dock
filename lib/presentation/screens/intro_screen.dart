import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/app/sfacedock_app.dart';
import 'package:sfacedock/core/admin/controllers/admin_controller.dart';
import 'package:sfacedock/core/device/device_controller_proxy_provider.dart';
import 'package:sfacedock/core/services/image_prefetch_service.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';
import 'package:sfacedock/core/transitions/slide_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:window_manager/window_manager.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen>
    with WidgetsBindingObserver {
  int _tapCount = 0;
  StreamSubscription<Map<String, dynamic>>? _eventSub;
  bool _isTransitioningToRGB = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Start background pre-fetching of kiosk photos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(imagePrefetchProvider.notifier).start();
      _listenExternalNavigate();
    });
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// external_navigate 이벤트 수신 (RGB 프로그램 → Flutter 복귀)
  void _listenExternalNavigate() {
    final proxy = ref.read(deviceControllerProxyProvider);
    // IPC가 연결되어 있을 때만 이벤트 수신
    if (proxy.isConnected) {
      _eventSub = proxy.eventStream
          .where((e) => e['eventType'] == 'external_navigate')
          .listen((e) async {
            final target = (e['data'] as Map<String, dynamic>?)?['target'];
            if (target == 'intro' && mounted) {
              // 소켓 서버 중지 (명령이 서비스에 구현되지 않았으므로 에러 무시)
              try {
                await proxy.stopSocketServer();
              } catch (e) {
                debugPrint(
                  '[IntroScreen] stopSocketServer failed (ignored): $e',
                );
              }

              // 하드웨어 포트 재초기화 (RGB 세션 종료)
              debugPrint(
                '[IntroScreen] Resuming hardware after RGB session...',
              );
              await proxy.resumeHardware();
              debugPrint('[IntroScreen] Hardware resumed - RGB session ended');

              // 카메라 재연결 시도 (RGB에서 돌아온 후)
              debugPrint('[IntroScreen] Checking camera connection...');
              await Future.delayed(const Duration(milliseconds: 500));

              // detect_hardware로 카메라 상태 확인
              final response = await proxy.sendCommand('detect_hardware', {
                'probe': 'false',
              });

              if (response != null && response['result'] is Map) {
                final summary = Map<String, dynamic>.from(response['result'] as Map);
                final cameraState = summary['camera.stateString']?.toString().toUpperCase();

                debugPrint('[IntroScreen] Camera state after resume: $cameraState');

                // 카메라가 연결 해제 상태면 재연결 시도
                if (cameraState == 'DISCONNECTED' || cameraState == 'ERROR' || cameraState == null) {
                  debugPrint('[IntroScreen] Camera disconnected, attempting reconnect...');
                  await proxy.reconnectCamera();
                  await Future.delayed(const Duration(seconds: 1));

                  // 재연결 후 상태 재확인
                  final retryResponse = await proxy.sendCommand('detect_hardware', {
                    'probe': 'false',
                  });

                  if (retryResponse != null && retryResponse['result'] is Map) {
                    final retrySummary = Map<String, dynamic>.from(retryResponse['result'] as Map);
                    final retryCameraState = retrySummary['camera.stateString']?.toString().toUpperCase();
                    debugPrint('[IntroScreen] Camera state after reconnect: $retryCameraState');
                  }
                }
              }

              // Windows에서 Flutter 창 다시 표시 및 alwaysOnTop 활성화
              if (Platform.isWindows) {
                await windowManager.show();
                await windowManager.setAlwaysOnTop(true);
                await windowManager.focus();
              }

              // Intro 화면으로 복귀
              if (mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(introRouteName, (_) => false);
              }
            }
          });
    }
  }

  /// RGB 프로그램을 최전방으로 전환
  Future<void> _startRgbSession() async {
    final admin = ref.read(adminControllerProvider);
    if (!admin.rgbEnabled || admin.rgbProcessName.isEmpty) return;

    // 로딩 상태 시작
    setState(() {
      _isTransitioningToRGB = true;
    });

    final proxy = ref.read(deviceControllerProxyProvider);

    try {
      // Windows에서만 동작
      if (Platform.isWindows) {
        // 1. IPC 연결 확인 (main.dart에서 이미 연결되어 있어야 함)
        debugPrint('[IntroScreen] Checking IPC connection for RGB session...');
      if (!proxy.isConnected) {
        debugPrint('[IntroScreen] IPC not connected, attempting to connect...');
        final connected = await proxy.ensureConnected();
        if (!connected) {
          debugPrint('[IntroScreen] IPC connection failed for RGB mode');
          debugPrint('[IntroScreen] RGB navigation will not work properly');
          // 연결 실패해도 RGB 프로그램 자체는 실행되도록 계속 진행
        }
      } else {
        debugPrint(
          '[IntroScreen] IPC already connected - RGB navigation ready',
        );
      }

      // 연결 상태 업데이트
      ref.read(connectionStateProvider.notifier).state = proxy.isConnected;

      // 2. external_navigate 이벤트 리스너 설정
      _listenExternalNavigate();

      // 5. 창 전환 전에 충분히 대기 (저사양 PC 대응: 300ms -> 800ms)

      // 6. 소켓 서버 시작 (활성화된 경우)
      if (admin.socketServerEnabled) {
        await proxy.startSocketServer(admin.socketServerPort);
      }

      // 7. 하드웨어 포트 해제 (RGB가 카메라/결제단말 사용할 수 있도록)
      debugPrint('[IntroScreen] Suspending hardware for RGB session...');
      await proxy.suspendHardware();

      // // 4. Flutter 창을 최소화하여 간섭 방지
      // await windowManager.minimize();

      // 3. SFaceDock의 alwaysOnTop 해제 (Z-order 충돌 방지)
      await windowManager.setAlwaysOnTop(false);
      await Future.delayed(const Duration(milliseconds: 100));

      // 3-1. Flutter 창을 완전히 숨겨서 GPU 리소스 해제
      debugPrint('[IntroScreen] Hiding Flutter window to release GPU resources...');
      await windowManager.hide();  // minimize 대신 hide 사용
      await Future.delayed(const Duration(milliseconds: 300));

      // 8. RGB 프로세스를 최전방으로 전환 (DWM 강제 갱신 포함)
      debugPrint('[IntroScreen] Promoting RGB process with DWM refresh...');
      await proxy.bringProcessToFront(
        targetProcess: admin.rgbProcessName,
        demoteProcess: 'sfacedock.exe',
      );

      // 9. DWM 갱신 완료 대기 (저사양 PC 대응)
      await Future.delayed(const Duration(milliseconds: 500));

      // 10. 저사양 PC를 위한 보조 시도 (2초 후 다시 한번 호출하여 포커스 보장)
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          debugPrint(
            '[IntroScreen] Promoting RGB process (Secondary retry)...',
          );
          proxy.bringProcessToFront(
            targetProcess: admin.rgbProcessName,
            demoteProcess: 'sfacedock.exe',
          );
        }
      });
      }
    } finally {
      // 로딩 상태 종료
      if (mounted) {
        setState(() {
          _isTransitioningToRGB = false;
        });
      }
    }
  }

  /// SFACE DOCK 로딩 화면으로 이동
  Future<void> _navigateToLoading() async {
    // Pause pre-fetching while user is actively using the kiosk
    ref.read(imagePrefetchProvider.notifier).pause();

    // Check IPC connection status (should already be connected from main.dart)
    final proxy = ref.read(deviceControllerProxyProvider);
    debugPrint('[IntroScreen] Checking IPC connection for SFace session...');

    // Update connection state based on current status
    ref.read(connectionStateProvider.notifier).state = proxy.isConnected;

    if (proxy.isConnected) {
      debugPrint(
        '[IntroScreen] IPC already connected - proceeding to loading screen',
      );
    } else {
      debugPrint(
        '[IntroScreen] IPC not connected - loading screen will handle device initialization',
      );
    }

    // Navigate to loading screen
    // The loading screen will handle device initialization
    if (mounted) {
      Navigator.pushReplacementNamed(context, introLoadingRouteName);
    }
  }

  /// 숨겨진 설정 버튼 탭 핸들러 (5번 탭하면 설정 화면으로)
  void _handleHiddenSetupTap() {
    setState(() {
      _tapCount++;
    });

    if (_tapCount >= 5) {
      _tapCount = 0;
      Navigator.pushNamed(context, '/admin'); // Admin 화면 라우팅
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch prefetch state to show sync status indicator
    final prefetchState = ref.watch(imagePrefetchProvider);
    final admin = ref.watch(adminControllerProvider);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(64),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 1.0],
                colors: [
                  Color(0xFFFFBFE9),
                  Color(0xFFDEBAF6),
                  Color(0xFFA3F0E2),
                ],
              ),
            ),
            child: Center(
              child: SlideAnimationWidget(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 메인 화면 컨텐츠
                    Flexible(
                      child: FadeAnimationWidget(
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              spacing: 40,
                              children: [
                                if (admin.rgbEnabled)
                                  SizedBox(
                                    width: 800,
                                    height: 700,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      curve: Curves.easeInOut,
                                      child: GestureDetector(
                                        onTap: _isTransitioningToRGB ? null : _startRgbSession,
                                        child: Container(
                                          padding: const EdgeInsets.all(40),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: _isTransitioningToRGB ? 0.5 : 0.8,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            border: Border.all(
                                              color: const Color(
                                                0xFF000000,
                                              ).withValues(alpha: 0.05),
                                              width: 5,
                                              strokeAlign:
                                                  BorderSide.strokeAlignInside,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.1,
                                                ),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              AnimatedOpacity(
                                                opacity: _isTransitioningToRGB ? 0.3 : 1.0,
                                                duration: const Duration(milliseconds: 200),
                                                child: Image.asset(
                                                  'assets/images/RGB_image.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              if (_isTransitioningToRGB)
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withValues(alpha: 0.3),
                                                    borderRadius: BorderRadius.circular(45),
                                                  ),
                                                  child: const Center(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          width: 60,
                                                          height: 60,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 5,
                                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                              Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Text(
                                                          'RGB로 전환 중...',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  width: 800,
                                  height: 700,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    child: GestureDetector(
                                      onTap: () async {
                                        // AudioService.instance.playButtonSound();
                                        await _navigateToLoading();
                                      },
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFff97d5),
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xFFF475C1,
                                            ).withValues(alpha: 0.1),
                                            strokeAlign:
                                                BorderSide.strokeAlignOutside,
                                            width: 5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          'assets/images/sface_image.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 80),
                            Shimmer.fromColors(
                              baseColor: KioskColors.tertiary,
                              highlightColor: KioskColors.primary.withValues(
                                alpha: 0.9,
                              ),
                              period: const Duration(milliseconds: 3000),
                              direction: ShimmerDirection.ltr,
                              child: Text(
                                '화면을 터치해 시작해주세요!',
                                style: textTheme.displaySmall?.copyWith(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 숨겨진 설정 버튼 (좌측 하단)
          Positioned(
            left: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _handleHiddenSetupTap,
              child: Container(
                width: 80,
                height: 80,
                color: Colors.transparent,
                child: _tapCount > 0
                    ? Center(
                        child: Text(
                          '$_tapCount',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),

          // Pre-fetch status indicator (하단 우측, 디버그용)
          if (prefetchState.isSyncing)
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${prefetchState.photos.length}장 준비됨',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
