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
