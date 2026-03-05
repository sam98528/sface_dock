// lib/screens/admin/widgets/admin_system_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../theme/admin_theme.dart';
import 'admin_section_card.dart';

import 'admin_switch_field.dart';

/// 시스템 — 화면 제어, 앱 제어, 디버그 옵션.
class AdminSystemSection extends StatelessWidget {
  const AdminSystemSection({
    super.key,
    required this.onFirstScreen,
    required this.onMaintenanceScreen,
    required this.onVerificationCheck,
    this.onDeviceKeyChange,
    required this.onAppRestart,
    required this.onAppExit,
    required this.onAppUpdate,
    this.debugDisablePhaseTimers = false,
    this.onDebugDisablePhaseTimersChanged,
    this.debugSkipBackendApi = false,
    this.onDebugSkipBackendApiChanged,
    this.debugPausePhotoCapture = false,
    this.onDebugPausePhotoCaptureChanged,
    this.debugSkipDeviceConnection = false,
    this.onDebugSkipDeviceConnectionChanged,
    this.bgmVolume = 0.5,
    this.onBgmVolumeChanged,
  });

  final VoidCallback onFirstScreen;
  final VoidCallback onMaintenanceScreen;
  final VoidCallback onVerificationCheck;

  /// 기기 로그인 키 삭제 후 검증 화면으로 이동 (새 키 입력 유도)
  final VoidCallback? onDeviceKeyChange;
  final VoidCallback onAppRestart;
  final VoidCallback onAppExit;
  final VoidCallback onAppUpdate;
  final bool debugDisablePhaseTimers;
  final ValueChanged<bool>? onDebugDisablePhaseTimersChanged;

  /// 디버그: 세션 중 결제/생성 등 백엔드 API 호출 스킵
  final bool debugSkipBackendApi;
  final ValueChanged<bool>? onDebugSkipBackendApiChanged;

  /// 디버그: 자동 촬영 스킵
  final bool debugPausePhotoCapture;
  final ValueChanged<bool>? onDebugPausePhotoCaptureChanged;

  /// 디버그: 장비 연결 여부 확인 스킵 (UI 디버깅용)
  final bool debugSkipDeviceConnection;
  final ValueChanged<bool>? onDebugSkipDeviceConnectionChanged;

  /// BGM Volume (0.0 to 1.0)
  final double bgmVolume;
  final ValueChanged<double>? onBgmVolumeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenControlCard = AdminSectionCard(
      icon: Icons.tv,
      title: '화면 제어',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ActionRow(
            shortcut: 'F2',
            label: '첫 화면으로',
            onPressed: onFirstScreen,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          _ActionRow(
            shortcut: 'F4',
            label: '점검중 화면 표시',
            onPressed: onMaintenanceScreen,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          _ActionRow(
            shortcut: null,
            label: '검증 확인',
            onPressed: onVerificationCheck,
            colorScheme: colorScheme,
          ),
          if (onDeviceKeyChange != null) ...[
            const SizedBox(height: 12),
            _ActionRow(
              shortcut: null,
              label: '기기 로그인 키 바꾸기',
              onPressed: onDeviceKeyChange!,
              colorScheme: colorScheme,
            ),
          ],
        ],
      ),
    );

