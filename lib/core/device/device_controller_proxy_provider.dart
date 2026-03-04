// lib/core/device/device_controller_proxy_provider.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'device_controller_proxy.dart';

/// 연결 상태 전용 Provider — 연결 완료/해제 시 갱신되어 카메라·LiveView 카드 등이 리빌드됨
final connectionStateProvider = StateProvider<bool>((ref) => false);

/// DeviceControllerProxy Provider
///
/// 앱 레벨에서 단일 인스턴스로 관리.
/// connect()는 첫 프레임 그린 뒤에 시작해 메인 스레드 블로킹을 줄임.
final deviceControllerProxyProvider = Provider<DeviceControllerProxy>((ref) {
  final proxy = DeviceControllerProxy();
  final connectionNotifier = ref.read(connectionStateProvider.notifier);

  // Named Pipe 연결은 FFI에서 블로킹하므로, 첫 프레임 그린 뒤에 시작해 UI가 먼저 보이게 함.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    proxy.connect().then((connected) {
      if (ref.exists(connectionStateProvider)) {
        connectionNotifier.state = connected;
      }
      if (connected) {
        print('Device Controller Service connected successfully');
      } else {
        print('Device Controller Service connection failed');
        print('Please ensure the service is running and try again');
      }
    }).catchError((error) {
      print('Device Controller Service connection error: $error');
      if (ref.exists(connectionStateProvider)) {
        connectionNotifier.state = false;
      }
    });
  });

  ref.onDispose(() {
    connectionNotifier.state = false;
    proxy.disconnect();
  });

  return proxy;
});
