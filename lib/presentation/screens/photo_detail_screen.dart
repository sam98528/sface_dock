import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/data/models/photogoods/photo_detail.dart';
import 'package:sfacedock/data/repositories/photogoods_repository.dart';
import 'package:sfacedock/core/api/api_result.dart';
import 'package:sfacedock/presentation/components/quantity_stepper.dart';
import 'package:sfacedock/presentation/providers/cart_provider.dart';

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

      // TODO: Replace with sfacedock API provider if different, but using direct repo for now.
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
            // Loading state
            break;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load photo detail: $e';
          _isLoading = false;
        });
      }
    }
  }

  String _getImageUrl(String imagePath) {
    // Basic Cloudfront base URL handler
    const awsIp = 'https://d37j40e2wj9q14.cloudfront.net/';
    return '$awsIp$imagePath';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 1080,
        height: 720,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? _buildErrorState()
              : _photoDetail != null
              ? _buildContent()
              : const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          Text(
            '오류가 발생했습니다',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadPhotoDetail,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final photo = _photoDetail!;
    final mainImage = photo.feedsImgAttach.isNotEmpty
        ? photo.feedsImgAttach.first
        : null;

    // 4:6 Aspect Ratio bounds
    const double aspectRatio = 4.0 / 6.0;
    const double baseHeight = 720 - 64;
    const double baseWidth = baseHeight * aspectRatio;

    return Row(
      children: [
        // Left main image
        SizedBox(
          width: baseWidth,
          height: baseHeight,
          child: mainImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: _getImageUrl(mainImage.attachFilePath),
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey.shade200),
                    errorWidget: (context, url, error) {
                      log('Image load error: $error');
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 64,
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 64,
                  ),
                ),
        ),

        const SizedBox(width: 24),

        // Right Detail Info Panel
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info header
              Row(
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircleAvatar(
                      radius: 999,
                      backgroundImage: photo.feedUserInfo.profileImgPath != null
                          ? CachedNetworkImageProvider(
                              _getImageUrl(photo.feedUserInfo.profileImgPath!),
                            )
                          : null,
                      child: photo.feedUserInfo.profileImgPath == null
                          ? const Icon(Icons.person, color: Colors.grey)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          photo.feedUserInfo.memNickname,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          _formatDate(photo.feedsCreatedAt),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Description
              if (photo.feedsContent.isNotEmpty) ...[
                Text(
                  photo.feedsContent,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 1.2,
                  ),
                  softWrap: true,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ],
              const SizedBox(height: 32),

              // Price
              if (photo.feedsPrice > 0) ...[
                Text(
                  '${photo.feedsPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ],
              const SizedBox(height: 32),

              // Quantity Controls
              const Text(
                '수량',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: QuantityStepper(
                  value: _quantity,
                  onChanged: (value) {
                    setState(() {
                      _quantity = value;
                    });
                  },
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF97D5).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      '수량을 선택하고 장바구니 담기를 눌러주세요',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF97D5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isAnimating ? null : _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF97D5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    '장바구니 담기',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addToCart() {
    if (_photoDetail == null || _isAnimating) return;

    setState(() {
      _isAnimating = true;
    });
    log('addToCart: ${_photoDetail?.feedsImgAttach.first.attachFilePath}');

    // Add Cart Item Logic via Provider
    ref.read(cartProvider.notifier).addItem(_photoDetail!, _quantity);

    // Provide visual feedback / pop
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}
