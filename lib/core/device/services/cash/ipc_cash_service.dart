// lib/services/devices/cash/ipc_cash_service.dart
//
// IPC 기반 현금 수납기 서비스 구현체.

import 'dart:async';

import '../../device_controller_proxy.dart';
import 'cash_device_service.dart';

/// IPC(Named Pipe)를 통한 현금 수납기 서비스 구현.
class IpcCashService implements CashDeviceService {
  IpcCashService(this._proxy);

  final DeviceControllerProxy _proxy;

  @override
  Future<Map<String, dynamic>?> startCashPayment(int amount) {
    return _proxy.startCashPayment(amount);
  }

  @override
  Future<Map<String, dynamic>?> startCashTest() {
    return _proxy.startCashTest();
  }

  @override
  Stream<Map<String, dynamic>> get cashEvents {
    return _proxy.eventStream.where((event) {
      return event['kind'] == 'event' &&
          event['deviceType'] == 'cash';
    });
  }

  @override
  Stream<int> get cashTestAmountStream => _proxy.cashTestAmountStream;
}
