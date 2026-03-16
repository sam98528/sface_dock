import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_result.dart';
import '../../data/models/kiosk/kiosk_photo.dart';
import '../../data/repositories/kiosk_photo_repository.dart';

/// Custom cache manager with large capacity for kiosk photos.
/// Default: 200 files / 7 days stale. This: 15,000 files / 30 days stale.
class KioskPhotoCacheManager {
  static const key = 'kioskPhotoCache';

  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 15000,
    ),
  );
}

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
  final bool isMinimalCacheDone;
  final bool isSyncing;
  final int? latestTimestamp;

  /// Total number of photos to cache (for progress display).
  final int totalToCache;

  /// Number of photos cached so far (for progress display).
  final int cachedCount;

  const KioskPhotoPrefetchState({
    this.photos = const [],
    this.isInitialLoadDone = false,
    this.isMinimalCacheDone = false,
    this.isSyncing = false,
    this.latestTimestamp,
    this.totalToCache = 0,
    this.cachedCount = 0,
  });

  /// Progress ratio (0.0 ~ 1.0). Returns 1.0 when done or nothing to cache.
  double get cacheProgress =>
      totalToCache > 0 ? (cachedCount / totalToCache).clamp(0.0, 1.0) : 0.0;

  KioskPhotoPrefetchState copyWith({
    List<KioskPhoto>? photos,
    bool? isInitialLoadDone,
    bool? isMinimalCacheDone,
    bool? isSyncing,
    int? latestTimestamp,
    int? totalToCache,
    int? cachedCount,
  }) {
    return KioskPhotoPrefetchState(
      photos: photos ?? this.photos,
      isInitialLoadDone: isInitialLoadDone ?? this.isInitialLoadDone,
      isMinimalCacheDone: isMinimalCacheDone ?? this.isMinimalCacheDone,
      isSyncing: isSyncing ?? this.isSyncing,
      latestTimestamp: latestTimestamp ?? this.latestTimestamp,
      totalToCache: totalToCache ?? this.totalToCache,
      cachedCount: cachedCount ?? this.cachedCount,
    );
  }
}

class ImagePrefetchNotifier extends StateNotifier<KioskPhotoPrefetchState> {
  final KioskPhotoRepository _repository;
  final PrefetchConfig _config;
  final CacheManager _cacheManager = KioskPhotoCacheManager.instance;

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

  /// Force a delta sync (for refresh button). Skips pause check.
  Future<void> forceSync() async {
    if (state.isSyncing) return;
    debugPrint('[Prefetch] Force sync triggered');
    state = state.copyWith(isSyncing: true);
    try {
      await _deltaSync();
    } catch (e) {
      debugPrint('[Prefetch] Force sync error: $e');
    } finally {
      if (mounted) {
        state = state.copyWith(isSyncing: false);
      }
    }
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
      if (mounted) state = state.copyWith(isInitialLoadDone: true, isMinimalCacheDone: true);
      return;
    }

    final newestTimestamp = allPhotos.first.timestamp;

    // Update photo list immediately so UI can start showing
    if (mounted) {
      state = state.copyWith(
        photos: List.unmodifiable(allPhotos),
        latestTimestamp: newestTimestamp,
        totalToCache: allPhotos.length,
        cachedCount: 0,
      );
    }

    // Pre-download all images to disk cache (concurrent)
    // First ~20 images trigger isMinimalCacheDone for fast UI entry
    const minimalCacheCount = 20;
    await _precacheToDisk(allPhotos, reportProgress: true, minimalCount: minimalCacheCount);
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
  /// When [minimalCount] > 0, sets [isMinimalCacheDone] after that many images.
  Future<void> _precacheToDisk(
    List<KioskPhoto> photos, {
    bool reportProgress = false,
    int minimalCount = 0,
  }) async {
    const concurrency = 10;
    int cached = 0;
    bool minimalDone = minimalCount <= 0;

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

      if (reportProgress && mounted) {
        cached += batch.length;
        state = state.copyWith(cachedCount: cached);
      }

      // Signal minimal cache done once we've cached enough for the first screen
      if (!minimalDone && cached >= minimalCount && mounted) {
        minimalDone = true;
        state = state.copyWith(isMinimalCacheDone: true);
        debugPrint('[Prefetch] Minimal cache done ($cached/$minimalCount) - UI can enter');
      }
    }

    // If total photos < minimalCount, mark minimal done at the end
    if (!minimalDone && mounted) {
      state = state.copyWith(isMinimalCacheDone: true);
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

/// Convenience provider: whether minimal cache (first screen) is done.
final prefetchMinimalCacheDoneProvider = Provider<bool>((ref) {
  return ref.watch(imagePrefetchProvider).isMinimalCacheDone;
});

/// Convenience provider: cache progress (0.0 ~ 1.0).
final prefetchCacheProgressProvider = Provider<double>((ref) {
  return ref.watch(imagePrefetchProvider).cacheProgress;
});
