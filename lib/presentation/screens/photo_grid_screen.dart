import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
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
  final ScrollController _scrollController = ScrollController();
  final TransformationController _transformationController =
      TransformationController();
  DateTime? _lastLoadTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final x = -(3000.0 - size.width / 2);
      final y = -(3000.0 - size.height / 2);
      _transformationController.value = Matrix4.identity()..translate(x, y);

      ref
          .read(photogoodsProvider.notifier)
          .searchPhotogoods(' ', refresh: true);
    });

    _transformationController.addListener(_onCanvasPan);
  }

  void _onCanvasPan() {
    if (!mounted) return;

    final now = DateTime.now();
    if (_lastLoadTime != null &&
        now.difference(_lastLoadTime!).inMilliseconds < 1000) {
      return;
    }

    final isLoading = ref.read(photogoodsLoadingProvider);
    final hasMore = ref.read(photogoodsHasMoreProvider);
    if (isLoading || !hasMore) return;

    final matrix = _transformationController.value;
    final scale = matrix.getMaxScaleOnAxis();
    if (scale == 0) return;

    final translation = matrix.getTranslation();
    final size = MediaQuery.of(context).size;
    final viewportCenterX = (-translation.x + size.width / 2) / scale;
    final viewportCenterY = (-translation.y + size.height / 2) / scale;

    final items = ref.read(photogoodsItemsProvider);
    if (items.isEmpty) return;

    final int columns = math.max(4, math.sqrt(items.length).ceil());
    final double gridWidth = columns * 280.0;
    final double estimatedGridHeight = (items.length / columns).ceil() * 280.0;

    final leftEdge = 3000.0 - gridWidth / 2;
    final rightEdge = 3000.0 + gridWidth / 2;
    final topEdge = 3000.0 - estimatedGridHeight / 2;
    final bottomEdge = 3000.0 + estimatedGridHeight / 2;

    final threshold = 800.0;

    bool nearEdge =
        viewportCenterX < leftEdge + threshold ||
        viewportCenterX > rightEdge - threshold ||
        viewportCenterY < topEdge + threshold ||
        viewportCenterY > bottomEdge - threshold;

    if (nearEdge) {
      _lastLoadTime = now;
      ref.read(photogoodsProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _transformationController.dispose();
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
            child: Stack(
              children: [
                InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  minScale: 0.1,
                  maxScale: 3.0,
                  constrained: false,
                  transformationController: _transformationController,
                  child: Container(
                    width: 6000,
                    height: 6000,
                    alignment: Alignment.center,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final items = ref.watch(photogoodsItemsProvider);
                        final isLoading = ref.watch(photogoodsLoadingProvider);
                        final error = ref.watch(photogoodsErrorProvider);

                        if (isLoading && items.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (error != null && items.isEmpty) {
                          return Center(
                            child: Text(
                              '오류가 발생했습니다: $error',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }

                        if (items.isEmpty) {
                          return const Center(
                            child: Text(
                              '결과가 없습니다.',
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        // Reverted to MasonryGridView but using a fixed column count to stop reshuffling!
                        final int columns = 10;
                        final double gridWidth = columns * 280.0;

                        return SizedBox(
                          width: gridWidth,
                          child: MasonryGridView.count(
                            crossAxisCount: columns,
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 30,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return PhotoGridItem(
                                item: items[index],
                                index: index,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Top Action Bar Overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 32,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Back Button
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.of(context).pop();
                        //   },
                        //   child: Container(
                        //     height: 80,
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 30,
                        //       vertical: 8,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white.withValues(alpha: 0.2),
                        //       borderRadius: BorderRadius.circular(20),
                        //     ),
                        //     child: const Center(
                        //       child: Text(
                        //         '돌아가기',
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 24,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: Container(
          //       width: double.infinity,
          //       height: 100,
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 24,
          //         vertical: 12,
          //       ),
          //       decoration: BoxDecoration(
          //         color: Colors.black.withValues(alpha: 0.3),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black.withValues(alpha: 0.2),
          //             blurRadius: 10,
          //             offset: const Offset(0, 4),
          //           ),
          //         ],
          //       ),
          //       child: Center(
          //         child: Shimmer.fromColors(
          //           baseColor: Colors.white,
          //           highlightColor: const Color(
          //             0xFFDEBAF6,
          //           ).withValues(alpha: 0.8),
          //           period: const Duration(milliseconds: 3000),
          //           direction: ShimmerDirection.ltr,
          //           child: const Text(
          //             '원하는 이미지를 터치해 자세히 보기',
          //             style: TextStyle(
          //               fontSize: 28,
          //               fontWeight: FontWeight.w800,
          //               color: Colors.white,
          //               letterSpacing: 1.0,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
