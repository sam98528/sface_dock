import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/app/sfacedock_app.dart';

import 'package:sfacedock/core/transitions/slide_animation_widget.dart';
import 'package:sfacedock/widgets/design_system/s_face_text.dart';
import 'package:shimmer/shimmer.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen>
    with WidgetsBindingObserver {
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// SFACE DOCK 로딩 화면으로 이동
  void _navigateToLoading() {
    Navigator.pushReplacementNamed(context, introLoadingRouteName);
  }

  // /// RGB 세션 시작 (실제 RGB 통합)
  // Future<void> _startRgbSession() async {
  //   // try {
  //   //   // 1. RGB 프로세스를 최전방으로 가져오기
  //   //   final windowManager = WindowManagerService.instance;
  //   //   // sfacedock or rgb studio excutable name
  //   //   final processSuccess = await windowManager.bringProcessToFront(
  //   //     'electron_test_app.exe', // 또는 실제 구동 환경에 맞게 RGB_Photo_Studio.exe
  //   //   );

  //   //   if (!processSuccess) {
  //   //     debugPrint('WARNING: RGB 프로세스를 찾을 수 없음 (계속 진행)');
  //   //   } else {
  //   //     debugPrint('OK: RGB 프로세스 최전방 이동 성공');
  //   //   }

  //   //   setState(() {
  //   //     _isRgbSessionActive = true;
  //   //   });
  //   // } catch (e) {
  //   //   debugPrint('ERROR: RGB 세션 시작 중 오류: $e');
  //   // }
  // }

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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 메인 화면 컨텐츠
                    FadeAnimationWidget(
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 40,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                child: GestureDetector(
                                  onTap: () {
                                    // AudioService가 sfacedock에 있는지 확인 필요, 없으면 주석처리 가능
                                    // AudioService.instance.playButtonSound();
                                    // _startRgbSession();
                                  },
                                  child: Container(
                                    width: 800,
                                    padding: const EdgeInsets.all(40),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
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
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                child: GestureDetector(
                                  onTap: () {
                                    // AudioService.instance.playButtonSound();
                                    _navigateToLoading();
                                  },
                                  child: Container(
                                    width: 800,
                                    padding: const EdgeInsets.all(0),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFff97d5),
                                      borderRadius: BorderRadius.circular(50),
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
                            ],
                          ),
                          const SizedBox(height: 80),
                          Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.white.withValues(alpha: 0.5),
                            period: const Duration(milliseconds: 3000),
                            direction: ShimmerDirection.ltr,
                            child: SFText.pre(
                              '화면을 터치해 시작해주세요!',
                              fontWeight: FontWeight.w900,
                              textAlign: TextAlign.center,
                              color: Colors.black,
                              fontSize: 48,
                            ),
                          ),
                        ],
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
        ],
      ),
    );
  }
}
