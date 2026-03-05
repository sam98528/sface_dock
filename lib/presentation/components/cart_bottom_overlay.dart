import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cart_provider.dart';
import '../../app/sfacedock_app.dart';
import '../../core/theme/kiosk_colors.dart';

class CartBottomOverlay extends ConsumerStatefulWidget {
  const CartBottomOverlay({super.key});

  @override
  ConsumerState<CartBottomOverlay> createState() => _CartBottomOverlayState();
}

class _CartBottomOverlayState extends ConsumerState<CartBottomOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    final isNotEmpty = cartItems.isNotEmpty;
    final textTheme = Theme.of(context).textTheme;

    if (isNotEmpty) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return SlideTransition(
      position: _offsetAnimation,
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 32),
          padding: const EdgeInsets.all(16),
          width: 800,
          height: 120,
          decoration: BoxDecoration(
            color: KioskColors.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(60),
            border: Border.all(
              color: KioskColors.tertiary.withValues(alpha: 0.9),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              // Item Thumbnails (Circular overlapped)
              SizedBox(
                width: 184,
                child: Stack(
                  children: List.generate(cartItems.take(5).length, (index) {
                    final item = cartItems[index];
                    return Positioned(
                      left: index * 30.0,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: KioskColors.primary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              item.photoData.feedsImgAttach.isNotEmpty
                                  ? 'https://d37j40e2wj9q14.cloudfront.net/${item.photoData.feedsImgAttach.first.attachFilePath}'
                                  : '',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              if (cartItems.length > 5)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '+${cartItems.length - 5}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: KioskColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              const SizedBox(width: 24),

              // Text Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${ref.watch(cartTotalItemsProvider)}개 선택됨',
                        style: textTheme.titleMedium?.copyWith(
                          color: KioskColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),  
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '사진을 터치해서 더 담아보세요',
                        style: textTheme.bodySmall?.copyWith(
                          color: KioskColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Go to Cart Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(cartRouteName);
                },
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: KioskColors.primaryGradient,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: KioskColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          '장바구니 이동',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            '${ref.watch(cartTotalItemsProvider)}',
                            style: textTheme.bodySmall?.copyWith(
                              color: KioskColors.white,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
