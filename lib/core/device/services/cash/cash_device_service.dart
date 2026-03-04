// lib/services/devices/cash/cash_device_service.dart
//
// 현금 수납기(LV77) 디바이스 추상 인터페이스.

/// 현금 수납기 서비스 인터페이스.
abstract class CashDeviceService {
  /// 현금 결제 시작 (목표 금액 지정).
  Future<Map<String, dynamic>?> startCashPayment(int amount);

  /// 현금 테스트 모드 시작 (디버그/어드민용).
  Future<Map<String, dynamic>?> startCashTest();

  /// 현금 관련 이벤트 스트림 (cash_payment_target_reached, cash_bill_stacked 등).
  Stream<Map<String, dynamic>> get cashEvents;

  /// 현금 테스트 중 누적 금액 스트림 (디버그/어드민용).
  Stream<int> get cashTestAmountStream;
}
