// lib/services/devices/printer/ipc_printer_service.dart
//
// IPC 기반 프린터 서비스 구현체.

import '../../device_controller_proxy.dart';
import 'printer_service.dart';

/// IPC(Named Pipe)를 통한 프린터 서비스 구현.
class IpcPrinterService implements PrinterService {
  IpcPrinterService(this._proxy);

  final DeviceControllerProxy _proxy;

  @override
  Future<Map<String, dynamic>?> print({
    required String jobId,
    String? filePath,
    String? dataBase64,
    String? orientation,
  }) {
    return _proxy.printerPrint(
      jobId: jobId,
      filePath: filePath,
      dataBase64: dataBase64,
      orientation: orientation,
    );
  }

  @override
  Future<List<String>> getAvailablePrinters() {
    return _proxy.getAvailablePrinters();
  }
}
