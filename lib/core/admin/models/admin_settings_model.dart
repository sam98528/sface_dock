// lib/models/admin_settings_model.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Admin 설정 모델 (Flutter 쪽 영구 저장 항목).
/// 하드웨어(프린터/결제 COM 등)는 서비스 get_config/set_config로 별도 관리.
class AdminSettings {
  AdminSettings({
    // 하드웨어 (UI 표시용, 일부는 서비스와 동기화)
    this.cameraModel = '',
    this.printerModel = '프린터 모델 (미연동)',
    this.printerPaperSize = '4x6',
    this.printerPaperRemaining = 980,
    this.printerMarginH = 0,
    this.printerMarginV = 0,
    this.paymentTerminalComIndex = 0,
    this.paymentTerminalEnabled = true,
    this.cashDeviceComIndex = 0,
    this.cashDeviceEnabled = false,
    // 촬영
    this.mirrorEnabled = false,
    this.countdownEnabled = true,
    this.countdownSec = 10,
    this.shotCount = 8,
    this.delayBetweenShots = 500,
    this.remoteEnabled = false,
    this.remoteCountdownSec = 10,
    // 필터
    this.colorFilterNames = const ['없음'],
    // 화면/시간
    this.introClipSec = 30,
    this.introGuide = '안녕하세요. 사진을 촬영해 보세요.',
    Map<String, ({int timeout, String guide})>? timeoutsAndGuides,
    // 기타
    this.backupPath = '',
    this.localeIndex = 0,
    bool debugDisablePhaseTimers = false,

    /// 디버그용: true면 결제/생성 등 백엔드 API 호출 없이 다음 단계로 진행
    bool debugSkipBackendApi = false,

    /// 디버그용: true면 카메라 자동 촬영을 멈추고 수동 촬영만 가능하게 함
    bool debugPausePhotoCapture = false,

    /// 디버그용: true면 장비 연결 여부 확인 스킵 (UI 디버깅용)
    bool debugSkipDeviceConnection = false,

    /// 인쇄 대기 시간(초). 프린터 장당 약 20초 기준. Admin에서 조절 가능.
    this.printWaitDurationSeconds = 20,
    // 테마 (저장은 value 저장)
    this.themeBackgroundValue = 0xFFF5F5F5,
    this.themeKeyColorValue = 0xFF2196F3,
    this.themeTextColorValue = 0xFF212121,
    this.themeButtonBgValue = 0xFF2196F3,
    this.themeButtonTextValue = 0xFFFFFFFF,
    this.bgmVolume = 0.5,
  }) : _debugDisablePhaseTimers = debugDisablePhaseTimers,
       _debugSkipBackendApi = debugSkipBackendApi,
       _debugPausePhotoCapture = debugPausePhotoCapture,
       _debugSkipDeviceConnection = debugSkipDeviceConnection,
       timeoutsAndGuides = timeoutsAndGuides ?? _defaultTimeoutsAndGuides;

  static const int _defaultTimeout = 30;
  static const String _defaultGuide = '선택해 주세요.';
  static Map<String, ({int timeout, String guide})>
  get _defaultTimeoutsAndGuides => {
    '용지 선택화면': (timeout: _defaultTimeout, guide: _defaultGuide),
    '레이아웃 선택': (timeout: _defaultTimeout, guide: _defaultGuide),
    '수량 선택': (timeout: _defaultTimeout, guide: _defaultGuide),
    'AI 템플릿 선택': (timeout: _defaultTimeout, guide: _defaultGuide),
    '촬영 방식 선택': (timeout: _defaultTimeout, guide: _defaultGuide),
    '결제 방식 선택': (timeout: _defaultTimeout, guide: _defaultGuide),
    '결제': (timeout: _defaultTimeout, guide: _defaultGuide),
    // 라이브뷰: 촬영 설정(countdown+delay)×매수로 유효 시간 결정 → 별도 phase 타이머 없음
    '사진선택': (timeout: _defaultTimeout, guide: _defaultGuide),
    '사진 배치': (timeout: _defaultTimeout, guide: _defaultGuide),
    '필터': (timeout: _defaultTimeout, guide: _defaultGuide),
    '꾸미기': (timeout: _defaultTimeout, guide: _defaultGuide),
    '인화중': (timeout: _defaultTimeout, guide: _defaultGuide),
    '타임아웃 확인 모달': (timeout: 15, guide: '추가 행동을 하지 않을 경우 처음 화면으로 돌아갑니다.'),
  };

