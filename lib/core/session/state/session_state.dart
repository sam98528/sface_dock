// lib/core/session/state/session_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_state.freezed.dart';

/// Session end reasons.
enum SessionEndReason {
  normal,
  timeout,
  error,
  failure,
}

/// Session state model.
///
/// Represents the current session lifecycle state.
/// Immutable data structure following playbook rules.
@freezed
class SessionState with _$SessionState {
  const factory SessionState.idle() = _Idle;
  const factory SessionState.active() = _Active;
  const factory SessionState.ended({
    required SessionEndReason reason,
  }) = _Ended;
  /// 디바이스 체크 실패 시 표시. errorCodes는 서버 전달용.
  const factory SessionState.deviceError({
    required List<String> errorCodes,
  }) = _DeviceError;
}
