import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';
import '../../core/constants/api_constants.dart';
import '../models/kiosk/kiosk_photo.dart';

class KioskPhotoRepository {
  final ApiClient _apiClient;

  KioskPhotoRepository(this._apiClient);

  /// Fetch kiosk photos with optional time-based filtering.
  ///
  /// [maxCount] - maximum number of photos to return (default: 100)
  /// [after] - Unix timestamp, only return photos created after this time
  /// [before] - Unix timestamp, only return photos created before this time
  Future<ApiResult<List<KioskPhoto>>> getPhotos({
    int maxCount = 100,
    int? after,
    int? before,
  }) async {
    final queryParams = <String, dynamic>{'maxCount': maxCount.toString()};
    if (after != null) queryParams['after'] = after.toString();
    if (before != null) queryParams['before'] = before.toString();

    final result = await _apiClient.get<List<dynamic>>(
      ApiConstants.kioskPhotosEndpoint,
      queryParameters: queryParams,
    );

    switch (result) {
      case ApiSuccess<List<dynamic>>(data: final data):
        try {
          final photos = data
              .map((e) => KioskPhoto.fromJson(e as Map<String, dynamic>))
              .toList();
          return ApiSuccess(photos);
        } catch (e) {
          return ApiError('Failed to parse kiosk photos: $e');
        }
      case ApiError<List<dynamic>>(
        message: final message,
        statusCode: final statusCode,
      ):
        return ApiError(message, statusCode: statusCode);
      case ApiLoading<List<dynamic>>():
        return const ApiLoading();
    }
  }
}

final kioskPhotoRepositoryProvider = Provider<KioskPhotoRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return KioskPhotoRepository(apiClient);
});
