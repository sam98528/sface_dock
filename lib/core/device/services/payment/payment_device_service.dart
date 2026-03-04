// lib/core/device/services/payment/payment_device_service.dart
//
// 결제 단말기 디바이스 추상 인터페이스.

/// 결제 단말기 서비스 인터페이스 (카드 결제).
abstract class PaymentDeviceService {
  /// 카드 결제 시작.
  Future<Map<String, dynamic>?> startPayment(int amount);

  /// 진행 중인 결제 취소.
  Future<Map<String, dynamic>?> cancelPayment();

  /// 결제 상태 확인.
  Future<Map<String, dynamic>?> checkPaymentStatus();

  /// 결제 단말기 리셋.
  Future<Map<String, dynamic>?> resetTerminal();

  /// 결제 단말기 상태 체크.
  Future<Map<String, dynamic>?> checkDevice();

  /// 카드 UID 읽기.
  Future<Map<String, dynamic>?> readCardUid();

  /// 마지막 승인 정보 조회.
  Future<Map<String, dynamic>?> getLastApproval();

  /// IC 카드 체크.
  Future<Map<String, dynamic>?> checkIcCard();

  /// 거래(승인) 취소.
  Future<Map<String, dynamic>?> cancelTransaction({
    required String cancelType,
    required int transactionType,
    required int amount,
    required String approvalNumber,
    required String originalDate,
    required String originalTime,
    int tax,
    int service,
    int installments,
    String additionalInfo,
  });

  /// 화면/소리 설정.
  Future<Map<String, dynamic>?> setScreenSound({
    required int screenBrightness,
    required int soundVolume,
    required int touchSoundVolume,
  });

  /// 결제 관련 이벤트 스트림 (payment_complete, payment_failed 등).
  Stream<Map<String, dynamic>> get paymentEvents;
}
