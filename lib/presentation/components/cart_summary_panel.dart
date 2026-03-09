import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app/sfacedock_app.dart';
import '../../core/theme/kiosk_colors.dart';
import '../../data/models/cart/cart_item.dart';
import '../../data/models/coupon/coupon_verify_result.dart';
import '../providers/cart_provider.dart';
import '../../core/services/audio_service.dart';
import '../screens/coupon_scanner_screen.dart';

final _priceFormatter = NumberFormat('#,###');

class CartSummaryPanel extends ConsumerWidget {
  final List<CartItem> cartItems;
  final int totalPrice;
  final int totalItems;

  const CartSummaryPanel({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final coupons = ref.watch(cartCouponsProvider);
    final totalDiscount = ref.watch(cartTotalDiscountProvider);
    final finalPrice = ref.watch(cartFinalPriceProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: KioskColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '결제 정보',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Container(height: 1, color: KioskColors.grey50),
            const SizedBox(height: 20),

            // Summary rows
            _summaryRow(tt, '총 수량', '$totalItems개'),
            const SizedBox(height: 12),
            _summaryRow(tt, '상품금액', '${_priceFormatter.format(totalPrice)}원'),
            if (coupons.isNotEmpty) ...[
              const SizedBox(height: 12),
              _summaryRow(
                tt,
                '할인 금액',
                '-${_priceFormatter.format(totalDiscount)}원',
                valueColor: KioskColors.primary,
              ),
              const SizedBox(height: 12),
              _summaryRow(tt, '사용한 쿠폰', '${coupons.length}개'),
            ],

            const SizedBox(height: 16),

            // Coupon Section
            const Spacer(),
            if (coupons.isNotEmpty) ...[
              ...coupons.map(
                (coupon) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: KioskColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.confirmation_number,
                          color: KioskColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coupon.name,
                                style: tt.labelSmall?.copyWith(
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '-${_priceFormatter.format(coupon.discountAmount)}원',
                                style: tt.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: KioskColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.playTapSound();
                            ref
                                .read(cartProvider.notifier)
                                .removeCoupon(coupon.code);
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: KioskColors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: KioskColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),

            // Total
            Container(height: 1, color: KioskColors.grey100),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '총 금액',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${_priceFormatter.format(finalPrice)}원',
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: KioskColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Coupon Register Button
            GestureDetector(
              onTap: cartItems.isEmpty
                  ? null
                  : () async {
                      context.playTapSound();
                      final result =
                          await Navigator.push<CouponVerifyResult>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CouponScannerScreen(),
                        ),
                      );
                      if (result != null && result.valid && context.mounted) {
                        _handleCouponResult(context, ref, result);
                      }
                    },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: cartItems.isNotEmpty
                        ? KioskColors.primary
                        : KioskColors.grey200,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      color: cartItems.isNotEmpty
                          ? KioskColors.primary
                          : KioskColors.grey200,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '쿠폰 등록하기',
                      style: tt.labelMedium?.copyWith(
                        color: cartItems.isNotEmpty
                            ? KioskColors.primary
                            : KioskColors.grey200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Checkout Button
            GestureDetector(
              onTap: cartItems.isEmpty
                  ? null
                  : () async {
                      context.playTapSound();
                      // 쿠폰 사용 확인 다이얼로그
                      if (coupons.isNotEmpty) {
                        final confirmed = await _showCouponUsageConfirmDialog(context);
                        if (!confirmed) return;
                      }
                      if (context.mounted) {
                        // 0원이면 결제 화면 건너뛰고 바로 프린트 화면으로
                        if (finalPrice == 0) {
                          Navigator.of(context).pushNamed(printLoadingRouteName);
                        } else {
                          Navigator.of(context).pushNamed(paymentRouteName);
                        }
                      }
                    },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: cartItems.isNotEmpty
                      ? KioskColors.primaryGradient
                      : null,
                  color: cartItems.isEmpty ? KioskColors.grey200 : null,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: cartItems.isNotEmpty
                      ? [
                          BoxShadow(
                            color:
                                KioskColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    finalPrice == 0 ? '프린트하기' : '결제하기',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    TextTheme tt,
    String label,
    String value, {
    Color? valueColor,
  }) {
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
          style: tt.labelMedium?.copyWith(color: valueColor ?? Colors.black),
        ),
      ],
    );
  }

  void _handleCouponResult(
    BuildContext context,
    WidgetRef ref,
    CouponVerifyResult result,
  ) {
    final notifier = ref.read(cartProvider.notifier);
    final cart = ref.read(cartProvider);
    final code = result.couponCode!;
    final name = result.couponName ?? '쿠폰';
    final discountType = result.couponDiscountType ?? 'free';
    final discountPrice = result.couponDiscountPrice;

    if (cart.isCouponApplied(code)) {
      _showCouponInfoDialog(
        context: context,
        title: '이미 등록된 쿠폰',
        message: '동일한 쿠폰이 이미 장바구니에 등록되어 있습니다.',
      );
      return;
    }

    final newDiscount = notifier.estimateCouponDiscount(discountType);
    final currentDiscount = cart.totalCouponDiscount;
    final totalPrice = cart.totalPrice;

    if (currentDiscount >= totalPrice) {
      _showCouponInfoDialog(
        context: context,
        title: '쿠폰 등록 불가',
        message: '이미 할인 금액이 결제 금액을 초과하였습니다.\n추가 쿠폰을 등록할 수 없습니다.',
      );
      return;
    }

    if (currentDiscount + newDiscount > totalPrice) {
      final excess = currentDiscount + newDiscount - totalPrice;
      _showCouponInfoDialog(
        context: context,
        title: '할인 금액 초과',
        message:
            '이 쿠폰을 적용하면 할인 금액이 결제 금액보다 '
            '${_priceFormatter.format(excess)}원 초과됩니다.\n'
            '초과분은 환불되지 않습니다.\n그래도 사용하시겠습니까?',
        confirmText: '사용하기',
        onConfirm: () {
          notifier.applyCoupon(code, name, discountType, discountPrice: discountPrice);
        },
      );
      return;
    }

    notifier.applyCoupon(code, name, discountType, discountPrice: discountPrice);
  }

  Future<void> _showCouponInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
  }) async {
    final tt = Theme.of(context).textTheme;
    final hasConfirm = onConfirm != null;

    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: KioskColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.confirmation_number,
                  color: KioskColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: tt.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (hasConfirm) ...[
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ctx.playTapSound();
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: KioskColors.grey200,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '취소',
                              style: tt.labelLarge?.copyWith(
                                color:
                                    Colors.black.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ctx.playTapSound();
                          Navigator.pop(ctx);
                          onConfirm();
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: KioskColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              confirmText ?? '확인',
                              style: tt.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                GestureDetector(
                  onTap: () {
                    ctx.playTapSound();
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: KioskColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '확인',
                        style:
                            tt.labelLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showCouponUsageConfirmDialog(BuildContext context) async {
    final tt = Theme.of(context).textTheme;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: KioskColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: KioskColors.warning,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '쿠폰 사용 확인',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '쿠폰을 사용한 후에는 취소가 불가능합니다.\n계속 진행하시겠습니까?',
                style: tt.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ctx.playTapSound();
                        Navigator.pop(ctx, false);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: KioskColors.grey200,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '취소',
                            style: tt.labelLarge?.copyWith(
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ctx.playTapSound();
                        Navigator.pop(ctx, true);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: KioskColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '확인',
                            style: tt.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return result ?? false;
  }
}