    // final debugCard = kDebugMode
    //     ? AdminSectionCard(
    //         icon: Icons.bug_report,
    //         title: '디버그 옵션 (Debug 모드에서만 노출)',
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             if (onDebugDisablePhaseTimersChanged != null)
    //               AdminSwitchField(
    //                 label: 'phase 타이머 전부 비활성화 (카메라 촬영 제외)',
    //                 value: debugDisablePhaseTimers,
    //                 onChanged: onDebugDisablePhaseTimersChanged!,
    //               ),
    //             if (onDebugSkipBackendApiChanged != null) ...[
    //               if (onDebugDisablePhaseTimersChanged != null) const SizedBox(height: 12),
    //               AdminSwitchField(
    //                 label: '백엔드 API 호출 스킵 (결제/생성 등 없이 다음 단계로)',
    //                 value: debugSkipBackendApi,
    //                 onChanged: onDebugSkipBackendApiChanged!,
    //               ),
    //             ],
    //           ],
    //         ),
    //       )
    //     : null;
    final debugCard = kDebugMode
        ? AdminSectionCard(
            icon: Icons.bug_report,
            title: '디버그 옵션 (Debug 모드에서만 노출)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (onDebugDisablePhaseTimersChanged != null)
                  AdminSwitchField(
                    label: 'phase 타이머 전부 비활성화 (카메라 촬영 제외)',
                    value: debugDisablePhaseTimers,
                    onChanged: onDebugDisablePhaseTimersChanged!,
                  ),
                if (onDebugSkipBackendApiChanged != null) ...[
                  if (onDebugDisablePhaseTimersChanged != null)
                    const SizedBox(height: 12),
                  AdminSwitchField(
                    label: '백엔드 API 호출 스킵 (결제/생성 등 없이 다음 단계로)',
                    value: debugSkipBackendApi,
                    onChanged: onDebugSkipBackendApiChanged!,
                  ),
                ],
                if (onDebugPausePhotoCaptureChanged != null) ...[
                  const SizedBox(height: 12),
                  AdminSwitchField(
                    label: '카메라 자동 촬영 일시정지 (수동 촬영만 가능)',
                    value: debugPausePhotoCapture,
                    onChanged: onDebugPausePhotoCaptureChanged!,
                  ),
                ],
                if (onDebugSkipDeviceConnectionChanged != null) ...[
                  const SizedBox(height: 12),
                  AdminSwitchField(
                    label: '장비 연결 확인 스킵 (UI 디버깅용)',
                    value: debugSkipDeviceConnection,
                    onChanged: onDebugSkipDeviceConnectionChanged!,
                  ),
                ],
              ],
            ),
          )
        : null;

    final appControlCard = AdminSectionCard(
      icon: Icons.settings,
      title: '앱 제어',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _ActionRow(
          //   shortcut: 'F6',
          //   label: '앱 재시작',
          //   onPressed: onAppRestart,
          //   colorScheme: colorScheme,
          // ),
          // const SizedBox(height: 12),
          _ActionRow(
            shortcut: 'F5',
            label: '앱 종료',
            onPressed: onAppExit,
            colorScheme: colorScheme,
          ),
          // const SizedBox(height: 12),
          // _ActionRow(
          //   shortcut: null,
          //   label: '앱 업데이트',
          //   onPressed: onAppUpdate,
          //   colorScheme: colorScheme,
          // ),
        ],
      ),
    );

    final audioControlCard = AdminSectionCard(
      icon: Icons.volume_up,
      title: '오디오 설정',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('배경음악 볼륨', style: theme.textTheme.bodyMedium),
              const Spacer(),
              Text(
                '${(bgmVolume * 100).toInt()}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: bgmVolume,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            label: '${(bgmVolume * 100).toInt()}%',
            onChanged: onBgmVolumeChanged,
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        if (isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '시스템',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: screenControlCard),
                  const SizedBox(width: 24),
                  Expanded(child: appControlCard),
                  const SizedBox(width: 24),
                  Expanded(child: audioControlCard),
                ],
              ),
              if (debugCard != null) ...[
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: debugCard),
                    const SizedBox(width: 24),
                    Expanded(child: const SizedBox()),
                    const SizedBox(width: 24),
                    Expanded(child: const SizedBox()),
                  ],
                ),
              ],
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '시스템',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              screenControlCard,
              const SizedBox(height: 16),
              appControlCard,
              const SizedBox(height: 16),
              audioControlCard,
              if (debugCard != null) ...[const SizedBox(height: 16), debugCard],
            ],
          );
        }
      },
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.shortcut,
    required this.label,
    required this.onPressed,
    required this.colorScheme,
  });

  final String? shortcut;
  final String label;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AdminTheme.kAdminPrimaryButtonMinHeight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (shortcut != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                shortcut!,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              minimumSize: const Size(
                0,
                AdminTheme.kAdminPrimaryButtonMinHeight,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('실행'),
          ),
        ],
      ),
    );
  }
}
