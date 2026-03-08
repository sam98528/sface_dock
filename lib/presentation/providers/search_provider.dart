import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/image_prefetch_service.dart';
import '../../data/models/kiosk/kiosk_photo.dart';

enum PhotoSortOption { newest, oldest, mostLiked }

final searchQueryProvider = StateProvider<String>((ref) => '');
final photoSortOptionProvider =
    StateProvider<PhotoSortOption>((ref) => PhotoSortOption.newest);

final filteredPhotosProvider = Provider<List<KioskPhoto>>((ref) {
  final photos = ref.watch(prefetchedPhotosProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final sortOption = ref.watch(photoSortOptionProvider);

  List<KioskPhoto> result;
  if (query.isEmpty) {
    result = [...photos];
  } else {
    result = photos.where((photo) {
      return photo.ownerUsername.toLowerCase().contains(query) ||
          photo.feedsContent.toLowerCase().contains(query) ||
          photo.postId.contains(query);
    }).toList();
  }

  switch (sortOption) {
    case PhotoSortOption.newest:
      result.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    case PhotoSortOption.oldest:
      result.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    case PhotoSortOption.mostLiked:
      result.sort((a, b) => b.feedsLike.compareTo(a.feedsLike));
  }

  return result;
});
