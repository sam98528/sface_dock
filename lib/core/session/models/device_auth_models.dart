// lib/core/session/models/device_auth_models.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_auth_models.freezed.dart';
part 'device_auth_models.g.dart';

/// Backend login response: POST /client/device/login
@freezed
sealed class DeviceLoginResponse with _$DeviceLoginResponse {
  const factory DeviceLoginResponse({
    required bool success,
    String? message,
    DeviceLoginData? data,
  }) = _DeviceLoginResponse;

  factory DeviceLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceLoginResponseFromJson(json);
}

@freezed
sealed class DeviceLoginData with _$DeviceLoginData {
  const factory DeviceLoginData({
    // ignore: non_constant_identifier_names
    String? device_id,
    // ignore: non_constant_identifier_names
    String? device_name,
    // ignore: non_constant_identifier_names
    String? device_password,
  }) = _DeviceLoginData;

  factory DeviceLoginData.fromJson(Map<String, dynamic> json) =>
      _$DeviceLoginDataFromJson(json);
}

/// Request body for PUT /client/device (전체 optional 필드 — 테스트용)
@freezed
sealed class UpdateDeviceRequest with _$UpdateDeviceRequest {
  const factory UpdateDeviceRequest({
    // ignore: non_constant_identifier_names
    String? device_name,
    // ignore: non_constant_identifier_names
    String? software_type,
    // ignore: non_constant_identifier_names
    bool? is_active,
    // ignore: non_constant_identifier_names
    bool? allow_update,
    // ignore: non_constant_identifier_names
    bool? disabled_select_filter,
    // ignore: non_constant_identifier_names
    String? app_version,
    // ignore: non_constant_identifier_names
    String? before_app_version,
    // ignore: non_constant_identifier_names
    bool? is_tester,
    // ignore: non_constant_identifier_names
    bool? allow_select_paper_type,
    // ignore: non_constant_identifier_names
    bool? enabled_basic_paper,
    // ignore: non_constant_identifier_names
    String? additional_paper_types,
    // ignore: non_constant_identifier_names
    int? remotecon_type,
    // ignore: non_constant_identifier_names
    String? camera_angle,
    // ignore: non_constant_identifier_names
    String? camera_model,
    // ignore: non_constant_identifier_names
    String? camera_lens,
    // ignore: non_constant_identifier_names
    String? printer_model,
    // ignore: non_constant_identifier_names
    int? printer_lifecounter,
    // ignore: non_constant_identifier_names
    String? printer_remaining,
    // ignore: non_constant_identifier_names
    String? payment_methods,
    // ignore: non_constant_identifier_names
    String? cardreader_num,
    // ignore: non_constant_identifier_names
    String? billacceptor_num,
    // ignore: non_constant_identifier_names
    String? print_types,
    // ignore: non_constant_identifier_names
    String? photo_types,
    // ignore: non_constant_identifier_names
    String? liveview_modes,
    String? note,
    // ignore: non_constant_identifier_names
    bool? print_greyscale_additional,
    // ignore: non_constant_identifier_names
    bool? fix_print_quantity,
    // ignore: non_constant_identifier_names
    int? winning_probability,
    // ignore: non_constant_identifier_names
    int? liveview_timer_countDown,
    // ignore: non_constant_identifier_names
    int? liveview_timer_remote,
    // ignore: non_constant_identifier_names
    int? liveview_timer_remote_cont,
    // ignore: non_constant_identifier_names
    String? send_userphotos_methods,
    // ignore: non_constant_identifier_names
    bool? is_offline_mode,
    // ignore: non_constant_identifier_names
    String? is_verified,
  }) = _UpdateDeviceRequest;

  factory UpdateDeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateDeviceRequestFromJson(json);
}

/// Backend 4xx/5xx common error shape
@freezed
sealed class ApiError with _$ApiError {
  const factory ApiError({
    int? statusCode,
    String? message,
    String? error,
    int? code,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
}
