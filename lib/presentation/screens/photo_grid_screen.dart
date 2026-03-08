import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../core/services/image_prefetch_service.dart';
import '../../core/theme/kiosk_colors.dart';
import '../../data/models/kiosk/kiosk_photo.dart';
import '../providers/cart_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/search_provider.dart';
import '../components/search_action_bar.dart';
import '../components/cart_bottom_overlay.dart';
import '../components/photo_grid_tile.dart';

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
          return PhotoGridTile(photo: photo, index: index);
        },
        childCount: photos.length,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
      ),
    );
  }
}
