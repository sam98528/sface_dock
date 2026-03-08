import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/core/services/image_prefetch_service.dart';
import 'package:sfacedock/core/services/audio_service.dart';
import 'package:sfacedock/data/models/kiosk/kiosk_photo.dart';
import '../components/photo_detail_bottom_bar.dart';

class PhotoDetailDialog extends ConsumerWidget {
  final KioskPhoto photo;

  const PhotoDetailDialog({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animation = ModalRoute.of(context)?.animation;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Semi-transparent blurry background — animates with route transition
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                context.playTapSound();
                Navigator.of(context).pop();
              },
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
              child: _buildHeader(context),
            )
          else
            _buildHeader(context),

          // Main Content Area (Hero — always present)
          Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Center(
              child: _buildImageArea(context),
            ),
          ),

          // Bottom Bar
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: PhotoDetailBottomBar(
                photo: photo,
                onAddedToCart: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                onPressed: () {
                  context.playTapSound();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageArea(BuildContext context) {
    return Hero(
      tag: 'photo_${photo.postId}',
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: CachedNetworkImage(
            cacheManager: KioskPhotoCacheManager.instance,
            imageUrl: photo.attachedMediaDisplayUrl,
            fit: BoxFit.contain,
            errorWidget: (context, url, error) => const Icon(
              Icons.broken_image,
              color: Colors.white24,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }
}
