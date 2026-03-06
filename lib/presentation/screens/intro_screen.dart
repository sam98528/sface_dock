import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/app/sfacedock_app.dart';
import 'package:sfacedock/core/admin/controllers/admin_controller.dart';
import 'package:sfacedock/core/device/device_controller_proxy_provider.dart';
import 'package:sfacedock/core/services/image_prefetch_service.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';
import 'package:sfacedock/core/transitions/slide_animation_widget.dart';
import 'package:shimmer/shimmer.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen>
    with WidgetsBindingObserver {
  int _tapCount = 0;
  StreamSubscription<Map<String, dynamic>>? _eventSub;

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
    _eventSub = proxy.eventStream
        .where((e) => e['eventType'] == 'external_navigate')
        .listen((e) {
      final target = (e['data'] as Map<String, dynamic>?)?['target'];
      if (target == 'intro' && mounted) {
        proxy.stopSocketServer();
        Navigator.of(context).pushNamedAndRemoveUntil(
          introRouteName,
          (_) => false,
        );
      }
    });
  }

  /// RGB 프로그램을 최전방으로 전환
  Future<void> _startRgbSession() async {
    final admin = ref.read(adminControllerProvider);
    if (!admin.rgbEnabled || admin.rgbProcessName.isEmpty) return;

    final proxy = ref.read(deviceControllerProxyProvider);

    // 소켓 서버 시작 (활성화된 경우)
    if (admin.socketServerEnabled) {
      await proxy.startSocketServer(admin.socketServerPort);
    }

    // RGB 프로세스를 최전방으로
    await proxy.bringProcessToFront(
      targetProcess: admin.rgbProcessName,
      demoteProcess: 'sfacedock.exe',
    );
  }

  /// SFACE DOCK 로딩 화면으로 이동
  void _navigateToLoading() {
    // Pause pre-fetching while user is actively using the kiosk
    ref.read(imagePrefetchProvider.notifier).pause();
    Navigator.pushReplacementNamed(context, introLoadingRouteName);
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 40,
                              children: [
                                if (admin.rgbEnabled)
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    child: GestureDetector(
                                      onTap: _startRgbSession,
                                      child: Container(
                                        padding: const EdgeInsets.all(40),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
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
                                        child: Image.asset(
                                          'assets/images/RGB_image.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    child: GestureDetector(
                                      onTap: () {
                                        // AudioService.instance.playButtonSound();
                                        _navigateToLoading();
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
