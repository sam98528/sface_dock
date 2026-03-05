import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/data/models/cart/cart_item.dart';
import 'package:sfacedock/presentation/components/quantity_stepper.dart';
import 'package:sfacedock/presentation/providers/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  late ScrollController _scrollController;
  bool _showGradient = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      setState(() {
        _showGradient = maxScroll > 0 && currentScroll < maxScroll - 10;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getImageUrl(String imagePath) {
    const awsIp = 'https://d37j40e2wj9q14.cloudfront.net/';
    return '$awsIp$imagePath';
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    final totalPrice = ref.watch(cartTotalPriceProvider);
    final totalItems = ref.watch(cartTotalItemsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.only(bottom: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            colors: [
              Color(0xFFFF97D5), // ColorName.pink
              Color(0xFF67EBD6), // ColorName.mint
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Navigation Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '돌아가기',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '장바구니',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 150),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: cartItems.isEmpty
                    ? _buildEmptyCart()
                    : _buildCartContent(cartItems, totalPrice, totalItems),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 24),
          Text(
            '장바구니가 비어있습니다',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '사진을 선택하여 장바구니에 담아보세요',
            style: TextStyle(
              fontSize: 18,
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Cart Item List
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final mainImage = item.photoData.feedsImgAttach.isNotEmpty
                        ? item.photoData.feedsImgAttach.first
                        : null;

                    final itemTotal = item.price * item.quantity;
                    final priceStr = item.price.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (m) => '${m[1]},',
                    );
                    final totalStr = itemTotal.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (m) => '${m[1]},',
                    );

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Thumbnail (4:6)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 96,
                              child: AspectRatio(
                                aspectRatio: 4 / 6,
                                child: mainImage != null
                                    ? CachedNetworkImage(
                                        imageUrl: _getImageUrl(
                                          mainImage.attachFilePath,
                                        ),
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                                size: 32,
                                              ),
                                            ),
                                      )
                                    : Container(
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                          size: 32,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 24),

                          // Info & Pricing
                          Container(
                            width: 250,
                            constraints: const BoxConstraints(
                              maxWidth: 250,
                              minWidth: 250,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.photoData.feedsContent,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '$priceStr원',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 226,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: QuantityStepper(
                                      value: item.quantity,
                                      onChanged: (value) {
                                        ref
                                            .read(cartProvider.notifier)
                                            .updateQuantity(
                                              item.feedsIdx,
                                              value,
                                            );
                                      },
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$totalStr원',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Trash / Remove button
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .removeItem(item.feedsIdx);
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.red.withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withValues(alpha: 0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (_showGradient)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Right: Summary Panel
          Container(
            width: 360,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Text(
                      '결제 정보',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color: Colors.black.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.16),
                ),
                const SizedBox(height: 16),

                _summaryRow('총 수량', '${cartItems.length}개'),
                const SizedBox(height: 16),
                _summaryRow(
                  '상품금액',
                  '${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                ),
                const Spacer(),
                Container(
                  height: 1,
                  color: Colors.black.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 8),
                _summaryRow(
                  '총 금액',
                  '${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                  emphasize: true,
                  isPrice: true,
                ),
                const SizedBox(height: 22),

                // Checkout Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: cartItems.isEmpty
                        ? null
                        : () {
                            // TODO: Navigate to PaymentFlowRoute in Step 2
                            // for now, just an empty action or print
                            debugPrint(
                              'Payment Flow triggered for amount $totalPrice! Pending implementation in Step 2.',
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF97D5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      disabledBackgroundColor: Colors.grey.shade400,
                    ),
                    child: const Text(
                      '결제하기',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool emphasize = false,
    bool isPrice = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 24,
            color: Colors.black.withValues(alpha: 0.9),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrice ? 28 : 22,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w600,
            color: isPrice ? const Color(0xFFFF97D5) : Colors.black,
          ),
        ),
      ],
    );
  }
}
