// lib/services/devices/camera/camera_service.dart
//
// 카메라 디바이스 추상 인터페이스.
// 다른 기기/프로젝트에서 재사용 가능하도록 IPC 구현과 분리.

/// 카메라 디바이스 서비스 인터페이스.
///
/// 구현체는 IPC, 직접 SDK 호출 등 다양할 수 있음.
abstract class CameraService {
  /// 촬영 세션 설정 (세션 ID로 저장 폴더 지정).
  Future<Map<String, dynamic>?> setSession(String sessionId);

  /// 촬영 요청. [imageIndex]는 세션 내 이미지 번호 (0, 1, 2, ...).
  Future<Map<String, dynamic>?> capture({
    required String sessionId,
    required int imageIndex,
  });

  /// 라이브뷰 시작. 성공 시 MJPEG URL 등이 응답에 포함.
  Future<Map<String, dynamic>?> startPreview();

  /// 라이브뷰 정지.
  Future<Map<String, dynamic>?> stopPreview();

  /// 카메라 재연결 (EDSDK shutdown → reinit).
  Future<Map<String, dynamic>?> reconnect();

  /// 카메라 관련 이벤트 스트림 (capture_complete 등).
  Stream<Map<String, dynamic>> get captureEvents;
}
