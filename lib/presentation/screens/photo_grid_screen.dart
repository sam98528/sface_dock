import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../app/sfacedock_app.dart';
import '../../core/device/device_controller_proxy_provider.dart';
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
  final ScrollController _scrollController = ScrollController();
  Timer? _inactivityTimer;
  bool _isNavigating = false;

  static const _inactivityTimeout = Duration(seconds: 50);
  static const _countdownDuration = 10;

  @override
  void initState() {
    super.initState();
    _resetInactivityTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 새 세션 시작: 이전 세션의 장바구니/쿠폰/검색 초기화
      ref.read(cartProvider.notifier).clearCart();
      ref.read(paymentProvider.notifier).reset();
      ref.read(searchQueryProvider.notifier).state = '';
      ref.read(imagePrefetchProvider.notifier).resume();
    });
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_inactivityTimeout, _showTimeoutWarning);
  }

  void _showTimeoutWarning() {
    if (!mounted || _isNavigating) return;
    // 다른 화면이 위에 push되어 있으면 타이머 무시 (인쇄중/완료 등)
    if (ModalRoute.of(context)?.isCurrent != true) {
      _inactivityTimer?.cancel();
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _InactivityWarningDialog(
        countdownSeconds: _countdownDuration,
        onContinue: () {
          // 다이얼로그만 닫고 타이머 리셋
          Navigator.of(context, rootNavigator: true).pop();
          _resetInactivityTimer();
        },
        onTimeout: _returnToIntro,
      ),
    );
  }

  void _returnToIntro() {
    if (!mounted || _isNavigating) return;
    _isNavigating = true;
    _inactivityTimer?.cancel();

    // 장바구니 초기화
    ref.read(cartProvider.notifier).clearCart();
    ref.read(paymentProvider.notifier).reset();
    ref.read(searchQueryProvider.notifier).state = '';

    // Prefetch 재개 (idle 화면 복귀)
    ref.read(imagePrefetchProvider.notifier).resume();

    // 다이얼로그 포함 모든 라우트 제거 → intro로 이동 (pop 불필요)
    Navigator.pushNamedAndRemoveUntil(
      context,
      introRouteName,
      (route) => false,
    );

    // 하드웨어 일시 중지 (네비게이션 이후 비동기 처리)
    final proxy = ref.read(deviceControllerProxyProvider);
    if (proxy.isConnected) {
      proxy.suspendHardware().then((_) {
        debugPrint('[PhotoGrid] Hardware suspended after navigation');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final photos = ref.watch(filteredPhotosProvider);
    final isReady = ref.watch(prefetchInitialLoadDoneProvider);

    // 정렬 옵션이 변경될 때 스크롤을 최상단으로 즉시 이동
    ref.listen<PhotoSortOption>(photoSortOptionProvider, (previous, next) {
      if (previous != null && previous != next && _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });

    return Listener(
      onPointerDown: (_) => _resetInactivityTimer(),
      onPointerMove: (_) => _resetInactivityTimer(),
      child: Scaffold(
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

    // 정렬 옵션에 따른 고유 키 생성
    final sortOption = ref.watch(photoSortOptionProvider);

    return MasonryGridView.custom(
      key: ValueKey('grid-$sortOption'),
      controller: _scrollController,
      cacheExtent: 500,
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
          // key 제거하여 위젯이 매번 새로 생성되도록 함
          return PhotoGridTile(
            photo: photo,
            index: index,
          );
        },
        childCount: photos.length,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
      ),
    );
  }
}

/// Inactivity warning dialog with countdown timer.
class _InactivityWarningDialog extends StatefulWidget {
  final int countdownSeconds;
  final VoidCallback onContinue;
  final VoidCallback onTimeout;

  const _InactivityWarningDialog({
    required this.countdownSeconds,
    required this.onContinue,
    required this.onTimeout,
  });

  @override
  State<_InactivityWarningDialog> createState() =>
      _InactivityWarningDialogState();
}

class _InactivityWarningDialogState extends State<_InactivityWarningDialog> {
  late int _remaining;
  Timer? _countdownTimer;
  bool _acted = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.countdownSeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _acted) return;
      setState(() => _remaining--);
      if (_remaining <= 0) {
        _countdownTimer?.cancel();
        _acted = true;
        widget.onTimeout();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final progress = _remaining / widget.countdownSeconds;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 420,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 44),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular countdown
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        KioskColors.primary,
                      ),
                    ),
                  ),
                  Text(
                    '$_remaining',
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: KioskColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            Text(
              '잠시 자리를 비우셨나요?',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '곧 처음 화면으로 돌아갑니다',
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.black45,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _acted
                    ? null
                    : () {
                        _acted = true;
                        _countdownTimer?.cancel();
                        widget.onContinue();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: KioskColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '계속 사용하기',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
