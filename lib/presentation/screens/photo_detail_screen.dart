import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';
import 'package:sfacedock/data/models/photogoods/photo_detail.dart';
import 'package:sfacedock/data/repositories/photogoods_repository.dart';
import 'package:sfacedock/core/api/api_result.dart';
import 'package:sfacedock/presentation/providers/cart_provider.dart';
import 'package:sfacedock/core/constants/api_constants.dart';
import 'package:intl/intl.dart';

class PhotoDetailDialog extends ConsumerStatefulWidget {
  final int feedsIdx;

  const PhotoDetailDialog({super.key, required this.feedsIdx});

  @override
  ConsumerState<PhotoDetailDialog> createState() => _PhotoDetailDialogState();
}

class _PhotoDetailDialogState extends ConsumerState<PhotoDetailDialog> {
  int _quantity = 1;
  bool _isAnimating = false;
  PhotoDetail? _photoDetail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPhotoDetail();
  }

  Future<void> _loadPhotoDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final repository = ref.read(photogoodsRepositoryProvider);
      final result = await repository.getPhotogoodsDetail(
        feedsIdx: widget.feedsIdx,
      );

      if (mounted) {
        switch (result) {
          case ApiSuccess<PhotoDetail>(data: final data):
            setState(() {
              _photoDetail = data;
              _isLoading = false;
            });
            break;
          case ApiError<PhotoDetail>(message: final message):
            setState(() {
              _error = message;
              _isLoading = false;
            });
            break;
          case ApiLoading<PhotoDetail>():
            break;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '상세 정보를 불러오는데 실패했습니다: $e';
          _isLoading = false;
        });
      }
    }
  }

  String _getImageUrl(String imagePath) {
    return '${ApiConstants.awsIp}$imagePath';
  }

  String _formatKoreanDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Semi-transparent blurry background
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(color: Colors.black.withValues(alpha: 0.6)),
              ),
            ),
          ),

          // Header: Back and Close Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildNavCircleButton(
                    icon: Icons.close,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),

          // Main Content Area
          Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator(color: KioskColors.primary)
                  : _error != null
                  ? _buildErrorState()
                  : _photoDetail != null
                  ? _buildImageArea()
                  : const SizedBox(),
            ),
          ),

          // Bottom Bar (Pill design)
          if (_photoDetail != null && !_isLoading)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(child: _buildBottomPillBar()),
            ),
        ],
      ),
    );
  }

  Widget _buildNavCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildImageArea() {
    final photo = _photoDetail!;
    final mainImage = photo.feedsImgAttach.isNotEmpty
        ? photo.feedsImgAttach.first
        : null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.topLeft,
          children: [
            Hero(
              tag: 'photo_${widget.feedsIdx}',
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: KioskColors.primary.withValues(alpha: 0.2),
                      blurRadius: 100,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: mainImage != null
                      ? CachedNetworkImage(
                          imageUrl: _getImageUrl(mainImage.attachFilePath),
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(
                                color: KioskColors.primary,
                              ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.broken_image,
                            color: Colors.white24,
                            size: 64,
                          ),
                        )
                      : const Icon(
                          Icons.image_not_supported,
                          color: Colors.white24,
                          size: 64,
                        ),
                ),
              ),
            ),
            // Premium Tag
            Positioned(
              top: 24,
              left: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: KioskColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '프리미엄 인화',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatItem(Icons.favorite_border, '${photo.feedsLike}'),
            const SizedBox(width: 24),
            _buildStatItem(
              Icons.visibility_outlined,
              '${photo.feedsViewCount}',
            ),
            const SizedBox(width: 24),
            _buildStatItem(Icons.share_outlined, '공유하기'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildBottomPillBar() {
    final photo = _photoDetail!;

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
                  '업로드일: ${_formatKoreanDate(photo.feedsCreatedAt)}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),

          // Quantity Stepper
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCircularStepperButton(
                  icon: Icons.remove,
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                ),
                const SizedBox(width: 20),
                Text(
                  '$_quantity',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                _buildCircularStepperButton(
                  icon: Icons.add,
                  onPressed: _quantity < 5
                      ? () => setState(() => _quantity++)
                      : null,
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Add to Cart Button
          SizedBox(
            height: 64,
            child: ElevatedButton.icon(
              onPressed: _isAnimating ? null : _addToCart,
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
              ),
              label: const Text(
                '장바구니 담기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: KioskColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                elevation: 0,
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
                imageUrl: _getImageUrl(path),
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
            color: onPressed != null ? KioskColors.secondary : Colors.white12,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: onPressed != null ? KioskColors.secondary : Colors.white12,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: KioskColors.error),
          const SizedBox(height: 24),
          const Text(
            '오류가 발생했습니다',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _error ?? '',
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _loadPhotoDetail,
            style: ElevatedButton.styleFrom(
              backgroundColor: KioskColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  void _addToCart() {
    if (_photoDetail == null || _isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    ref.read(cartProvider.notifier).addItem(_photoDetail!, _quantity);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}
