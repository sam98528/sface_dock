import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/app/sfacedock_app.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';
import 'package:sfacedock/data/models/photogoods/photo_detail.dart';
import 'package:sfacedock/data/repositories/photogoods_repository.dart';
import 'package:sfacedock/core/api/api_result.dart';
import 'package:sfacedock/presentation/providers/cart_provider.dart';
import 'package:sfacedock/core/constants/api_constants.dart';
import 'package:intl/intl.dart';

class PhotoDetailDialog extends ConsumerStatefulWidget {
  final int feedsIdx;
  final String? heroImageUrl;

  const PhotoDetailDialog({
    super.key,
    required this.feedsIdx,
    this.heroImageUrl,
  });

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
    final animation = ModalRoute.of(context)?.animation;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Semi-transparent blurry background — animates with route transition
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: animation != null
                  ? AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        final t = animation.value;
                        return BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 15 * t,
                            sigmaY: 15 * t,
                          ),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.6 * t),
                          ),
                        );
                      },
                    )
                  : BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
            ),
          ),

          // Header: Close Button — fade in with route
          if (animation != null)
            FadeTransition(
              opacity: animation,
              child: _buildHeader(),
            )
          else
            _buildHeader(),

          // Main Content Area (Hero — always present)
          Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Center(
              child: _error != null ? _buildErrorState() : _buildImageArea(),
            ),
          ),

          // Overlays that fade in after loading
          if (_photoDetail != null && !_isLoading) ...[
            // Bottom Bar
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(child: _buildBottomPillBar()),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Image URL to display — always use grid's cached URL when available.
  String? get _displayImageUrl {
    if (widget.heroImageUrl != null) return widget.heroImageUrl;
    final mainImage = _photoDetail?.feedsImgAttach.firstOrNull;
    if (mainImage != null) return _getImageUrl(mainImage.attachFilePath);
    return null;
  }

  Widget _buildImageArea() {
    final imageUrl = _displayImageUrl;

    return Hero(
      tag: 'photo_${widget.feedsIdx}',
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image,
                    color: Colors.white24,
                    size: 64,
                  ),
                )
              : const SizedBox(
                  width: 300,
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: KioskColors.primary,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildPremiumTag() {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      ),
    );
  }

  Widget _buildBottomPillBar() {
    final photo = _photoDetail!;
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
              color: Colors.white.withValues(alpha: 0.2),
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
                      ? () => setState(() => _quantity++)
                      : null,
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Add to Cart Button
          GestureDetector(
            onTap: () {
              _addToCart();
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
