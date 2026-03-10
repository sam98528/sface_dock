// lib/core/session/state/device_auth_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_auth_state.freezed.dart';

/// 기기 인증 상태 (백엔드 device_password = Bearer 토큰)
@freezed
sealed class DeviceAuthState with _$DeviceAuthState {
  /// 초기
  const factory DeviceAuthState.initial() = DeviceAuthInitial;

  /// 미로그인
  const factory DeviceAuthState.notLoggedIn() = DeviceAuthNotLoggedIn;

  /// 로그인 요청 중
  const factory DeviceAuthState.loggingIn() = DeviceAuthLoggingIn;

  /// 로그인됨 — 이후 API 호출 시 Bearer device_password 사용
  const factory DeviceAuthState.loggedIn({
    required String devicePassword,
    String? deviceId,
    String? deviceName,
  }) = DeviceAuthLoggedIn;

  /// 오류 (메시지 표시용)
  const factory DeviceAuthState.error({
    required String message,
  }) = DeviceAuthError;
}
