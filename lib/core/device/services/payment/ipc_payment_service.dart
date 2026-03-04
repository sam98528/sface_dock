// lib/core/device/services/payment/ipc_payment_service.dart
//
// IPC 기반 결제 단말기 서비스 구현체.

import 'dart:async';

import '../../device_controller_proxy.dart';
import 'payment_device_service.dart';

/// IPC(Named Pipe)를 통한 결제 단말기 서비스 구현.
class IpcPaymentService implements PaymentDeviceService {
  IpcPaymentService(this._proxy);

  final DeviceControllerProxy _proxy;

  @override
  Future<Map<String, dynamic>?> startPayment(int amount) {
    return _proxy.startPayment(amount);
  }

  @override
  Future<Map<String, dynamic>?> cancelPayment() {
    return _proxy.cancelPayment();
  }

  @override
  Future<Map<String, dynamic>?> checkPaymentStatus() {
    return _proxy.checkPaymentStatus();
  }

  @override
  Future<Map<String, dynamic>?> resetTerminal() {
    return _proxy.resetPaymentTerminal();
  }

  @override
  Future<Map<String, dynamic>?> checkDevice() {
    return _proxy.checkPaymentDevice();
  }

  @override
  Future<Map<String, dynamic>?> readCardUid() {
    return _proxy.readCardUid();
  }

  @override
  Future<Map<String, dynamic>?> getLastApproval() {
    return _proxy.getLastApproval();
  }

  @override
  Future<Map<String, dynamic>?> checkIcCard() {
    return _proxy.checkIcCard();
  }

  @override
  Future<Map<String, dynamic>?> cancelTransaction({
    required String cancelType,
    required int transactionType,
    required int amount,
    required String approvalNumber,
    required String originalDate,
    required String originalTime,
    int tax = 0,
    int service = 0,
    int installments = 0,
    String additionalInfo = '',
  }) {
    return _proxy.cancelTransaction(
      cancelType: cancelType,
      transactionType: transactionType,
      amount: amount,
      approvalNumber: approvalNumber,
      originalDate: originalDate,
      originalTime: originalTime,
      tax: tax,
      service: service,
      installments: installments,
      additionalInfo: additionalInfo,
    );
  }

  @override
  Future<Map<String, dynamic>?> setScreenSound({
    required int screenBrightness,
    required int soundVolume,
    required int touchSoundVolume,
  }) {
    return _proxy.setScreenSound(
      screenBrightness: screenBrightness,
      soundVolume: soundVolume,
      touchSoundVolume: touchSoundVolume,
    );
  }

  @override
  Stream<Map<String, dynamic>> get paymentEvents {
    return _proxy.eventStream.where((event) {
      return event['kind'] == 'event' &&
          event['deviceType'] == 'payment';
    });
  }
}
