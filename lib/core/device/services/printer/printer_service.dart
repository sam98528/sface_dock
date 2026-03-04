// lib/services/devices/printer/printer_service.dart
//
// 프린터 디바이스 추상 인터페이스.

/// 프린터 서비스 인터페이스.
abstract class PrinterService {
  /// 인쇄 요청. [filePath] 또는 [dataBase64] 중 하나 필수.
  /// [orientation]: 'portrait' 또는 'landscape'. 생략 시 portrait.
  Future<Map<String, dynamic>?> print({
    required String jobId,
    String? filePath,
    String? dataBase64,
    String? orientation,
  });

  /// 사용 가능한 프린터 목록.
  Future<List<String>> getAvailablePrinters();
}
