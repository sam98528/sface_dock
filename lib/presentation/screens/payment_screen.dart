import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sfacedock/app/sfacedock_app.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';
import 'package:sfacedock/presentation/providers/cart_provider.dart';
import 'package:sfacedock/presentation/providers/payment_provider.dart';

final _priceFormatter = NumberFormat('#,###');

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  Timer? _autoAdvanceTimer;

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) _navigateToComplete();
    });
  }

  void _navigateToComplete() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      printLoadingRouteName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final phase = ref.watch(paymentPhaseProvider);
    final isDebug = ref.watch(paymentDebugModeProvider);

    // completed 상태 진입 시 자동 이동 타이머 시작
    ref.listen<PaymentPhase>(paymentPhaseProvider, (prev, next) {
      if (next == PaymentPhase.completed) {
        _startAutoAdvance();
      }
    });

    return PopScope(
      canPop: phase != PaymentPhase.processing,
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  colors: [KioskColors.primary, KioskColors.secondary],
                ),
              ),
            ),

            // Main content
            Center(child: _buildContent(phase)),

            // Top bar (back button, hidden during processing/completed)
            if (phase != PaymentPhase.processing &&
                phase != PaymentPhase.completed)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopBar(),
              ),

            // Debug panel
            if (isDebug)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildDebugPanel(phase),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final tt = Theme.of(context).textTheme;

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 56,
              padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
              decoration: BoxDecoration(
                color: KioskColors.surface,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.chevron_left,
                    color: KioskColors.primary,
                    size: 28,
                  ),
                  Text(
                    '돌아가기',
                    style: tt.titleMedium?.copyWith(
                      color: KioskColors.primary,
                      fontWeight: FontWeight.bold,
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

  Widget _buildContent(PaymentPhase phase) {
    switch (phase) {
      case PaymentPhase.idle:
        return _buildIdleContent();
      case PaymentPhase.processing:
        return _buildProcessingContent();
      case PaymentPhase.completed:
        return _buildCompletedContent();
      case PaymentPhase.cancelled:
        return _buildCancelledContent();
      case PaymentPhase.error:
        return _buildErrorContent();
    }
  }

  // --- IDLE ---
  Widget _buildIdleContent() {
    final tt = Theme.of(context).textTheme;
    final finalPrice = ref.watch(cartFinalPriceProvider);

    return Container(
      width: 480,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: KioskColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.payment,
              color: KioskColors.primary,
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '결제 금액',
            style: tt.titleMedium?.copyWith(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_priceFormatter.format(finalPrice)}원',
            style: tt.displayMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              ref.read(paymentProvider.notifier).startPayment(finalPrice);
            },
            child: Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                gradient: KioskColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: KioskColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.credit_card, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    '카드 결제',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.0,
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

  // --- PROCESSING ---
  Widget _buildProcessingContent() {
    final tt = Theme.of(context).textTheme;
    final finalPrice = ref.watch(cartFinalPriceProvider);

    return Container(
      width: 480,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: KioskColors.primary,
              backgroundColor: KioskColors.primary.withValues(alpha: 0.1),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '카드를 단말기에 대어주세요',
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${_priceFormatter.format(finalPrice)}원',
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: KioskColors.primary,
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              ref.read(paymentProvider.notifier).cancelPayment();
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: KioskColors.grey200, width: 1.5),
              ),
              child: Center(
                child: Text(
                  '결제 취소',
                  style: tt.labelLarge?.copyWith(
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPLETED ---
  Widget _buildCompletedContent() {
    final tt = Theme.of(context).textTheme;
    final result = ref.watch(paymentResultProvider);

    return Container(
      width: 480,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            '결제가 완료되었습니다',
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KioskColors.grey50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _infoRow(tt, '결제 금액',
                      '${_priceFormatter.format(result.amount)}원'),
                  if (result.cardNumber != null) ...[
                    const SizedBox(height: 8),
                    _infoRow(tt, '카드 번호', result.cardNumber!),
                  ],
                  if (result.approvalNumber != null) ...[
                    const SizedBox(height: 8),
                    _infoRow(tt, '승인 번호', result.approvalNumber!),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              _autoAdvanceTimer?.cancel();
              _navigateToComplete();
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: KioskColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '확인',
                  style: tt.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- CANCELLED ---
  Widget _buildCancelledContent() {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: 480,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.cancel_outlined, color: Colors.grey, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            '결제가 취소되었습니다',
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 32),
          _buildRetryAndBackButtons(tt),
        ],
      ),
    );
  }

  // --- ERROR ---
  Widget _buildErrorContent() {
    final tt = Theme.of(context).textTheme;
    final errorMsg = ref.watch(paymentProvider).errorMessage ?? '알 수 없는 오류';

    return Container(
      width: 480,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: KioskColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: KioskColors.error,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '결제에 실패하였습니다',
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            errorMsg,
            style: tt.bodyMedium?.copyWith(
              color: Colors.black.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildRetryAndBackButtons(tt),
        ],
      ),
    );
  }

  Widget _buildRetryAndBackButtons(TextTheme tt) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: KioskColors.grey200, width: 1.5),
              ),
              child: Center(
                child: Text(
                  '돌아가기',
                  style: tt.labelLarge?.copyWith(
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              ref.read(paymentProvider.notifier).reset();
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: KioskColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '다시 시도',
                  style: tt.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(TextTheme tt, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: tt.labelMedium?.copyWith(
            color: Colors.black.withValues(alpha: 0.5),
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: tt.labelMedium?.copyWith(color: Colors.black),
        ),
      ],
    );
  }

  // --- DEBUG PANEL ---
  Widget _buildDebugPanel(PaymentPhase phase) {
    final tt = Theme.of(context).textTheme;
    final finalPrice = ref.watch(cartFinalPriceProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'DEBUG MODE (결제 단말기 OFF)',
              style: tt.labelSmall?.copyWith(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (phase == PaymentPhase.processing) ...[
                  _debugButton('결제 완료', const Color(0xFF4CAF50), () {
                    ref
                        .read(paymentProvider.notifier)
                        .simulateComplete(finalPrice);
                  }),
                  const SizedBox(width: 12),
                  _debugButton('결제 실패', KioskColors.error, () {
                    ref
                        .read(paymentProvider.notifier)
                        .simulateError('디버그: 결제 실패 시뮬레이션');
                  }),
                  const SizedBox(width: 12),
                  _debugButton('결제 취소', Colors.grey, () {
                    ref.read(paymentProvider.notifier).simulateCancelled();
                  }),
                ] else ...[
                  Text(
                    phase == PaymentPhase.idle
                        ? '"카드 결제" 버튼을 눌러 시작하세요'
                        : '위 버튼으로 진행하세요',
                    style: tt.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _debugButton(String label, Color color, VoidCallback onTap) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: tt.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
