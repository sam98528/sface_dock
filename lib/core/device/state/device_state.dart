// lib/core/device/state/device_state.dart
//
// 공통 디바이스 상태 enum.
// Device Controller Service가 반환하는 상태 코드(0~4)를 타입으로 통합.

/// 디바이스 상태 — 모든 디바이스 유형에 공통.
enum DeviceState {
  /// 연결 안 됨 (service 측 stateInt == 0)
  disconnected,

  /// 초기화 대기 (stateInt == 1)
  waiting,

  /// 준비됨 / 사용 가능 (stateInt == 2, stateString == 'READY')
  ready,

  /// 작업 중 (stateInt == 3)
  processing,

  /// 오류 (stateInt == 4)
  error,

  /// 알 수 없음
  unknown;

  /// Service에서 받은 정수 상태 코드를 enum으로 변환.
  static DeviceState fromInt(int? code) {
    switch (code) {
      case 0:
        return DeviceState.disconnected;
      case 1:
        return DeviceState.waiting;
      case 2:
        return DeviceState.ready;
      case 3:
        return DeviceState.processing;
      case 4:
        return DeviceState.error;
      default:
        return DeviceState.unknown;
    }
  }

  /// Service에서 받은 문자열 상태를 enum으로 변환.
  static DeviceState fromString(String? stateStr) {
    if (stateStr == null) return DeviceState.unknown;
    switch (stateStr.toUpperCase()) {
      case 'DISCONNECTED':
        return DeviceState.disconnected;
      case 'WAITING':
        return DeviceState.waiting;
      case 'READY':
        return DeviceState.ready;
      case 'PROCESSING':
        return DeviceState.processing;
      case 'ERROR':
        return DeviceState.error;
      default:
        return DeviceState.unknown;
    }
  }

  /// 이 상태가 "사용 가능" 상태인지.
  bool get isReady => this == DeviceState.ready;
}
