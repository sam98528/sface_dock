// lib/services/devices/camera/ipc_camera_service.dart
//
// IPC 기반 카메라 서비스 구현체.
// DeviceControllerProxy를 통해 Named Pipe로 서비스와 통신.

import 'dart:async';

import '../../device_controller_proxy.dart';
import 'camera_service.dart';

/// IPC(Named Pipe)를 통한 카메라 서비스 구현.
class IpcCameraService implements CameraService {
  IpcCameraService(this._proxy);

  final DeviceControllerProxy _proxy;

  @override
  Future<Map<String, dynamic>?> setSession(String sessionId) {
    return _proxy.setCameraSession(sessionId);
  }

  @override
  Future<Map<String, dynamic>?> capture({
    required String sessionId,
    required int imageIndex,
  }) {
    return _proxy.captureCamera(
      sessionId: sessionId,
      imageIndex: imageIndex,
    );
  }

  @override
  Future<Map<String, dynamic>?> startPreview() {
    return _proxy.sendCommand('camera_start_preview', <String, String>{});
  }

  @override
  Future<Map<String, dynamic>?> stopPreview() {
    return _proxy.sendCommand('camera_stop_preview', <String, String>{});
  }

  @override
  Future<Map<String, dynamic>?> reconnect() {
    return _proxy.reconnectCamera();
  }

  @override
  Future<Map<String, dynamic>?> enableQrDetection(bool enable) {
    return _proxy.enableQrDetection(enable);
  }

  @override
  Future<Map<String, dynamic>?> resetQrDetection() {
    return _proxy.resetQrDetection();
  }

  @override
  Stream<Map<String, dynamic>> get captureEvents {
    return _proxy.eventStream.where((event) {
      return event['kind'] == 'event' &&
          event['eventType'] == 'camera_capture_complete';
    });
  }

  @override
  Stream<String> get qrDetectedEvents {
    return _proxy.eventStream
        .where((event) =>
            event['kind'] == 'event' &&
            event['eventType'] == 'qr_code_detected')
        .map((event) {
      final data = event['data'] as Map<String, dynamic>?;
      return data?['qrText']?.toString() ?? '';
    }).where((text) => text.isNotEmpty);
  }
}
