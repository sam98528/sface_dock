import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';
import 'package:sfacedock/data/models/cart/cart_item.dart';
import 'package:sfacedock/presentation/providers/cart_provider.dart';
import '../components/cart_item_card.dart';
import '../components/cart_summary_panel.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
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
                return CartItemCard(item: cartItems[index], index: index);
              },
            ),
          ),
          const SizedBox(width: 24),
          CartSummaryPanel(
            cartItems: cartItems,
            totalPrice: totalPrice,
            totalItems: totalItems,
          ),
        ],
      ),
    );
  }
}
