import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/api_constants.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/image_prefetch_service.dart';
import '../../core/theme/kiosk_colors.dart';
import '../../core/admin/controllers/admin_controller.dart';
import '../../data/models/kiosk/kiosk_photo.dart';
import '../providers/cart_provider.dart';

class PhotoDetailBottomBar extends ConsumerStatefulWidget {
  final KioskPhoto photo;
  final VoidCallback onAddedToCart;

  const PhotoDetailBottomBar({
    super.key,
    required this.photo,
    required this.onAddedToCart,
  });

  @override
  ConsumerState<PhotoDetailBottomBar> createState() =>
      _PhotoDetailBottomBarState();
}

class _PhotoDetailBottomBarState extends ConsumerState<PhotoDetailBottomBar> {
  int _quantity = 1;
  bool _isAnimating = false;

  String _getProfileImageUrl(String path) {
    return path.startsWith('http')
        ? path
        : '${ApiConstants.resizeCdn}$path';
  }

  String _formatKoreanDate(int timestamp) {
    try {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photo;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      height: 100,
      width: 1000,
      decoration: BoxDecoration(
        color: KioskColors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildUserProfileThumbnail(photo.feedUserInfo.profileImgPath),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  photo.feedUserInfo.memNickname,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '업로드일: ${_formatKoreanDate(photo.timestamp)}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),

          // Quantity Stepper
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCircularStepperButton(
                  icon: Icons.remove,
                  onPressed: _quantity > 1
                      ? () {
                          context.playTapSound();
                          setState(() => _quantity--);
                        }
                      : null,
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 32,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '$_quantity',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                _buildCircularStepperButton(
                  icon: Icons.add,
                  onPressed: _quantity < 5
                      ? () {
                          context.playTapSound();
                          setState(() => _quantity++);
                        }
                      : null,
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Add to Cart Button
          GestureDetector(
            onTap: _addToCart,
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
                      '장바구니 담기',
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildUserProfileThumbnail(String? path) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: path != null
            ? CachedNetworkImage(
                cacheManager: KioskPhotoCacheManager.instance,
                imageUrl: _getProfileImageUrl(path),
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, color: Colors.white54),
              )
            : const Icon(Icons.person, color: Colors.white54),
      ),
    );
  }

  Widget _buildCircularStepperButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: onPressed != null
                ? KioskColors.primary
                : KioskColors.grey200,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: onPressed != null ? KioskColors.primary : KioskColors.grey200,
          size: 20,
        ),
      ),
    );
  }

  void _addToCart() {
    if (_isAnimating) return;
    context.playTapSound();

    setState(() {
      _isAnimating = true;
    });

    final price = ref.read(adminControllerProvider).photoPrice;
    ref.read(cartProvider.notifier).addItem(widget.photo, _quantity, price);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        widget.onAddedToCart();
      }
    });
  }
}
