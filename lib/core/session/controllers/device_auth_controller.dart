// lib/controllers/device_auth/device_auth_controller.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device_auth_models.dart';
import '../services/device_credential_storage.dart';
import '../services/kiosk_backend_api.dart';
import '../state/device_auth_state.dart';

/// DeviceAuthController - 기기 로그인/로그아웃, credential 저장·복구, 기기 정보 수정
class DeviceAuthController extends StateNotifier<DeviceAuthState> {
  DeviceAuthController(this._api, this._storage, [void Function(String)? onLog])
    : _onLog = onLog,
      super(const DeviceAuthState.initial());

  final KioskBackendApi _api;
  final DeviceCredentialStorage _storage;
  final void Function(String)? _onLog;

  /// Restore credential from storage on app start. Call once before verification.
  /// Sets state to loggedIn if valid credential exists, else leaves initial/notLoggedIn.
  Future<void> restoreFromStorage() async {
    final credential = await _storage.read();
    if (credential != null) {
      state = DeviceAuthState.loggedIn(
        devicePassword: credential.devicePassword,
        deviceId: credential.deviceId,
        deviceName: credential.deviceName,
      );
      debugPrint(
        'Device credential restored from storage: device_id=${credential.deviceId}',
      );
    }
  }

  /// Persist credential after successful login. Key is kept until admin changes it.
  Future<void> _persistCredential(StoredDeviceCredential credential) async {
    await _storage.save(credential);
  }

  /// Clear stored credential (logout or after 401 / admin key change).
  Future<void> clearCredentialStorage() async {
    await _storage.delete();
  }

  void logout() {
    state = const DeviceAuthState.notLoggedIn();
    clearCredentialStorage();
  }

  static Map<String, dynamic> _updateDeviceRequestToApiBody(
    UpdateDeviceRequest request,
  ) {
    final body = <String, dynamic>{};
    void setString(String key, String? v) {
      if (v != null && v.isNotEmpty) body[key] = v;
    }

    void setInt(String key, int? v) {
      if (v != null) body[key] = v;
    }

    void setBool(String key, bool? v) {
      if (v != null) body[key] = v;
    }

    setString('device_name', request.device_name);
    setString('software_type', request.software_type);
    setBool('is_active', request.is_active);
    setBool('allow_update', request.allow_update);
    setBool('disabled_select_filter', request.disabled_select_filter);
    setString('app_version', request.app_version);
    setString('before_app_version', request.before_app_version);
    setBool('is_tester', request.is_tester);
    setBool('allow_select_paper_type', request.allow_select_paper_type);
    setBool('enabled_basic_paper', request.enabled_basic_paper);
    setString('additional_paper_types', request.additional_paper_types);
    setInt('remotecon_type', request.remotecon_type);
    setString('camera_angle', request.camera_angle);
    setString('camera_model', request.camera_model);
    setString('camera_lens', request.camera_lens);
    setString('printer_model', request.printer_model);
    setInt('printer_lifecounter', request.printer_lifecounter);
    setString('printer_remaining', request.printer_remaining);
    setString('payment_methods', request.payment_methods);
    setString('cardreader_num', request.cardreader_num);
    setString('billacceptor_num', request.billacceptor_num);
    setString('print_types', request.print_types);
    setString('photo_types', request.photo_types);
    setString('liveview_modes', request.liveview_modes);
    setString('note', request.note);
    setBool('print_greyscale_additional', request.print_greyscale_additional);
    setBool('fix_print_quantity', request.fix_print_quantity);
    setInt('winning_probability', request.winning_probability);
    setInt('liveview_timer_countDown', request.liveview_timer_countDown);
    setInt('liveview_timer_remote', request.liveview_timer_remote);
    setInt('liveview_timer_remote_cont', request.liveview_timer_remote_cont);
    setString('send_userphotos_methods', request.send_userphotos_methods);
    setBool('is_offline_mode', request.is_offline_mode);
    setString('is_verified', request.is_verified);
    return body;
  }

  static String _dioErrorMessage(DioException e) {
    final response = e.response;
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      final msg = data['message'] as String? ?? data['error'] as String?;
      if (msg != null && msg.isNotEmpty) return msg;
    }
    if (response?.statusCode != null) {
      return 'HTTP ${response!.statusCode}';
    }
    return e.message ?? e.type.toString();
  }
}

final kioskBackendApiProvider = Provider<KioskBackendApi>((ref) {
  final baseUrl = dotenv.env['BACKEND_URL']?.trim() ?? 'http://localhost:3000';
  return KioskBackendApi(baseUrl: baseUrl);
});

final deviceCredentialStorageProvider = Provider<DeviceCredentialStorage>((
  ref,
) {
  return DeviceCredentialStorage();
});

final deviceAuthControllerProvider =
    StateNotifierProvider<DeviceAuthController, DeviceAuthState>((ref) {
      final api = ref.watch(kioskBackendApiProvider);
      final storage = ref.watch(deviceCredentialStorageProvider);
      // Optional: Add logging callback if you have a logging provider
      return DeviceAuthController(api, storage);
    });
