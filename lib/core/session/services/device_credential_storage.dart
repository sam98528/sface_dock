// lib/core/session/services/device_credential_storage.dart

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stored device credential (device_password, device_id, device_name).
/// Persisted locally until key is changed (e.g. admin regenerates password).
class StoredDeviceCredential {
  const StoredDeviceCredential({
    required this.devicePassword,
    this.deviceId,
    this.deviceName,
  });

  final String devicePassword;
  final String? deviceId;
  final String? deviceName;

  Map<String, dynamic> toJson() => {
        'device_password': devicePassword,
        'device_id': deviceId,
        'device_name': deviceName,
      };

  static StoredDeviceCredential? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final p = json['device_password']?.toString().trim();
    if (p == null || p.isEmpty) return null;
    return StoredDeviceCredential(
      devicePassword: p,
      deviceId: json['device_id']?.toString(),
      deviceName: json['device_name']?.toString(),
    );
  }
}

/// Persists device credential to secure storage. Used for restore on app start
/// and clear when admin changes key or user logs out.
class DeviceCredentialStorage {
  DeviceCredentialStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  static const String _key = 'device_credential';
  final FlutterSecureStorage _storage;

  /// Reads stored credential. Returns null if not found or invalid.
  Future<StoredDeviceCredential?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null || raw.isEmpty) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>?;
      return StoredDeviceCredential.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Saves credential after successful login.
  Future<void> save(StoredDeviceCredential credential) async {
    await _storage.write(
      key: _key,
      value: jsonEncode(credential.toJson()),
    );
  }

  /// Removes stored credential (logout or after 401 / admin key change).
  Future<void> delete() async {
    await _storage.delete(key: _key);
  }
}
