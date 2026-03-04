// lib/controllers/admin/admin_controller.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_settings_model.dart';
import '../services/admin_settings_storage.dart';

/// Admin 설정 상태 관리. 로컬 저장소에 영구 저장.
/// 하드웨어 설정은 getConfig/setConfig(IPC)와 동기화(연동은 DeviceControllerProxy 확장 후).
class AdminController extends StateNotifier<AdminSettings> {
  AdminController(this._storage) : super(AdminSettings()) {
    _load();
  }

  final AdminSettingsStorage _storage;

  Future<void> _load() async {
    try {
      final loaded = await _storage.load();
      state = loaded;
    } catch (e, st) {
      debugPrint('AdminController._load error: $e\n$st');
    }
  }

  Future<void> _save() async {
    await _storage.save(state);
  }

  void updateSettings(AdminSettings Function(AdminSettings) fn) {
    state = fn(state);
    _save();
  }

  /// 드래프트를 적용·저장 (설정 저장 버튼용). 저장 후 호출 측에서 테마/로케일 적용·버전 증가.
  Future<void> applyDraft(AdminSettings draft) async {
    state = draft;
    await _save();
  }

  // 하드웨어 (로컬 state + 추후 setConfig 연동)
  void setPrinterModel(String v) =>
      updateSettings((s) => s.copyWith(printerModel: v));
  void setPrinterPaperRemaining(int v) =>
      updateSettings((s) => s.copyWith(printerPaperRemaining: v));
  void setPrinterMarginH(int v) =>
      updateSettings((s) => s.copyWith(printerMarginH: v));
  void setPrinterMarginV(int v) =>
      updateSettings((s) => s.copyWith(printerMarginV: v));
  void setPaymentTerminalComIndex(int v) =>
      updateSettings((s) => s.copyWith(paymentTerminalComIndex: v));
  void setPaymentTerminalEnabled(bool v) =>
      updateSettings((s) => s.copyWith(paymentTerminalEnabled: v));
  void setCashDeviceComIndex(int v) =>
      updateSettings((s) => s.copyWith(cashDeviceComIndex: v));
  void setCashDeviceEnabled(bool v) =>
      updateSettings((s) => s.copyWith(cashDeviceEnabled: v));
  void setCameraModel(String v) =>
      updateSettings((s) => s.copyWith(cameraModel: v));

  // 기능
  void setMirrorEnabled(bool v) =>
      updateSettings((s) => s.copyWith(mirrorEnabled: v));
  void setCountdownEnabled(bool v) =>
      updateSettings((s) => s.copyWith(countdownEnabled: v));
  void setCountdownSec(int v) =>
      updateSettings((s) => s.copyWith(countdownSec: v));
  void setShotCount(int v) => updateSettings((s) => s.copyWith(shotCount: v));
  void setDelayBetweenShots(int v) =>
      updateSettings((s) => s.copyWith(delayBetweenShots: v));
  void setRemoteEnabled(bool v) =>
      updateSettings((s) => s.copyWith(remoteEnabled: v));
  void setRemoteCountdownSec(int v) =>
      updateSettings((s) => s.copyWith(remoteCountdownSec: v));
  void setColorFilterNames(List<String> v) =>
      updateSettings((s) => s.copyWith(colorFilterNames: v));
  void setIntroClipSec(int v) =>
      updateSettings((s) => s.copyWith(introClipSec: v));
  void setIntroGuide(String v) =>
      updateSettings((s) => s.copyWith(introGuide: v));
  void setTimeoutAndGuide(String key, int? timeout, String? guide) {
    final cur = state.timeoutsAndGuides[key];
    if (cur == null) return;
    final newMap = Map<String, ({int timeout, String guide})>.from(
      state.timeoutsAndGuides,
    );
    newMap[key] = (timeout: timeout ?? cur.timeout, guide: guide ?? cur.guide);
    updateSettings((s) => s.copyWith(timeoutsAndGuides: newMap));
  }

  void setBackupPath(String v) =>
      updateSettings((s) => s.copyWith(backupPath: v));
  void setLocaleIndex(int v) =>
      updateSettings((s) => s.copyWith(localeIndex: v));
  void setDebugDisablePhaseTimers(bool v) =>
      updateSettings((s) => s.copyWith(debugDisablePhaseTimers: v));
  void setDebugSkipBackendApi(bool v) =>
      updateSettings((s) => s.copyWith(debugSkipBackendApi: v));
  void setDebugPausePhotoCapture(bool v) =>
      updateSettings((s) => s.copyWith(debugPausePhotoCapture: v));
  void setPrintWaitDurationSeconds(int v) =>
      updateSettings((s) => s.copyWith(printWaitDurationSeconds: v));
  void setThemeBackgroundValue(int v) =>
      updateSettings((s) => s.copyWith(themeBackgroundValue: v));
  void setThemeKeyColorValue(int v) =>
      updateSettings((s) => s.copyWith(themeKeyColorValue: v));
  void setThemeTextColorValue(int v) =>
      updateSettings((s) => s.copyWith(themeTextColorValue: v));
  void setThemeButtonBgValue(int v) =>
      updateSettings((s) => s.copyWith(themeButtonBgValue: v));
  void setThemeButtonTextValue(int v) =>
      updateSettings((s) => s.copyWith(themeButtonTextValue: v));
  void setBgmVolume(double v) =>
      updateSettings((s) => s.copyWith(bgmVolume: v));

  /// 저장소에서 다시 로드 (예: Admin 진입 시)
  Future<void> reload() async {
    await _load();
  }
}

final adminControllerProvider =
    StateNotifierProvider<AdminController, AdminSettings>((ref) {
      return AdminController(AdminSettingsStorage.instance);
    });

/// 관리자 화면에서 편집 중인 드래프트. 적용 전까지 앱에는 반영되지 않음.
class AdminDraftState {
  const AdminDraftState({required this.draft, this.dirty = false});
  final AdminSettings draft;
  final bool dirty;
}

/// Admin 드래프트 상태. 수정 시 dirty=true, "설정 저장" 시 apply 후 dirty=false.
class AdminDraftNotifier extends StateNotifier<AdminDraftState> {
  AdminDraftNotifier(this._ref)
    : super(
        AdminDraftState(
          draft: _ref.read(adminControllerProvider),
          dirty: false,
        ),
      );

  final Ref _ref;

  void syncFromApplied() {
    state = AdminDraftState(
      draft: _ref.read(adminControllerProvider),
      dirty: false,
    );
  }

  void updateDraft(AdminSettings Function(AdminSettings) fn) {
    state = AdminDraftState(draft: fn(state.draft), dirty: true);
  }

  /// 드래프트를 적용·저장. 호출 후 호출 측에서 테마/로케일 적용·adminThemeVersionProvider 증가.
  Future<void> apply() async {
    await _ref.read(adminControllerProvider.notifier).applyDraft(state.draft);
    state = AdminDraftState(draft: state.draft, dirty: false);
  }
}

final adminDraftProvider =
    StateNotifierProvider<AdminDraftNotifier, AdminDraftState>((ref) {
      return AdminDraftNotifier(ref);
    });

/// 테마/로케일 적용 시 앱 리빌드용. Admin에서 setThemeFromAdmin 후 ++ 하면 MaterialApp이 다시 build.
final adminThemeVersionProvider = StateProvider<int>((ref) => 0);

/// 점검중 화면 표시 여부. Admin 시스템 탭에서 "점검중 표시" 시 true.
final maintenanceModeProvider = StateProvider<bool>((ref) => false);
