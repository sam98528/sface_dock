import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/image_prefetch_service.dart';
import '../../core/theme/kiosk_colors.dart';
import '../../data/models/cart/cart_item.dart';
import '../providers/cart_provider.dart';

class CartItemCard extends ConsumerWidget {
  final CartItem item;
  final int index;

  const CartItemCard({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final imageUrl = item.photoData.attachedMediaDisplayUrl;

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
                      if (imageUrl.isNotEmpty)
                        CachedNetworkImage(
                          cacheManager: KioskPhotoCacheManager.instance,
                          imageUrl: imageUrl,
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
                            ref: ref,
                            icon: Icons.remove,
                            enabled: item.quantity > 1,
                            onTap: () {
                              context.playTapSound();
                              ref
                                  .read(cartProvider.notifier)
                                  .updateQuantity(
                                    item.feedsIdx,
                                    item.quantity - 1,
                                  );
                            },
                          ),
                          Text(
                            '${item.quantity}',
                            style: tt.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          _buildSimpleStepperBtn(
                            ref: ref,
                            icon: Icons.add,
                            enabled: item.quantity < 5,
                            onTap: () {
                              context.playTapSound();
                              ref
                                  .read(cartProvider.notifier)
                                  .updateQuantity(
                                    item.feedsIdx,
                                    item.quantity + 1,
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      context.playTapSound();
                      ref
                          .read(cartProvider.notifier)
                          .removeItem(item.feedsIdx);
                    },
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
    required WidgetRef ref,
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
}
