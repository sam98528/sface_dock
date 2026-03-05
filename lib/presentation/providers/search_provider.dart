import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/image_prefetch_service.dart';
import '../../data/models/kiosk/kiosk_photo.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredPhotosProvider = Provider<List<KioskPhoto>>((ref) {
  final photos = ref.watch(prefetchedPhotosProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  if (query.isEmpty) {
    return photos;
  }

  return photos.where((photo) {
    return photo.ownerUsername.toLowerCase().contains(query) ||
        photo.postId.contains(query); // Post ID might be useful to search too
  }).toList();
});
