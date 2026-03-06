import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sfacedock/app/sfacedock_app.dart';
import 'package:sfacedock/core/constants/api_constants.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';
import 'package:sfacedock/data/models/cart/cart_item.dart';
import 'package:sfacedock/data/models/coupon/coupon_verify_result.dart';
import 'package:sfacedock/presentation/providers/cart_provider.dart';
import 'package:sfacedock/presentation/screens/coupon_scanner_screen.dart';

final _priceFormatter = NumberFormat('#,###');

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String _getImageUrl(String imagePath) {
    return '${ApiConstants.awsIp}$imagePath';
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    final totalPrice = ref.watch(cartTotalPriceProvider);
    final totalItems = ref.watch(cartTotalItemsProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                colors: [KioskColors.primary, KioskColors.secondary],
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              _buildTopBar(context, totalItems),
              Expanded(
                child: cartItems.isEmpty
                    ? _buildEmptyCart(context)
                    : _buildCartContent(cartItems, totalPrice, totalItems),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, int totalItems) {
    final tt = Theme.of(context).textTheme;

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            KioskColors.grey400.withValues(alpha: 0.7),
            KioskColors.grey400.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Row(
        children: [
          // Back Button
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

          const Spacer(),

          // Title
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: KioskColors.surface.withValues(alpha: 0.9),
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
                  Icons.shopping_bag_outlined,
                  color: KioskColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  '장바구니',
                  style: tt.titleMedium?.copyWith(
                    color: KioskColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (totalItems > 0) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: KioskColors.primaryGradient,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$totalItems',
                      style: tt.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Spacer(),

          const SizedBox(width: 120),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 56,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '장바구니가 비어있습니다',
            style: tt.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '사진을 선택하여 장바구니에 담아보세요',
            style: tt.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
    List<CartItem> cartItems,
    int totalPrice,
    int totalItems,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 24,
                mainAxisSpacing: 32,
                childAspectRatio: 0.52,
              ),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartCard(cartItems[index], index);
              },
            ),
          ),
          const SizedBox(width: 24),
          _buildSummaryPanel(cartItems, totalPrice, totalItems),
        ],
      ),
    );
  }

  Widget _buildCartCard(CartItem item, int index) {
    final tt = Theme.of(context).textTheme;
    final mainImage = item.photoData.feedsImgAttach.isNotEmpty
        ? item.photoData.feedsImgAttach.first
        : null;

    final rotation = (index % 4 == 0)
        ? 0.02
        : (index % 4 == 1)
        ? -0.015
        : (index % 4 == 2)
        ? 0.01
        : -0.025;

    return Center(
      child: Transform.rotate(
        angle: rotation,
        filterQuality: FilterQuality.high,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(4, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 4 / 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: KioskColors.black,
                    borderRadius: BorderRadius.circular(1),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (mainImage != null)
                        CachedNetworkImage(
                          imageUrl: _getImageUrl(mainImage.attachFilePath),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.medium,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.broken_image,
                            color: KioskColors.grey200,
                            size: 32,
                          ),
                        )
                      else
                        const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: KioskColors.grey200,
                            size: 32,
                          ),
                        ),
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 28,
                            height: 28,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: KioskColors.grey50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSimpleStepperBtn(
                            icon: Icons.remove,
                            enabled: item.quantity > 1,
                            onTap: () => ref
                                .read(cartProvider.notifier)
                                .updateQuantity(
                                  item.feedsIdx,
                                  item.quantity - 1,
                                ),
                          ),
                          Text(
                            '${item.quantity}',
                            style: tt.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          _buildSimpleStepperBtn(
                            icon: Icons.add,
                            enabled: item.quantity < 5,
                            onTap: () => ref
                                .read(cartProvider.notifier)
                                .updateQuantity(
                                  item.feedsIdx,
                                  item.quantity + 1,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => ref
                        .read(cartProvider.notifier)
                        .removeItem(item.feedsIdx),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: KioskColors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: KioskColors.error,
                        size: 28,
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
  }

  Widget _buildSimpleStepperBtn({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(
          icon,
          size: 24,
          color: enabled ? KioskColors.primary : KioskColors.grey200,
        ),
      ),
    );
  }

  Future<void> _showCouponInfoDialog({
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
                        onTap: () => Navigator.pop(ctx),
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
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: KioskColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
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
            ],
          ),
        ),
      ),
    );
  }

  void _handleCouponResult(CouponVerifyResult result) {
    final notifier = ref.read(cartProvider.notifier);
    final cart = ref.read(cartProvider);
    final code = result.couponCode!;
    final name = result.couponName ?? '쿠폰';
    final discountType = result.couponDiscountType ?? 'free';

    // 1) 중복 체크
    if (cart.isCouponApplied(code)) {
      _showCouponInfoDialog(
        title: '이미 등록된 쿠폰',
        message: '동일한 쿠폰이 이미 장바구니에 등록되어 있습니다.',
      );
      return;
    }

    final newDiscount = notifier.estimateCouponDiscount(discountType);
    final currentDiscount = cart.totalCouponDiscount;
    final totalPrice = cart.totalPrice;

    // 2) 이미 할인이 결제금액을 넘은 상태
    if (currentDiscount >= totalPrice) {
      _showCouponInfoDialog(
        title: '쿠폰 등록 불가',
        message: '이미 할인 금액이 결제 금액을 초과하였습니다.\n추가 쿠폰을 등록할 수 없습니다.',
      );
      return;
    }

    // 3) 이 쿠폰을 적용하면 할인이 결제금액을 초과하는 경우 → 확인 요청
    if (currentDiscount + newDiscount > totalPrice) {
      final excess = currentDiscount + newDiscount - totalPrice;
      _showCouponInfoDialog(
        title: '할인 금액 초과',
        message:
            '이 쿠폰을 적용하면 할인 금액이 결제 금액보다 '
            '${_priceFormatter.format(excess)}원 초과됩니다.\n'
            '초과분은 환불되지 않습니다.\n그래도 사용하시겠습니까?',
        confirmText: '사용하기',
        onConfirm: () {
          notifier.applyCoupon(code, name, discountType);
        },
      );
      return;
    }

    // 4) 정상 적용
    notifier.applyCoupon(code, name, discountType);
  }

  Widget _buildSummaryPanel(
    List<CartItem> cartItems,
    int totalPrice,
    int totalItems,
  ) {
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
                      final result = await Navigator.push<CouponVerifyResult>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CouponScannerScreen(),
                        ),
                      );
                      if (result != null && result.valid && mounted) {
                        _handleCouponResult(result);
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
                  : () {
                      Navigator.of(context).pushNamed(paymentRouteName);
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
                            color: KioskColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '결제하기',
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
}
