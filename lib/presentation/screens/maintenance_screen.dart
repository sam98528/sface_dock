import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/app/sfacedock_app.dart';
import 'package:sfacedock/core/device/device_controller_proxy_provider.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';

/// 장비 점검 안내 화면.
/// 장비 오류 시 15초 카운트다운 후 intro_screen으로 복귀 (세션 종료 + 장치 연결 해제).
/// [disconnectedDevices]가 비어있으면 수동 점검 모드 (F4).
class MaintenanceScreen extends ConsumerStatefulWidget {
  final List<String> disconnectedDevices;
  final String? errorMessage;

  const MaintenanceScreen({
    super.key,
    this.disconnectedDevices = const [],
    this.errorMessage,
  });

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  static const int _autoReturnSec = 15;
  int _remaining = _autoReturnSec;
  Timer? _timer;
  bool _hasDeviceError = false;

  @override
  void initState() {
    super.initState();
    _hasDeviceError = widget.disconnectedDevices.isNotEmpty ||
        (widget.errorMessage != null && widget.errorMessage!.isNotEmpty);

    if (_hasDeviceError) {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) {
          t.cancel();
          return;
        }
        setState(() => _remaining--);
        if (_remaining <= 0) {
          t.cancel();
          _returnToIntro();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 세션 종료 + 장치 연결 해제 후 intro 화면으로 복귀
  Future<void> _returnToIntro() async {
    if (!mounted) return;

    final proxy = ref.read(deviceControllerProxyProvider);
    if (proxy.isConnected) {
      debugPrint('[MaintenanceScreen] Suspending hardware before returning to intro...');
      await proxy.suspendHardware();
    }

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(introRouteName, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: Container(
            constraints: const BoxConstraints(maxWidth: 580),
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 40,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.build_rounded,
                    size: 44,
                    color: Color(0xFFE65100),
                  ),
                ),
                const SizedBox(height: 28),

                // Title
                Text(
                  '기기 점검 중입니다',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Message
                Text(
                  '다른 룸을 이용해주세요.\n\n'
                  '불편을 드려 죄송합니다.\n'
                  '최대한 빨리 점검을 끝내도록 하겠습니다.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.black54,
                    height: 1.7,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),

                if (_hasDeviceError) ...[
                  const SizedBox(height: 40),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _remaining / _autoReturnSec,
                      minHeight: 8,
                      backgroundColor: Colors.black.withValues(alpha: 0.06),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        KioskColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$_remaining초 후 처음 화면으로 돌아갑니다',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else ...[
                  // Manual maintenance mode (F4) — spinner only
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        KioskColors.primary.withValues(alpha: 0.6),
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
