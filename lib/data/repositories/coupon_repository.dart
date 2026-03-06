import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';
import '../../core/constants/api_constants.dart';
import '../models/coupon/coupon_verify_result.dart';

class CouponRepository {
  final ApiClient _apiClient;

  CouponRepository(this._apiClient);

  /// Dio 응답이 String일 수 있으므로 dynamic으로 받아서 파싱
  Map<String, dynamic>? _parseResponse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is String) {
      try {
        final parsed = jsonDecode(data);
        if (parsed is Map<String, dynamic>) return parsed;
      } catch (_) {}
    }
    return null;
  }

  Future<CouponVerifyResult> verifyCoupon(
    String code, {
    String? store,
  }) async {
    final queryParams = <String, dynamic>{'code': code};
    if (store != null) queryParams['store'] = store;

    final result = await _apiClient.get<dynamic>(
      ApiConstants.couponVerifyEndpoint,
      queryParameters: queryParams,
    );

    switch (result) {
      case ApiSuccess<dynamic>(data: final rawData):
        final data = _parseResponse(rawData);
        debugPrint('[CouponRepo] parsed response: $data');
        if (data == null) {
          return CouponVerifyResult.invalid('서버 응답을 파싱할 수 없습니다.');
        }
        return CouponVerifyResult.fromVerifyResponse(data, code);
      case ApiError<dynamic>(message: final message):
        return CouponVerifyResult.invalid(message);
      case ApiLoading<dynamic>():
        return CouponVerifyResult.invalid('요청 처리 중입니다.');
    }
  }

  Future<bool> useCoupon(String couponCode, String usedStore) async {
    final result = await _apiClient.post<dynamic>(
      ApiConstants.couponUseEndpoint,
      data: {
        'coupon_code': couponCode,
        'used_store': usedStore,
      },
    );

    switch (result) {
      case ApiSuccess<dynamic>(data: final rawData):
        final data = _parseResponse(rawData);
        return data?['success'] == true;
      case ApiError<dynamic>():
        return false;
      case ApiLoading<dynamic>():
        return false;
    }
  }
}

final couponRepositoryProvider = Provider<CouponRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return CouponRepository(apiClient);
});
