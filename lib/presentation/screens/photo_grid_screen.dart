import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../components/photo_grid_item.dart';
import '../providers/photogoods_provider.dart';
import '../providers/cart_provider.dart';
import '../../app/sfacedock_app.dart';

class PhotoGridScreen extends ConsumerStatefulWidget {
  const PhotoGridScreen({super.key});

  @override
  ConsumerState<PhotoGridScreen> createState() => _PhotoGridScreenState();
}

class _PhotoGridScreenState extends ConsumerState<PhotoGridScreen> {
  DateTime? _lastLoadTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(photogoodsProvider.notifier)
          .searchPhotogoods(' ', refresh: true);
    });
  }

  void _triggerLoadMore() {
    if (!mounted) return;

    final now = DateTime.now();
    if (_lastLoadTime != null &&
        now.difference(_lastLoadTime!).inMilliseconds < 1000) {
      return;
    }

    final isLoading = ref.read(photogoodsLoadingProvider);
    final hasMore = ref.read(photogoodsHasMoreProvider);
    if (isLoading || !hasMore) return;

    _lastLoadTime = now;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(photogoodsProvider.notifier).loadMore();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: cartItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pushNamed(cartRouteName);
              },
              backgroundColor: const Color(0xFFFF97D5),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: Text(
                '장바구니 (${cartItems.fold(0, (sum, i) => sum + i.quantity)})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 1.0],
                colors: [
                  Color(0xFFFFBFE9),
                  Color(0xFFDEBAF6),
                  Color(0xFFA3F0E2),
                ],
              ),
            ),
            child: Consumer(
              builder: (context, ref, child) {
                final items = ref.watch(photogoodsItemsProvider);
                final isLoading = ref.watch(photogoodsLoadingProvider);
                final error = ref.watch(photogoodsErrorProvider);

                if (isLoading && items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (error != null && items.isEmpty) {
                  return Center(
                    child: Text(
                      '오류가 발생했습니다: $error',
                      style: const TextStyle(fontSize: 24, color: Colors.red),
                    ),
                  );
                }

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      '결과가 없습니다.',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  );
                }

                final hasMore = ref.watch(photogoodsHasMoreProvider);

                return MasonryGridView.custom(
                  padding: const EdgeInsets.only(
                    top: 120,
                    left: 24,
                    right: 24,
                    bottom: 120,
                  ),
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Trigger load more when user scrolls near the end of the currently loaded API items
                      if (hasMore && index >= items.length - 8) {
                        _triggerLoadMore();
                      }

                      // Loop data infinitely (only actually loops when hasMore is false and itemCount is null)
                      final recycledIndex = index % items.length;

                      return PhotoGridItem(
                        item: items[recycledIndex],
                        index: index,
                      );
                    },
                    childCount: hasMore ? items.length : null,
                    addAutomaticKeepAlives: true,
                    addRepaintBoundaries: true,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
              child: const Row(),
            ),
          ),
        ],
      ),
    );
  }
}
