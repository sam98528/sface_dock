// lib/core/device/device_controller_proxy_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'device_controller_proxy.dart';

/// 연결 상태 전용 Provider — 연결 완료/해제 시 갱신되어 카메라·LiveView 카드 등이 리빌드됨
final connectionStateProvider = StateProvider<bool>((ref) => false);

/// DeviceControllerProxy Provider
///
/// 앱 레벨에서 단일 인스턴스로 관리.
/// 세션 시작 시 연결되고, 세션 종료 시 해제됩니다.
final deviceControllerProxyProvider = Provider<DeviceControllerProxy>((ref) {
  final proxy = DeviceControllerProxy();
  final connectionNotifier = ref.read(connectionStateProvider.notifier);

  // 자동 연결 비활성화 - 세션 시작 시에만 연결
  // SessionController.startSession()에서 ensureConnected()를 호출합니다.
  // 이렇게 하면 세션 중에만 장비 포트를 점유합니다.

  ref.onDispose(() {
    connectionNotifier.state = false;
    proxy.disconnect();
  });

  return proxy;
});
