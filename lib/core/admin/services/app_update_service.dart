// lib/core/admin/services/app_update_service.dart
//
// App update service for kiosk app

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../session/services/kiosk_backend_api.dart';

/// App version information
class AppVersionInfo {
  final String version;
  final String downloadUrl;
  final String releaseNotes;
  final bool forceUpdate;

  AppVersionInfo({
    required this.version,
    required this.downloadUrl,
    required this.releaseNotes,
    this.forceUpdate = false,
  });

  factory AppVersionInfo.fromJson(Map<String, dynamic> json) {
    return AppVersionInfo(
      version: json['version'] as String? ?? '0.0.0',
      downloadUrl: json['download_url'] as String? ?? '',
      releaseNotes: json['release_notes'] as String? ?? '',
      forceUpdate: json['force_update'] as bool? ?? false,
    );
  }
}

/// Update check result
class UpdateCheckResult {
  final bool updateAvailable;
  final AppVersionInfo? versionInfo;
  final String? error;

  UpdateCheckResult({
    required this.updateAvailable,
    this.versionInfo,
    this.error,
  });
}

/// App update service
class AppUpdateService {
  final KioskBackendApi _api;

  AppUpdateService(this._api);

  /// Check for updates
  Future<UpdateCheckResult> checkForUpdates(String currentVersion) async {
    try {
      final response = await _api.dio.get('/api/app/version/latest');
      final data = response.data as Map<String, dynamic>?;

      if (data == null) {
        return UpdateCheckResult(
          updateAvailable: false,
          error: 'Invalid response from server',
        );
      }

      final versionInfo = AppVersionInfo.fromJson(data);
      final updateAvailable = _compareVersions(
        currentVersion,
        versionInfo.version,
      );

      return UpdateCheckResult(
        updateAvailable: updateAvailable,
        versionInfo: versionInfo,
      );
    } on DioException catch (e) {
      debugPrint('Update check failed: ${e.message}');
      return UpdateCheckResult(
        updateAvailable: false,
        error: e.message,
      );
    } catch (e) {
      debugPrint('Update check error: $e');
      return UpdateCheckResult(
        updateAvailable: false,
        error: e.toString(),
      );
    }
  }

  /// Compare version strings (returns true if server version is newer)
  bool _compareVersions(String current, String server) {
    final currentParts = current.split('.').map(int.tryParse).toList();
    final serverParts = server.split('.').map(int.tryParse).toList();

    for (int i = 0; i < 3; i++) {
      final c = i < currentParts.length ? (currentParts[i] ?? 0) : 0;
      final s = i < serverParts.length ? (serverParts[i] ?? 0) : 0;

      if (s > c) return true;
      if (s < c) return false;
    }

    return false; // Versions are equal
  }

  /// Download and install update (placeholder - implement platform-specific logic)
  Future<void> downloadAndInstall(
    String downloadUrl,
    void Function(double progress) onProgress,
  ) async {
    // TODO: Implement download and installation logic
    // This is platform-specific:
    // - Windows: Download .exe, run installer
    // - Android: Download .apk, trigger installation
    // - iOS: Redirect to App Store

    debugPrint('Download update from: $downloadUrl');
    throw UnimplementedError('Update download not yet implemented');
  }
}
