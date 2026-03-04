// lib/core/session/services/kiosk_backend_api.dart

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// 1. POST /client/verify → device_password (실제 경로: POST /client/device/login)
/// 2. POST /client/upload/presign → attach_id[]
/// 3. PUT (S3 presigned_url) → S3 직접 업로드
/// 4. POST /client/upload/confirm → 업로드 완료 확인
/// 5. POST /client/payment → order_id, sale_id
/// 6. POST /client/generate → job_id
/// 7. GET /client/generate/status → 생성 상태 (폴링)
/// 8. 완료 시 생성된 이미지 URL 배열 수신

/// HTTP client for kiosk-backend-nestjs (device login, upload, payment, generate).
class KioskBackendApi {
  KioskBackendApi({String? baseUrl})
    : _dio = _createDio(baseUrl ?? _defaultBaseUrl);

  static const String _defaultBaseUrl = 'http://localhost:3000';

  final Dio _dio;

  /// Public getter for Dio instance (for advanced usage)
  Dio get dio => _dio;

  static Dio _createDio(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );
    // Flutter Windows 데스크톱은 OS 인증서 저장소가 아닌 자체 CA 번들(BoringSSL)을
    // 사용하여 일부 서버 인증서 검증이 실패할 수 있음 (HandshakeException).
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
    return dio;
  }

  Options _authOptions(
    String devicePassword, {
    Duration? sendTimeout,
    Duration? receiveTimeout,
  }) {
    return Options(
      responseType: ResponseType.json,
      headers: {'Authorization': 'Bearer $devicePassword'},
      sendTimeout: sendTimeout ?? const Duration(seconds: 10),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 10),
    );
  }

  /// 1. POST /client/device/login (기기 인증 → device_password)
  /// Body: { "password": string }
  /// Returns: { success, message?, data?: { device_id, device_name, device_password } }
  Future<Map<String, dynamic>> deviceLogin(String password) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/client/device/login',
      data: {'password': password},
      options: Options(responseType: ResponseType.json),
    );
    return response.data ?? {};
  }

  /// GET /client/device/status
  Future<Map<String, dynamic>> getDeviceStatus(String devicePassword) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/client/device/status',
      options: _authOptions(devicePassword),
    );
    return response.data ?? {};
  }

  /// PUT /client/device
  Future<Map<String, dynamic>> updateDevice({
    required String devicePassword,
    required Map<String, dynamic> body,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/client/device',
      data: body,
      options: _authOptions(devicePassword),
    );
    return response.data ?? {};
  }

  /// 2. POST /client/upload/presign (배열)
  /// Body: { items: [{ index, originalName, fileType, fileSize?, directory? }] }
  /// Returns: { success, data: [{ index, attach_id, presigned_url, file_path, file_name, expires_in }] }
  Future<Map<String, dynamic>> presignMultiple({
    required String devicePassword,
    required List<PresignItemRequest> items,
  }) async {
    final body = {
      'items': items
          .map(
            (e) => {
              'index': e.index,
              'originalName': e.originalName,
              'fileType': e.fileType,
              if (e.fileSize != null) 'fileSize': e.fileSize,
              if (e.directory != null) 'directory': e.directory,
            },
          )
          .toList(),
    };
    final response = await _dio.post<Map<String, dynamic>>(
      '/client/upload/presign',
      data: body,
      options: _authOptions(
        devicePassword,
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    return response.data ?? {};
  }

  /// 4. POST /client/upload/confirm (배열)
  /// Body: { items: [{ index, attachId }] }
  /// Returns: { success, data: [{ index, attach_id, file_path, status, success, error? }] }
  Future<Map<String, dynamic>> confirmUploadMultiple({
    required String devicePassword,
    required List<ConfirmItemRequest> items,
  }) async {
    final body = {
      'items': items
          .map((e) => {'index': e.index, 'attachId': e.attachId})
          .toList(),
    };
    final response = await _dio.post<Map<String, dynamic>>(
      '/client/upload/confirm',
      data: body,
      options: _authOptions(
        devicePassword,
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    return response.data ?? {};
  }

  /// 5. POST /client/payment (결제 처리 → order_id, sale_id)
  /// Body: { order: { photo_type, quantity, print_type?, send_userphotos? }, payment: { transactionId, amount, status, salesDate, salesTime, ... } }
  /// Returns: { success, data: { sale_id, order_id, paid_result, amount, paid_at } }
  Future<Map<String, dynamic>> createPayment({
    required String devicePassword,
    required Map<String, dynamic> order,
    required Map<String, dynamic> payment,
    int? discount,
    String? couponCode,
  }) async {
    final body = <String, dynamic>{'order': order, 'payment': payment};
    if (discount != null) body['discount'] = discount;
    if (couponCode != null) body['coupon_code'] = couponCode;

    final response = await _dio.post<Map<String, dynamic>>(
      '/client/payment',
      data: body,
      options: _authOptions(
        devicePassword,
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    return response.data ?? {};
  }

  /// 6. POST /client/generate (AI 이미지 생성 요청 → job_id)
  /// Body: { order_id: number, items: [{ index, attach_id, nano_id }] }
  /// Returns: { success, data: { job_id, order_id, status, total_count, items } }
  Future<Map<String, dynamic>> createGeneration({
    required String devicePassword,
    required int orderId,
    required List<GenerateItemRequest> items,
  }) async {
    final body = {
      'order_id': orderId,
      'items': items
          .map(
            (e) => {
              'index': e.index,
              'attach_id': e.attachId,
              'nano_id': e.nanoId,
              if (e.aspectRatio != null) 'aspect_ratio': e.aspectRatio,
            },
          )
          .toList(),
    };
    log('body: $body');
    final response = await _dio.post<Map<String, dynamic>>(
      '/client/generate',
      data: body,
      options: _authOptions(
        devicePassword,
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    return response.data ?? {};
  }

  /// GET /client/device/totalInfo (기기 종합 정보: device + pricing + nanobanana)
  /// Returns: { success, statusCode, data: { device, pricing, nanobanana } }
  Future<Map<String, dynamic>> getTotalInfo(String devicePassword) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/client/device/totalInfo',
      options: _authOptions(devicePassword),
    );
    return response.data ?? {};
  }

  /// 7. GET /client/generate/status?job_id=xxx (생성 상태 폴링)
  /// Returns: { success, data: { job_id, order_id, status, total_count, completed_count, failed_count, items, ... } }
  Future<Map<String, dynamic>> getGenerationStatus({
    required String devicePassword,
    required String jobId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/client/generate/status',
      queryParameters: {'job_id': jobId},
      options: _authOptions(devicePassword),
    );
    return response.data ?? {};
  }

  /// GET /client/app/version (앱 최신 버전 확인)
  /// Returns: { success, data: { latest_version, download_url, release_notes, file_size, checksum_sha256, mandatory } }
  Future<Map<String, dynamic>> getLatestVersion({
    required String devicePassword,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/client/app/version',
      options: _authOptions(devicePassword),
    );
    return response.data ?? {};
  }

  /// PUT /client/sales/:saleId/media (Sale 미디어 정보 업데이트)
  /// Body: { result_img?, result_video?, photo_img1?, photo_img2?, ... }
  /// Returns: { success, statusCode, message, data }
  Future<Map<String, dynamic>> updateSaleMedia({
    required String devicePassword,
    required int saleId,
    required Map<String, dynamic> body,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/client/sales/$saleId/media',
      data: body,
      options: _authOptions(devicePassword),
    );
    return response.data ?? {};
  }
}

/// Presign 요청 한 건
class PresignItemRequest {
  const PresignItemRequest({
    required this.index,
    required this.originalName,
    required this.fileType,
    this.fileSize,
    this.directory,
  });
  final int index;
  final String originalName;
  final String fileType;
  final int? fileSize;
  final String? directory;
}

/// Confirm 요청 한 건
class ConfirmItemRequest {
  const ConfirmItemRequest({required this.index, required this.attachId});
  final int index;
  final int attachId;
}

/// Generate 요청 한 건
class GenerateItemRequest {
  const GenerateItemRequest({
    required this.index,
    required this.attachId,
    required this.nanoId,
    this.aspectRatio,
  });
  final int index;
  final int attachId;
  final int nanoId;
  final String? aspectRatio;
}
