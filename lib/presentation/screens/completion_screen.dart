import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/app/sfacedock_app.dart';
import 'package:sfacedock/core/device/device_controller_proxy_provider.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';
import 'package:sfacedock/presentation/providers/cart_provider.dart';
import 'package:shimmer/shimmer.dart';

/// 프린트 완료 화면
/// - 15초 타이머 후 자동으로 첫 화면(IntroScreen)으로 이동
/// - 세션 종료 (장바구니 초기화)
class CompletionScreen extends ConsumerStatefulWidget {
  const CompletionScreen({super.key});

  @override
  ConsumerState<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends ConsumerState<CompletionScreen> {
  int _remainingSeconds = 15;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _endSession();
      }
    });
  }

  void _endSession() {
    // 장바구니 초기화 (세션 종료)
    ref.read(cartProvider.notifier).clearCart();

    // Navigate immediately (don't block UI with IPC call)
    if (mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(introRouteName, (_) => false);
    }

    // Suspend hardware in background after navigation
    final proxy = ref.read(deviceControllerProxyProvider);
    if (proxy.isConnected) {
      proxy.suspendHardware().then((_) {
        debugPrint('[CompletionScreen] Hardware suspended - device ports released');
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(64),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.5, 1.0],
              colors: [Color(0xFFFFBFE9), Color(0xFFDEBAF6), Color(0xFFA3F0E2)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success icon
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 80,
                    color: KioskColors.success,
                  ),
                ),
                const SizedBox(height: 48),

                // Title
                Shimmer.fromColors(
                  baseColor: KioskColors.tertiary,
                  highlightColor: KioskColors.primary.withValues(alpha: 0.9),
                  period: const Duration(milliseconds: 2000),
                  direction: ShimmerDirection.ltr,
                  child: Text(
                    '인쇄가 완료되었습니다!',
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Message
                Text(
                  '사진을 출력구에서 가져가세요',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 64),

                // Helper text
                Text(
                  '$_remainingSeconds초 후 처음 화면으로 돌아갑니다',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 40),

                // Manual return button
                GestureDetector(
                  onTap: _endSession,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: KioskColors.primary.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.home_rounded,
                          color: KioskColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '바로 처음으로 돌아가기',
                          style: textTheme.titleMedium?.copyWith(
                            color: KioskColors.primary,
                            fontWeight: FontWeight.w700,
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
    );
  }
}
