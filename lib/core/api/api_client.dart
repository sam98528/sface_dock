import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/api_constants.dart';
import 'api_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dio = Dio();

class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.receiveTimeout,
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (!options.headers.containsKey('Content-Type')) {
            options.headers['Content-Type'] = 'application/json';
          }
          options.headers['Accept'] = 'application/json';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            'Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          _logger.d('Response data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('Error: ${error.message}');
          _logger.e('Request URL: ${error.requestOptions.uri}');
          _logger.e('Error Type: ${error.type}');
          if (error.response != null) {
            _logger.e(
              'Response: ${error.response?.statusCode} - ${error.response?.data}',
            );
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiSuccess(response.data as T);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiError('예상치 못한 오류가 발생했습니다: $e');
    }
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiSuccess(response.data as T);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiError('예상치 못한 오류가 발생했습니다: $e');
    }
  }

  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiSuccess(response.data as T);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiError('예상치 못한 오류가 발생했습니다: $e');
    }
  }

  Future<ApiResult<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiSuccess(response.data as T);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiError('예상치 못한 오류가 발생했습니다: $e');
    }
  }

  ApiError<T> _handleDioError<T>(DioException error) {
    String message;
    int? statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = '연결 시간이 초과되었습니다.';
        break;
      case DioExceptionType.sendTimeout:
        message = '요청 전송 시간이 초과되었습니다.';
        break;
      case DioExceptionType.receiveTimeout:
        message = '응답 수신 시간이 초과되었습니다.';
        break;
      case DioExceptionType.badResponse:
        message = error.response?.data?['message'] ?? '서버 오류가 발생했습니다.';
        break;
      case DioExceptionType.cancel:
        message = '요청이 취소되었습니다.';
        break;
      case DioExceptionType.connectionError:
        message = '서버에 연결할 수 없습니다. 네트워크 연결을 확인해주세요.';
        break;
      default:
        message = '알 수 없는 오류가 발생했습니다.';
    }

    return ApiError(message, statusCode: statusCode, originalError: error);
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});
