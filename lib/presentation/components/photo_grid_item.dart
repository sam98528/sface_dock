import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sfacedock/core/constants/api_constants.dart';
import 'package:sfacedock/data/models/photogoods/search_photogoods.dart';
import '../screens/photo_detail_screen.dart';

class PhotoGridItem extends StatelessWidget {
  final SearchPhotogoods item;
  final int index;

  const PhotoGridItem({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    // Generate varying mathematical heights for a dynamic waterfall effect rather than rigid boxes
    final heights = [280.0, 360.0, 420.0, 310.0, 240.0, 380.0];
    // Map item id/index to a stable pseudorandom height index to ensure consistent sizing during scroll loop
    final double height = heights[item.feedsIdx % heights.length];

    return RepaintBoundary(
      key: ValueKey(item.feedsIdx),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.transparent,
              pageBuilder: (context, _, __) =>
                  PhotoDetailDialog(feedsIdx: item.feedsIdx),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          );
        },
        child: SizedBox(
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                16,
              ), // Slightly rounder for aesthetic
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'photo_${item.feedsIdx}',
                  child: CachedNetworkImage(
                    imageUrl:
                        '${ApiConstants.awsIp}${item.feedsThumbnailAttach}',
                    memCacheWidth: 300,
                    placeholder: (context, url) =>
                        const SizedBox.expand(), // Transparent instead of ugly white box
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black.withValues(alpha: 0.1),
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    imageBuilder: (context, imageProvider) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.scale(
                              scale: 0.95 + (0.05 * value), // 0.95 -> 1.0
                              child: child,
                            ),
                          );
                        },
                        child: Image(image: imageProvider, fit: BoxFit.cover),
                      );
                    },
                  ),
                ),

                // Bottom Info Overlay
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ID: ${item.feedsIdx}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Views: ${item.feedsViewCount}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
