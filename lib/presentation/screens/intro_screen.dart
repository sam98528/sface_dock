import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/app/sfacedock_app.dart';
import 'package:sfacedock/core/admin/controllers/admin_controller.dart';
import 'package:sfacedock/core/device/device_controller_proxy_provider.dart';
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

  // 디버그 오버레이 상태 (static → pushNamedAndRemoveUntil로 화면 재생성되어도 유지)
  Timer? _debugTimer;
  Timer? _hwPollTimer;
  static int _rgbSwitchCount = 0;
  int _memoryUsageMB = 0;
  bool _ipcConnected = false;
  String _cameraState = '-';
  String _paymentState = '-';
  String _printerState = '-';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenExternalNavigate();
      if (kDebugMode) _startDebugTimer();

      // IPC 연결 상태 변경 감시 — Admin에서 연결 후 복귀 시 리스너 재등록
      ref.listenManual(connectionStateProvider, (prev, next) {
        if (next == true && prev != true) {
          _listenExternalNavigate();
          _refreshHardwareInfo();
        }
      });
    });
  }

  @override
  void dispose() {
    _debugTimer?.cancel();
    _hwPollTimer?.cancel();
    _eventSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 디버그 오버레이 갱신 타이머
  void _startDebugTimer() {
    _refreshLightInfo(); // 즉시 1회
    _refreshHardwareInfo(); // 즉시 1회

    // 경량 정보 (메모리, IPC 상태) — 2초 주기
    _debugTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _refreshLightInfo();
    });

    // 하드웨어 상태 (detect_hardware IPC 호출) — 30초 주기
    _hwPollTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshHardwareInfo();
    });
  }

  /// 경량 정보 갱신 (IPC 호출 없음)
  void _refreshLightInfo() {
    if (!mounted) return;

    final rss = ProcessInfo.currentRss;
    final memMB = (rss / (1024 * 1024)).round();
    final proxy = ref.read(deviceControllerProxyProvider);

    setState(() {
      _memoryUsageMB = memMB;
      _ipcConnected = proxy.isConnected;
    });
  }

  /// 하드웨어 상태 갱신 (detect_hardware IPC 호출, 30초 주기)
  Future<void> _refreshHardwareInfo() async {
    if (!mounted) return;

    final proxy = ref.read(deviceControllerProxyProvider);
    if (!proxy.isConnected) return;

    try {
      final response = await proxy.sendCommand('detect_hardware', {
        'probe': 'false',
      });
      if (response != null && response['result'] is Map && mounted) {
        final summary = Map<String, dynamic>.from(response['result'] as Map);
        setState(() {
          _cameraState = summary['camera.stateString']?.toString() ?? '-';
          _paymentState = summary['payment.stateString']?.toString() ?? '-';
          _printerState = summary['printer.stateString']?.toString() ?? '-';
        });
      }
    } catch (_) {
      // 조회 실패 시 이전 값 유지
    }
  }

  /// external_navigate 이벤트 수신 (RGB 프로그램 → Flutter 복귀)
  void _listenExternalNavigate() {
    _eventSub?.cancel(); // 기존 구독 해제 (listener 누적 방지)
    final proxy = ref.read(deviceControllerProxyProvider);
    // IPC가 연결되어 있을 때만 이벤트 수신
    if (proxy.isConnected) {
      _eventSub = proxy.eventStream
          .where((e) => e['eventType'] == 'external_navigate')
          .listen((e) async {
            final target = (e['data'] as Map<String, dynamic>?)?['target'];
            if (target == 'intro' && mounted) {
              debugPrint('[IntroScreen] RGB → Flutter 복귀 시작');

              // Windows에서 Flutter 창 다시 표시 및 alwaysOnTop 활성화
              if (Platform.isWindows) {
                await windowManager.show();
                await windowManager.setAlwaysOnTop(true);
                await windowManager.focus();
              }

              // Intro 화면으로 복귀
              // (하드웨어 resume/detect/reconnect는 intro_loading_screen에서 처리)
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

    // 로딩 상태 시작 + RGB 전환 횟수 카운트
    setState(() {
      _isTransitioningToRGB = true;
      _rgbSwitchCount++;
    });

    try {
      if (Platform.isWindows) {
        final proxy = ref.read(deviceControllerProxyProvider);

        // IPC 연결된 경우에만 서비스 명령 실행
        if (proxy.isConnected) {
          _debugTimer?.cancel();
          _hwPollTimer?.cancel();
          debugPrint('[IntroScreen] Suspending hardware for RGB session...');
          await proxy.suspendHardware();
          debugPrint('[IntroScreen] Hardware suspended — proceeding to RGB');
        } else {
          debugPrint('[IntroScreen] IPC not connected - skipping service commands for RGB');
          _debugTimer?.cancel();
          _hwPollTimer?.cancel();
        }

        // 창 관리 (IPC 무관)
        await windowManager.setAlwaysOnTop(false);
        await Future.delayed(const Duration(milliseconds: 100));

        // RGB 전환 시 메모리 해제 — resume 시 prefetch가 다시 채움
        PaintingBinding.instance.imageCache.clear();
        PaintingBinding.instance.imageCache.clearLiveImages();

        debugPrint('[IntroScreen] Hiding Flutter window to release GPU resources...');
        await windowManager.hide();
        await Future.delayed(const Duration(milliseconds: 300));

        // RGB 프로세스 전환 (IPC 필요)
        if (proxy.isConnected) {
          debugPrint('[IntroScreen] Promoting RGB process with DWM refresh...');
          await proxy.bringProcessToFront(
            targetProcess: admin.rgbProcessName,
            demoteProcess: 'sfacedock.exe',
          );
          await Future.delayed(const Duration(milliseconds: 500));

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

          // 디버그 오버레이 (우측 상단) — debug 모드에서만 표시
          if (kDebugMode)
            Positioned(
              right: 16,
              top: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'monospace',
                    height: 1.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('DEBUG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('MEM: $_memoryUsageMB MB'),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('IPC: '),
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _ipcConnected ? Colors.greenAccent : Colors.redAccent,
                            ),
                          ),
                          Text(_ipcConnected ? ' Connected' : ' Disconnected'),
                        ],
                      ),
                      Text('CAM: $_cameraState'),
                      Text('PAY: $_paymentState'),
                      Text('PRN: $_printerState'),
                      Text('RGB전환: $_rgbSwitchCount회'),
                    ],
                  ),
                ),
              ),
            ),

        ],
      ),
    );
  }
}