  final String cameraModel;
  final String printerModel;

  /// 용지 크기: 'A4' 또는 '4x6' (서비스 config printer.paper_size와 동기화)
  final String printerPaperSize;
  final int printerPaperRemaining;
  final int printerMarginH;
  final int printerMarginV;
  final int paymentTerminalComIndex;
  final bool paymentTerminalEnabled;
  final int cashDeviceComIndex;
  final bool cashDeviceEnabled;
  final bool mirrorEnabled;
  final bool countdownEnabled;
  final int countdownSec;
  final int shotCount;
  final int delayBetweenShots;
  final bool remoteEnabled;
  final int remoteCountdownSec;
  final List<String> colorFilterNames;
  final int introClipSec;
  final String introGuide;
  final Map<String, ({int timeout, String guide})> timeoutsAndGuides;
  final String backupPath;
  final int localeIndex;

  /// 디버그 모드에서만 노출. true면 phase 타이머 전부 비활성화 (카메라 촬영 타이머 제외).
  final bool _debugDisablePhaseTimers;

  /// 디버그용. true면 세션 중 결제/생성 등 백엔드 API 호출 스킵하고 다음 단계로만 진행.
  final bool _debugSkipBackendApi;

  /// 디버그용. true면 사진 자동 촬영을 멈춤.
  final bool _debugPausePhotoCapture;

  /// 디버그용. true면 장비 연결 여부 확인 스킵 (UI 디버깅용).
  final bool _debugSkipDeviceConnection;

  bool get debugDisablePhaseTimers => kDebugMode && _debugDisablePhaseTimers;
  bool get debugSkipBackendApi => kDebugMode && _debugSkipBackendApi;
  bool get debugPausePhotoCapture => kDebugMode && _debugPausePhotoCapture;
  bool get debugSkipDeviceConnection =>
      kDebugMode && _debugSkipDeviceConnection;

  /// 테스트용 인쇄 대기 시간(초). 확정 후 실제 코드에 반영할 때 사용.
  final int printWaitDurationSeconds;
  final int themeBackgroundValue;
  final int themeKeyColorValue;
  final int themeTextColorValue;
  final int themeButtonBgValue;
  final int themeButtonTextValue;
  final double bgmVolume;

  Color get themeBackground => Color(themeBackgroundValue);
  Color get themeKeyColor => Color(themeKeyColorValue);
  Color get themeTextColor => Color(themeTextColorValue);
  Color get themeButtonBg => Color(themeButtonBgValue);
  Color get themeButtonText => Color(themeButtonTextValue);

