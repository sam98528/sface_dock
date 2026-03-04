// lib/core/device/services/device_service_providers.dart
//
// 디바이스별 서비스 Riverpod Provider.
// 현재는 모두 IPC 구현체를 사용. 다른 기기/프로젝트에서는 구현체만 교체.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../device_controller_proxy_provider.dart';
import 'camera/camera_service.dart';
import 'camera/ipc_camera_service.dart';
import 'cash/cash_device_service.dart';
import 'cash/ipc_cash_service.dart';
import 'payment/ipc_payment_service.dart';
import 'payment/payment_device_service.dart';
import 'printer/ipc_printer_service.dart';
import 'printer/printer_service.dart';

/// 카메라 서비스 Provider.
final cameraServiceProvider = Provider<CameraService>((ref) {
  final proxy = ref.watch(deviceControllerProxyProvider);
  return IpcCameraService(proxy);
});

/// 결제 단말기 서비스 Provider.
final paymentDeviceServiceProvider = Provider<PaymentDeviceService>((ref) {
  final proxy = ref.watch(deviceControllerProxyProvider);
  return IpcPaymentService(proxy);
});

/// 현금 수납기 서비스 Provider.
final cashDeviceServiceProvider = Provider<CashDeviceService>((ref) {
  final proxy = ref.watch(deviceControllerProxyProvider);
  return IpcCashService(proxy);
});

/// 프린터 서비스 Provider.
final printerServiceProvider = Provider<PrinterService>((ref) {
  final proxy = ref.watch(deviceControllerProxyProvider);
  return IpcPrinterService(proxy);
});
