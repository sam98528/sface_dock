import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_result.dart';
import '../../data/models/kiosk/kiosk_photo.dart';
import '../../data/repositories/kiosk_photo_repository.dart';

/// Configuration for the pre-fetch service.
class PrefetchConfig {
  final Duration syncInterval;

  const PrefetchConfig({
    this.syncInterval = const Duration(seconds: 10),
  });
}

/// State for the pre-fetched kiosk photos.
class KioskPhotoPrefetchState {
  final List<KioskPhoto> photos;
  final bool isInitialLoadDone;
  final bool isSyncing;
  final int? latestTimestamp;

  const KioskPhotoPrefetchState({
    this.photos = const [],
    this.isInitialLoadDone = false,
    this.isSyncing = false,
    this.latestTimestamp,
  });

  KioskPhotoPrefetchState copyWith({
    List<KioskPhoto>? photos,
    bool? isInitialLoadDone,
    bool? isSyncing,
    int? latestTimestamp,
  }) {
    return KioskPhotoPrefetchState(
      photos: photos ?? this.photos,
      isInitialLoadDone: isInitialLoadDone ?? this.isInitialLoadDone,
      isSyncing: isSyncing ?? this.isSyncing,
      latestTimestamp: latestTimestamp ?? this.latestTimestamp,
    );
  }
}

class ImagePrefetchNotifier extends StateNotifier<KioskPhotoPrefetchState> {
  final KioskPhotoRepository _repository;
  final PrefetchConfig _config;
  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  Timer? _syncTimer;
  bool _isPaused = false;
  bool _isStopped = false;

  ImagePrefetchNotifier(
    this._repository, [
    this._config = const PrefetchConfig(),
  ]) : super(const KioskPhotoPrefetchState());

  void start() {
    if (_syncTimer != null) return;
    _isStopped = false;
    _isPaused = false;
    debugPrint('[Prefetch] Started');
    _runSync();
    _syncTimer = Timer.periodic(_config.syncInterval, (_) => _runSync());
  }

  void pause() {
    _isPaused = true;
    debugPrint('[Prefetch] Paused');
  }

  void resume() {
    if (_isStopped) {
      start();
      return;
    }
    _isPaused = false;
    debugPrint('[Prefetch] Resumed');
    _runSync();
  }

  void stop() {
    _syncTimer?.cancel();
    _syncTimer = null;
    _isStopped = true;
    _isPaused = true;
    debugPrint('[Prefetch] Stopped');
  }

  Future<void> _runSync() async {
    if (_isPaused || _isStopped) return;
    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true);

    try {
      if (!state.isInitialLoadDone) {
        await _initialLoad();
      } else {
        await _deltaSync();
      }
    } catch (e) {
      debugPrint('[Prefetch] Sync error: $e');
    } finally {
      if (mounted) {
        state = state.copyWith(isSyncing: false);
      }
    }
  }

  /// Fetch ALL photos and pre-download to disk cache.
  Future<void> _initialLoad() async {
    final stopwatch = Stopwatch()..start();
    debugPrint('[Prefetch] Starting initial load...');

    final result = await _repository.getPhotos(maxCount: 10000);

    if (result is! ApiSuccess<List<KioskPhoto>>) {
      debugPrint('[Prefetch] API error during initial load');
      return;
    }

    final allPhotos = result.data;
    final fetchMs = stopwatch.elapsedMilliseconds;
    debugPrint('[Prefetch] API returned ${allPhotos.length} photos in ${fetchMs}ms');

    if (allPhotos.isEmpty) {
      if (mounted) state = state.copyWith(isInitialLoadDone: true);
      return;
    }

    final newestTimestamp = allPhotos.first.timestamp;

    // Update photo list immediately so UI can start showing
    if (mounted) {
      state = state.copyWith(
        photos: List.unmodifiable(allPhotos),
        latestTimestamp: newestTimestamp,
      );
    }

    // Pre-download all images to disk cache (concurrent)
    await _precacheToDisk(allPhotos);
    final cacheMs = stopwatch.elapsedMilliseconds;

    if (mounted) {
      state = state.copyWith(isInitialLoadDone: true);
    }

    stopwatch.stop();
    debugPrint(
      '[Prefetch] Complete: ${allPhotos.length} photos | '
      'fetch: ${fetchMs}ms | disk-cache: ${cacheMs - fetchMs}ms | '
      'total: ${stopwatch.elapsedMilliseconds}ms',
    );
  }

  /// Delta sync: fetch only new photos.
  Future<void> _deltaSync() async {
    final afterTs = state.latestTimestamp;
    if (afterTs == null) {
      await _initialLoad();
      return;
    }

    final result = await _repository.getPhotos(
      maxCount: 100,
      after: afterTs,
    );

    if (result is! ApiSuccess<List<KioskPhoto>>) return;

    final newPhotos = result.data;
    if (newPhotos.isEmpty) return;

    await _precacheToDisk(newPhotos);

    final updated = [...newPhotos, ...state.photos];
    final newestTs = newPhotos.first.timestamp;

    if (mounted) {
      state = state.copyWith(
        photos: List.unmodifiable(updated),
        latestTimestamp: newestTs > afterTs ? newestTs : afterTs,
      );
    }

    debugPrint('[Prefetch] Delta: +${newPhotos.length} (total: ${updated.length})');
  }

  /// Pre-download images to disk cache concurrently.
  /// CachedNetworkImage will read from this disk cache later.
  Future<void> _precacheToDisk(List<KioskPhoto> photos) async {
    const concurrency = 10;

    for (var i = 0; i < photos.length; i += concurrency) {
      if (_isPaused || _isStopped) break;

      final batchEnd = (i + concurrency).clamp(0, photos.length);
      final batch = photos.sublist(i, batchEnd);

      await Future.wait(
        batch.map((p) async {
          try {
            await _cacheManager.downloadFile(p.attachedMediaDisplayUrl);
          } catch (_) {}
        }),
      );
    }
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

/// Provider for the pre-fetch service.
final imagePrefetchProvider =
    StateNotifierProvider<ImagePrefetchNotifier, KioskPhotoPrefetchState>((
      ref,
    ) {
      final repository = ref.read(kioskPhotoRepositoryProvider);
      return ImagePrefetchNotifier(repository);
    });

/// Convenience provider: just the photo list.
final prefetchedPhotosProvider = Provider<List<KioskPhoto>>((ref) {
  return ref.watch(imagePrefetchProvider).photos;
});

/// Convenience provider: whether initial load is done.
final prefetchInitialLoadDoneProvider = Provider<bool>((ref) {
  return ref.watch(imagePrefetchProvider).isInitialLoadDone;
});
