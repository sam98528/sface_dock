// lib/services/admin_settings_storage.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/admin_settings_model.dart';

const String _fileName = 'kiosk_admin_settings.json';

/// Admin 설정 영구 저장 (Flutter 쪽 항목만).
/// path_provider + JSON 파일 사용.
class AdminSettingsStorage {
  AdminSettingsStorage._();
  static final AdminSettingsStorage _instance = AdminSettingsStorage._();
  static AdminSettingsStorage get instance => _instance;

  String? _path;

  Future<String> _getFilePath() async {
    if (_path != null) return _path!;
    final dir = await getApplicationSupportDirectory();
    _path = '${dir.path}/$_fileName';
    return _path!;
  }

  /// 저장소에서 설정 로드. 실패 시 기본값 반환.
  Future<AdminSettings> load() async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      if (!await file.exists()) {
        return AdminSettings();
      }
      final contents = await file.readAsString();
      final json = jsonDecode(contents) as Map<String, dynamic>;
      return AdminSettings.fromJson(json);
    } catch (e, st) {
      debugPrint('AdminSettingsStorage.load error: $e\n$st');
      return AdminSettings();
    }
  }

  /// 설정 저장. 실패 시 로그만.
  Future<void> save(AdminSettings settings) async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(settings.toJson()),
        flush: true,
      );
    } catch (e, st) {
      debugPrint('AdminSettingsStorage.save error: $e\n$st');
    }
  }
}
