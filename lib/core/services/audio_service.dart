import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 효과음 종류.
enum SfxType { tap, keyboard }

/// 키오스크 오디오 서비스 — 효과음(SFX) + 배경음악(BGM).
///
/// 사운드 파일이 없어도 에러 없이 동작 (방어 처리).
class KioskAudioService {
  AudioPlayer? _tapPlayer;
  AudioPlayer? _keyboardPlayer;
  AudioPlayer? _bgmPlayer;

  static const _tapSfxPath = 'sounds/effects/tap.wav';
  static const _keyboardSfxPath = 'sounds/effects/keyboard.wav';
  static const _bgmPath = 'sounds/background/bgm.mp3';

  bool _initialized = false;
  double _bgmVolume = 0.5;

  /// AudioPlayer 인스턴스 생성.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      _tapPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
      _keyboardPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
      _bgmPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      debugPrint('[KioskAudioService] init error: $e');
    }
  }

  /// 효과음 재생 (fire-and-forget).
  void playSfx(SfxType type) {
    try {
      final player = switch (type) {
        SfxType.tap => _tapPlayer,
        SfxType.keyboard => _keyboardPlayer,
      };
      if (player == null) return;

      final path = switch (type) {
        SfxType.tap => _tapSfxPath,
        SfxType.keyboard => _keyboardSfxPath,
      };

      player.stop();
      player.play(AssetSource(path), volume: 1.0);
    } catch (_) {
      // 파일 없거나 재생 실패 — 무시
    }
  }

  /// BGM 루프 시작.
  Future<void> startBgm() async {
    try {
      if (_bgmPlayer == null) return;
      await _bgmPlayer!.setVolume(_bgmVolume);
      await _bgmPlayer!.play(AssetSource(_bgmPath));
    } catch (_) {
      // 파일 없으면 무시
    }
  }

  /// BGM 정지.
  Future<void> stopBgm() async {
    try {
      await _bgmPlayer?.stop();
    } catch (_) {}
  }

  /// BGM 볼륨 설정 (0.0~1.0).
  void setBgmVolume(double v) {
    _bgmVolume = v.clamp(0.0, 1.0);
    try {
      _bgmPlayer?.setVolume(_bgmVolume);
    } catch (_) {}
  }

  /// 리소스 해제.
  void dispose() {
    _tapPlayer?.dispose();
    _keyboardPlayer?.dispose();
    _bgmPlayer?.dispose();
    _tapPlayer = null;
    _keyboardPlayer = null;
    _bgmPlayer = null;
    _initialized = false;
  }
}

/// Riverpod provider.
final kioskAudioServiceProvider = Provider<KioskAudioService>((ref) {
  final service = KioskAudioService();
  service.init();
  ref.onDispose(() => service.dispose());
  return service;
});

/// BuildContext extension for easy tap sound access.
extension KioskSfxContext on BuildContext {
  void playTapSound() {
    try {
      ProviderScope.containerOf(this)
          .read(kioskAudioServiceProvider)
          .playSfx(SfxType.tap);
    } catch (_) {}
  }

  void playKeyboardSound() {
    try {
      ProviderScope.containerOf(this)
          .read(kioskAudioServiceProvider)
          .playSfx(SfxType.keyboard);
    } catch (_) {}
  }
}
