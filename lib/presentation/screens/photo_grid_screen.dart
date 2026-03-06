import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/services/image_prefetch_service.dart';
import '../../core/theme/kiosk_colors.dart';
import '../../data/models/kiosk/kiosk_photo.dart';
import '../providers/cart_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/search_provider.dart';
import '../components/search_action_bar.dart';
import '../components/cart_bottom_overlay.dart';
import 'photo_detail_screen.dart';

class PhotoGridScreen extends ConsumerStatefulWidget {
  const PhotoGridScreen({super.key});

  @override
  ConsumerState<PhotoGridScreen> createState() => _PhotoGridScreenState();
}

class _PhotoGridScreenState extends ConsumerState<PhotoGridScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 새 세션 시작: 이전 세션의 장바구니/쿠폰/검색 초기화
      ref.read(cartProvider.notifier).clearCart();
      ref.read(paymentProvider.notifier).reset();
      ref.read(searchQueryProvider.notifier).state = '';
      ref.read(imagePrefetchProvider.notifier).resume();
    });
  }

  @override
  Widget build(BuildContext context) {
    final photos = ref.watch(filteredPhotosProvider);
    final isReady = ref.watch(prefetchInitialLoadDoneProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                colors: [KioskColors.primary, KioskColors.secondary],
              ),
            ),
          ),

          // Main Content
          _buildContent(photos, isReady),

          // Top Action Bar
          const Positioned(top: 0, left: 0, right: 0, child: SearchActionBar()),

          // Bottom Cart Overlay
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CartBottomOverlay(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<KioskPhoto> photos, bool isReady) {
    if (photos.isEmpty && !isReady) {
      return const Center(child: CircularProgressIndicator());
    }

    if (photos.isEmpty) {
      return Center(
        child: Text(
          '결과가 없습니다.',
          style: const TextStyle(fontSize: 32, color: Colors.black54),
        ),
      );
    }

    return MasonryGridView.custom(
      cacheExtent: 1000,
      padding: const EdgeInsets.only(
        top: 120,
        left: 24,
        right: 24,
        bottom: 120,
      ),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) {
          final photo = photos[index];
          return _PhotoGridTile(photo: photo, index: index);
        },
        childCount: photos.length,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
      ),
    );
  }
}

class _PhotoGridTile extends StatelessWidget {
  final KioskPhoto photo;
  final int index;

  const _PhotoGridTile({required this.photo, required this.index});

  @override
  Widget build(BuildContext context) {
    final heights = [380.0, 460.0, 540.0, 420.0, 360.0, 500.0];
    final height =
        heights[int.tryParse(photo.postId)?.remainder(heights.length).abs() ??
            index % heights.length];

    final feedsIdx = int.tryParse(photo.postId);
    final heroTag = 'photo_${photo.postId}';

    return GestureDetector(
      onTap: () {
        if (feedsIdx != null) {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierDismissible: true,
              barrierColor: Colors.transparent,
              transitionDuration: const Duration(milliseconds: 400),
              reverseTransitionDuration: const Duration(milliseconds: 350),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PhotoDetailDialog(
                    feedsIdx: feedsIdx,
                    heroImageUrl: photo.attachedMediaDisplayUrl,
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
        }
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
                  child: Text(
                    photo.ownerUsername,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
