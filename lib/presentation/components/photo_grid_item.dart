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
    // Generate varying heights for the masonry grid effect
    final double height = 200.0 + ((index % 3) * 50);

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.6),
            builder: (context) => PhotoDetailDialog(feedsIdx: item.feedsIdx),
          );
        },
        child: SizedBox(
          height: height, // Keep the height for the outer container
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
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
                // Dummy Image representation
                CachedNetworkImage(
                  imageUrl: '${ApiConstants.awsIp}${item.feedsThumbnailAttach}',
                  fit: BoxFit.cover,
                  memCacheWidth: 200, // Optimize memory consumption drastically
                  fadeInDuration: Duration.zero, // Disable decode rebuilds
                  fadeOutDuration: Duration.zero,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[800],
                  ), // Removed expensive Shimmer animation
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 48, color: Colors.grey),
                      ],
                    ),
                  ),
                ),

                // Bottom Info Overlay
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'FeedsIdx: ${item.feedsIdx}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'View Count: ${item.feedsViewCount}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
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
    ); // Added extra closing paren for RepaintBoundary/GestureDetector
  }
}