  AdminSettings copyWith({
    String? cameraModel,
    String? printerModel,
    String? printerPaperSize,
    int? printerPaperRemaining,
    int? printerMarginH,
    int? printerMarginV,
    int? paymentTerminalComIndex,
    bool? paymentTerminalEnabled,
    int? cashDeviceComIndex,
    bool? cashDeviceEnabled,
    bool? mirrorEnabled,
    bool? countdownEnabled,
    int? countdownSec,
    int? shotCount,
    int? delayBetweenShots,
    bool? remoteEnabled,
    int? remoteCountdownSec,
    List<String>? colorFilterNames,
    int? introClipSec,
    String? introGuide,
    Map<String, ({int timeout, String guide})>? timeoutsAndGuides,
    String? backupPath,
    int? localeIndex,
    bool? debugDisablePhaseTimers,
    bool? debugSkipBackendApi,
    bool? debugPausePhotoCapture,
    bool? debugSkipDeviceConnection,
    int? printWaitDurationSeconds,
    int? themeBackgroundValue,
    int? themeKeyColorValue,
    int? themeTextColorValue,
    int? themeButtonBgValue,
    int? themeButtonTextValue,
    double? bgmVolume,
  }) {
    return AdminSettings(
      cameraModel: cameraModel ?? this.cameraModel,
      printerModel: printerModel ?? this.printerModel,
      printerPaperSize: printerPaperSize ?? this.printerPaperSize,
      printerPaperRemaining:
          printerPaperRemaining ?? this.printerPaperRemaining,
      printerMarginH: printerMarginH ?? this.printerMarginH,
      printerMarginV: printerMarginV ?? this.printerMarginV,
      paymentTerminalComIndex:
          paymentTerminalComIndex ?? this.paymentTerminalComIndex,
      paymentTerminalEnabled:
          paymentTerminalEnabled ?? this.paymentTerminalEnabled,
      cashDeviceComIndex: cashDeviceComIndex ?? this.cashDeviceComIndex,
      cashDeviceEnabled: cashDeviceEnabled ?? this.cashDeviceEnabled,
      mirrorEnabled: mirrorEnabled ?? this.mirrorEnabled,
      countdownEnabled: countdownEnabled ?? this.countdownEnabled,
      countdownSec: countdownSec ?? this.countdownSec,
      shotCount: shotCount ?? this.shotCount,
      delayBetweenShots: delayBetweenShots ?? this.delayBetweenShots,
      remoteEnabled: remoteEnabled ?? this.remoteEnabled,
      remoteCountdownSec: remoteCountdownSec ?? this.remoteCountdownSec,
      colorFilterNames: colorFilterNames ?? this.colorFilterNames,
      introClipSec: introClipSec ?? this.introClipSec,
      introGuide: introGuide ?? this.introGuide,
      timeoutsAndGuides: timeoutsAndGuides ?? this.timeoutsAndGuides,
      backupPath: backupPath ?? this.backupPath,
      localeIndex: localeIndex ?? this.localeIndex,
      debugDisablePhaseTimers:
          debugDisablePhaseTimers ?? _debugDisablePhaseTimers,
      debugSkipBackendApi: debugSkipBackendApi ?? _debugSkipBackendApi,
      debugPausePhotoCapture: debugPausePhotoCapture ?? _debugPausePhotoCapture,
      debugSkipDeviceConnection:
          debugSkipDeviceConnection ?? _debugSkipDeviceConnection,
      printWaitDurationSeconds:
          printWaitDurationSeconds ?? this.printWaitDurationSeconds,
      themeBackgroundValue: themeBackgroundValue ?? this.themeBackgroundValue,
      themeKeyColorValue: themeKeyColorValue ?? this.themeKeyColorValue,
      themeTextColorValue: themeTextColorValue ?? this.themeTextColorValue,
      themeButtonBgValue: themeButtonBgValue ?? this.themeButtonBgValue,
      themeButtonTextValue: themeButtonTextValue ?? this.themeButtonTextValue,
      bgmVolume: bgmVolume ?? this.bgmVolume,
    );
  }

  Map<String, dynamic> toJson() {
    final timeoutsJson = <String, Map<String, dynamic>>{};
    for (final e in timeoutsAndGuides.entries) {
      timeoutsJson[e.key] = {
        'timeout': e.value.timeout,
        'guide': e.value.guide,
      };
    }
    return {
      'cameraModel': cameraModel,
      'printerModel': printerModel,
      'printerPaperSize': printerPaperSize,
      'printerPaperRemaining': printerPaperRemaining,
      'printerMarginH': printerMarginH,
      'printerMarginV': printerMarginV,
      'paymentTerminalComIndex': paymentTerminalComIndex,
      'paymentTerminalEnabled': paymentTerminalEnabled,
      'cashDeviceComIndex': cashDeviceComIndex,
      'cashDeviceEnabled': cashDeviceEnabled,
      'mirrorEnabled': mirrorEnabled,
      'countdownEnabled': countdownEnabled,
      'countdownSec': countdownSec,
      'shotCount': shotCount,
      'delayBetweenShots': delayBetweenShots,
      'remoteEnabled': remoteEnabled,
      'remoteCountdownSec': remoteCountdownSec,
      'colorFilterNames': colorFilterNames,
      'introClipSec': introClipSec,
      'introGuide': introGuide,
      'timeoutsAndGuides': timeoutsJson,
      'backupPath': backupPath,
      'localeIndex': localeIndex,
      'debugDisablePhaseTimers': _debugDisablePhaseTimers,
      'debugSkipBackendApi': _debugSkipBackendApi,
      'debugPausePhotoCapture': _debugPausePhotoCapture,
      'debugSkipDeviceConnection': _debugSkipDeviceConnection,
      'printWaitDurationSeconds': printWaitDurationSeconds,
      'themeBackgroundValue': themeBackgroundValue,
      'themeKeyColorValue': themeKeyColorValue,
      'themeTextColorValue': themeTextColorValue,
      'themeButtonBgValue': themeButtonBgValue,
      'themeButtonTextValue': themeButtonTextValue,
      'bgmVolume': bgmVolume,
    };
  }

