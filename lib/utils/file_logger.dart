// lib/utils/file_logger.dart
//
// 파일 기반 로거: Documents/aiKiosk/logs/ 에 날짜별 로그 파일 생성.
// 실제 기기에서 debugPrint 대신 사용하여 설치된 앱의 로그를 파일로 확인 가능.

import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:path_provider/path_provider.dart';

class FileLogger {
  FileLogger._();
  static final FileLogger instance = FileLogger._();

  File? _logFile;
  File? _errorFile;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final docs = await getApplicationDocumentsDirectory();
      final logDir = Directory(
        '${docs.path}${Platform.pathSeparator}sfaceDock${Platform.pathSeparator}logs',
      );
      if (!logDir.existsSync()) {
        logDir.createSync(recursive: true);
      }
      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      _logFile = File(
        '${logDir.path}${Platform.pathSeparator}app_$dateStr.log',
      );
      _errorFile = File(
        '${logDir.path}${Platform.pathSeparator}error_summary.log',
      );
      _initialized = true;
      info('FileLogger initialized: ${_logFile!.path}');
    } catch (e) {
      debugPrint('[FileLogger] init error: $e');
    }
  }

  void _write(String level, String message) {
    final now = DateTime.now();
    final ts =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
    final line = '[$ts] [$level] $message\n';
    debugPrint(line.trimRight());
    try {
      _logFile?.writeAsStringSync(line, mode: FileMode.append, flush: true);
    } catch (_) {}
    if (level == 'WARN' || level == 'ERROR') {
      try {
        _errorFile?.writeAsStringSync(line, mode: FileMode.append, flush: true);
      } catch (_) {}
    }
  }

  void logSessionMarker(String label) {
    final now = DateTime.now();
    final ts =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
    final marker = '[$ts] ========== $label ==========\n';
    debugPrint(marker.trimRight());
    try {
      _logFile?.writeAsStringSync(marker, mode: FileMode.append, flush: true);
    } catch (_) {}
    try {
      _errorFile?.writeAsStringSync(marker, mode: FileMode.append, flush: true);
    } catch (_) {}
  }

  void info(String message) => _write('INFO', message);
  void warn(String message) => _write('WARN', message);
  void error(String message) => _write('ERROR', message);
}

/// 편의 함수
void logInfo(String msg) => FileLogger.instance.info(msg);
void logWarn(String msg) => FileLogger.instance.warn(msg);
void logError(String msg) => FileLogger.instance.error(msg);
