import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/image_prefetch_service.dart';
import '../../data/models/kiosk/kiosk_photo.dart';
import '../screens/photo_detail_screen.dart';

class PhotoGridTile extends StatelessWidget {
  final KioskPhoto photo;
  final int index;

  const PhotoGridTile({super.key, required this.photo, required this.index});

  @override
  Widget build(BuildContext context) {
    final heights = [380.0, 460.0, 540.0, 420.0, 360.0, 500.0];
    final height =
        heights[int.tryParse(photo.postId)?.remainder(heights.length).abs() ??
            index % heights.length];

    final heroTag = 'photo_${photo.postId}';

    return GestureDetector(
      onTap: () {
        context.playTapSound();
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            barrierDismissible: true,
            barrierColor: Colors.transparent,
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 350),
            pageBuilder: (context, animation, secondaryAnimation) =>
                PhotoDetailDialog(
              photo: photo,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ),
                child: child,
              );
            },
          ),
        );
      },
      child: SizedBox(
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                tag: heroTag,
                child: CachedNetworkImage(
                  cacheManager: KioskPhotoCacheManager.instance,
                  imageUrl: photo.attachedMediaDisplayUrl,
                  memCacheWidth: 360,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 100),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.black.withAlpha(150),
                    highlightColor: Colors.grey,
                    child: Container(color: Colors.grey.shade300),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Info Overlay
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              photo.ownerUsername,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (photo.feedsLike > 0) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                              size: 14,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${photo.feedsLike}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (photo.feedsContent.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          photo.feedsContent,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