  static AdminSettings fromJson(Map<String, dynamic> json) {
    Map<String, ({int timeout, String guide})> timeouts =
        _defaultTimeoutsAndGuides;
    final raw = json['timeoutsAndGuides'];
    if (raw is Map<String, dynamic>) {
      timeouts = {};
      for (final e in raw.entries) {
        final v = e.value;
        if (v is Map) {
          timeouts[e.key] = (
            timeout: (v['timeout'] as num?)?.toInt() ?? _defaultTimeout,
            guide: (v['guide'] as String?) ?? _defaultGuide,
          );
        }
      }
      // 기본 키 중 저장에 없던 항목 보충 (예: 타임아웃 확인 모달)
      for (final e in _defaultTimeoutsAndGuides.entries) {
        timeouts.putIfAbsent(e.key, () => e.value);
      }
    }
    return AdminSettings(
      cameraModel: json['cameraModel'] as String? ?? '',
      printerModel: json['printerModel'] as String? ?? '프린터 모델 (미연동)',
      printerPaperSize: json['printerPaperSize'] as String? ?? '4x6',
      printerPaperRemaining:
          (json['printerPaperRemaining'] as num?)?.toInt() ?? 980,
      printerMarginH: (json['printerMarginH'] as num?)?.toInt() ?? 0,
      printerMarginV: (json['printerMarginV'] as num?)?.toInt() ?? 0,
      paymentTerminalComIndex:
          (json['paymentTerminalComIndex'] as num?)?.toInt() ?? 0,
      paymentTerminalEnabled: json['paymentTerminalEnabled'] as bool? ?? true,
      cashDeviceComIndex: (json['cashDeviceComIndex'] as num?)?.toInt() ?? 0,
      cashDeviceEnabled: json['cashDeviceEnabled'] as bool? ?? false,
      mirrorEnabled: json['mirrorEnabled'] as bool? ?? false,
      countdownEnabled: json['countdownEnabled'] as bool? ?? true,
      countdownSec: (json['countdownSec'] as num?)?.toInt() ?? 10,
      shotCount: (json['shotCount'] as num?)?.toInt() ?? 8,
      delayBetweenShots: (json['delayBetweenShots'] as num?)?.toInt() ?? 500,
      remoteEnabled: json['remoteEnabled'] as bool? ?? false,
      remoteCountdownSec: (json['remoteCountdownSec'] as num?)?.toInt() ?? 10,
      colorFilterNames:
          (json['colorFilterNames'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['colorFilterName'] != null
              ? [json['colorFilterName'].toString()]
              : ['없음']),
      introClipSec: (json['introClipSec'] as num?)?.toInt() ?? 30,
      introGuide: json['introGuide'] as String? ?? '안녕하세요. 사진을 촬영해 보세요.',
      timeoutsAndGuides: timeouts,
      backupPath: json['backupPath'] as String? ?? '',
      localeIndex: (json['localeIndex'] as num?)?.toInt() ?? 0,
      debugDisablePhaseTimers:
          json['debugDisablePhaseTimers'] as bool? ?? false,
      debugSkipBackendApi: json['debugSkipBackendApi'] as bool? ?? false,
      debugPausePhotoCapture: json['debugPausePhotoCapture'] as bool? ?? false,
      debugSkipDeviceConnection:
          json['debugSkipDeviceConnection'] as bool? ?? false,
      printWaitDurationSeconds:
          (json['printWaitDurationSeconds'] as num?)?.toInt() ?? 20,
      themeBackgroundValue:
          (json['themeBackgroundValue'] as num?)?.toInt() ?? 0xFFF5F5F5,
      themeKeyColorValue:
          (json['themeKeyColorValue'] as num?)?.toInt() ?? 0xFF2196F3,
      themeTextColorValue:
          (json['themeTextColorValue'] as num?)?.toInt() ?? 0xFF212121,
      themeButtonBgValue:
          (json['themeButtonBgValue'] as num?)?.toInt() ?? 0xFF2196F3,
      themeButtonTextValue:
          (json['themeButtonTextValue'] as num?)?.toInt() ?? 0xFFFFFFFF,
      bgmVolume: (json['bgmVolume'] as num?)?.toDouble() ?? 0.5,
    );
  }
}
