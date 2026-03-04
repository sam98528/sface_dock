// lib/widgets/phase_timeout_countdown.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/kiosk_typography.dart';

/// 전역으로 관리할 phase 타임아웃 종료 시간 Provider
final phaseTimeoutEndsAtProvider = StateProvider<DateTime?>((ref) => null);

/// 세션 화면 오른쪽 상단에 phase 타이머 남은 초를 실시간 표시.
/// phaseTimeoutEndsAtProvider가 null이면 미표시.
class PhaseTimeoutCountdown extends ConsumerStatefulWidget {
  const PhaseTimeoutCountdown({super.key});

  @override
  ConsumerState<PhaseTimeoutCountdown> createState() =>
      _PhaseTimeoutCountdownState();
}

class _PhaseTimeoutCountdownState extends ConsumerState<PhaseTimeoutCountdown> {
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final endsAt = ref.watch(phaseTimeoutEndsAtProvider);
    if (endsAt == null) {
      _ticker?.cancel();
      _ticker = null;
      return const SizedBox.shrink();
    }

    // 매 초 리빌드로 남은 시간 갱신
    if (_ticker == null || !_ticker!.isActive) {
      _ticker?.cancel();
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }

    final sec = endsAt.difference(DateTime.now()).inSeconds;
    final display = sec < 0 ? 0 : sec;
    final scheme = Theme.of(context).colorScheme;

    // 10초 이하일 때 빨간색 강조
    final isUrgent = display <= 10;
    final contentColor = isUrgent ? scheme.error : scheme.primary;
    final bgColor = scheme.surface; // 불투명 배경

    return Positioned(
      top: MediaQuery.paddingOf(context).top + 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: contentColor.withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_outlined, color: contentColor, size: 20),
            const SizedBox(width: 8),
            Text(
              '$display초',
              style: KioskTypography.textTheme.headlineSmall?.copyWith(
                color: contentColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
