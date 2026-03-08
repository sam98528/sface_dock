// lib/screens/admin/widgets/admin_feature_section.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// NOTE: This import requires phase_timeout_keys.dart from common/constants
// If not available, you may need to comment out the debugConnectionLabel logic
// import '../../../common/constants/phase_timeout_keys.dart';
import '../theme/admin_theme.dart';
import 'admin_section_card.dart';
import 'admin_stepper_field.dart';
import 'admin_dropdown_field.dart';
import 'admin_switch_field.dart';
import 'admin_text_field.dart';
import 'admin_color_field.dart';

/// 화면별 타임아웃/안내문구 한 행 — 컴팩트 스테퍼 + 안내 문구 필드.
class _TimeoutRow extends StatelessWidget {
  const _TimeoutRow({
    super.key,
    required this.screenName,
    required this.timeoutSec,
    required this.onTimeoutChanged,
    this.debugConnectionLabel,
  });

  final String screenName;
  final int timeoutSec;
  final ValueChanged<int> onTimeoutChanged;

  /// 디버그 모드에서만 표시: 이 항목이 연결된 화면/상태 (예: SessionPhase.layoutSelection, 모달, 미연결).
  final String? debugConnectionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final showDebug = kDebugMode && debugConnectionLabel != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  screenName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              _CompactStepper(
                value: timeoutSec,
                min: 5,
                max: 300,
                onChanged: onTimeoutChanged,
              ),
            ],
          ),
          // if (showDebug) ...[
          //   const SizedBox(height: 4),
          //   Padding(
          //     padding: const EdgeInsets.only(left: 0, top: 2),
          //     child: Text(
          //       '연결: $debugConnectionLabel',
          //       style: theme.textTheme.labelSmall?.copyWith(
          //         color: colorScheme.primary,
          //         fontStyle: FontStyle.italic,
          //       ),
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }
}

/// 라벨 없는 컴팩트 스테퍼 (시간/타임아웃용). 터치 48×48dp.
class _CompactStepper extends StatelessWidget {
  const _CompactStepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  static const double _touchSize = AdminTheme.kAdminTouchMinHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canDecrease = value > min;
    final canIncrease = value < max;
    final bool showTenStep = (max - min) >= 20;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTenStep) ...[
          _MiniButton(
            text: '-10',
            enabled: value - 10 >= min,
            onTap: () {
              final nv = value - 10;
              onChanged(nv < min ? min : nv);
            },
            colorScheme: colorScheme,
          ),
          const SizedBox(width: 8),
        ],
        _MiniButton(
          icon: Icons.remove,
          enabled: canDecrease,
          onTap: () => onChanged(value - 1),
          colorScheme: colorScheme,
        ),
        const SizedBox(width: 12),
        Container(
          width: 56,
          height: _touchSize,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _MiniButton(
          icon: Icons.add,
          enabled: canIncrease,
          onTap: () => onChanged(value + 1),
          colorScheme: colorScheme,
        ),
        if (showTenStep) ...[
          const SizedBox(width: 8),
          _MiniButton(
            text: '+10',
            enabled: value + 10 <= max,
            onTap: () {
              final nv = value + 10;
              onChanged(nv > max ? max : nv);
            },
            colorScheme: colorScheme,
          ),
        ],
      ],
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({
    this.icon,
    this.text,
    required this.enabled,
    required this.onTap,
    required this.colorScheme,
  });

  final IconData? icon;
  final String? text;
  final bool enabled;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  static const double _size = AdminTheme.kAdminTouchMinHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: text != null ? _size + 6 : _size,
          height: _size,
          child: Container(
            decoration: BoxDecoration(
              color: enabled
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: enabled
                    ? colorScheme.primary.withValues(alpha: 0.6)
                    : colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            alignment: Alignment.center,
            child: icon != null
                ? Icon(
                    icon,
                    size: 24,
                    color: enabled
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.4),
                  )
                : Text(
                    text!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: enabled
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// 기능 설정 — 촬영, 필터, 화면/시간, 기타, 테마.
class AdminFeatureSection extends StatelessWidget {
  const AdminFeatureSection({
    super.key,
    // 촬영
    required this.mirrorEnabled,
    required this.countdownEnabled,
    required this.countdownSec,
    required this.onMirrorChanged,
    required this.onCountdownEnabledChanged,
    required this.onCountdownSecChanged,
    required this.shotCount,
    required this.onShotCountChanged,
    required this.delayBetweenShots,
    required this.onDelayBetweenShotsChanged,
    required this.remoteEnabled,
    required this.remoteCountdownSec,
    required this.onRemoteEnabledChanged,
    required this.onRemoteCountdownSecChanged,
    // 필터
    required this.colorFilterNames,
    required this.onColorFilterChanged,
    required this.colorFilterOptions,
    // 화면/시간 (타임아웃 + 안내문구)
    required this.introClipSec,
    required this.introGuide,
    required this.onIntroClipSecChanged,
    required this.onIntroGuideChanged,
    required this.printWaitDurationSeconds,
    required this.onPrintWaitDurationSecondsChanged,
    required this.timeoutsAndGuides,
    required this.onTimeoutAndGuideChanged,
    // 기타
    required this.backupPath,
    required this.onBackupPathChanged,
    required this.localeIndex,
    required this.localeOptions,
    required this.onLocaleChanged,
    // 가격
    required this.photoPrice,
    required this.onPhotoPriceChanged,
    // 테마
    required this.themeBackground,
    required this.themeKeyColor,
    required this.themeTextColor,
    required this.themeButtonBg,
    required this.themeButtonText,
    required this.onThemeBackgroundChanged,
    required this.onThemeKeyColorChanged,
    required this.onThemeTextColorChanged,
    required this.onThemeButtonBgChanged,
    required this.onThemeButtonTextChanged,
  });

  final bool mirrorEnabled;
  final bool countdownEnabled;
  final int countdownSec;
  final ValueChanged<bool> onMirrorChanged;
  final ValueChanged<bool> onCountdownEnabledChanged;
  final ValueChanged<int> onCountdownSecChanged;
  final int shotCount;
  final ValueChanged<int> onShotCountChanged;
  final int delayBetweenShots;
  final ValueChanged<int> onDelayBetweenShotsChanged;
  final bool remoteEnabled;
  final int remoteCountdownSec;
  final ValueChanged<bool> onRemoteEnabledChanged;
  final ValueChanged<int> onRemoteCountdownSecChanged;

  final List<String> colorFilterNames;
  final ValueChanged<List<String>> onColorFilterChanged;
  final List<String> colorFilterOptions;

  final int introClipSec;
  final String introGuide;
  final ValueChanged<int> onIntroClipSecChanged;
  final ValueChanged<String> onIntroGuideChanged;
  final int printWaitDurationSeconds;
  final ValueChanged<int> onPrintWaitDurationSecondsChanged;
  final Map<String, ({int timeout, String guide})> timeoutsAndGuides;
  final void Function(String key, int? timeout, String? guide)
  onTimeoutAndGuideChanged;

  final int photoPrice;
  final ValueChanged<int> onPhotoPriceChanged;

  final String backupPath;
  final ValueChanged<String> onBackupPathChanged;
  final int localeIndex;
  final List<String> localeOptions;
  final ValueChanged<int> onLocaleChanged;

  final Color themeBackground;
  final Color themeKeyColor;
  final Color themeTextColor;
  final Color themeButtonBg;
  final Color themeButtonText;
  final ValueChanged<Color> onThemeBackgroundChanged;
  final ValueChanged<Color> onThemeKeyColorChanged;
  final ValueChanged<Color> onThemeTextColorChanged;
  final ValueChanged<Color> onThemeButtonBgChanged;
  final ValueChanged<Color> onThemeButtonTextChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Cards
    final cameraConfigCard = AdminSectionCard(
      icon: Icons.photo_camera,
      title: '촬영 설정',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSwitchField(
            label: '라이브뷰 좌우 반전',
            value: mirrorEnabled,
            onChanged: onMirrorChanged,
          ),
          const SizedBox(height: 12),
          AdminSwitchField(
            label: '카운트 다운 여부',
            value: countdownEnabled,
            onChanged: onCountdownEnabledChanged,
          ),
          if (countdownEnabled) ...[
            const SizedBox(height: 8),
            AdminStepperField(
              label: '카운트 다운 시간(초)',
              value: countdownSec,
              onChanged: onCountdownSecChanged,
              min: 5,
              max: 15,
            ),
          ],
          const SizedBox(height: 12),
          AdminStepperField(
            label: '촬영 매수',
            value: shotCount,
            onChanged: onShotCountChanged,
            min: 1,
            max: 20,
          ),
          const SizedBox(height: 12),
          AdminStepperField(
            label: '지연시간(촬영 후 ms)',
            value: delayBetweenShots,
            onChanged: onDelayBetweenShotsChanged,
            min: 0,
            max: 5000,
            step: 100,
          ),
          const SizedBox(height: 12),
          AdminSwitchField(
            label: '리모컨 사용 여부',
            value: remoteEnabled,
            onChanged: onRemoteEnabledChanged,
          ),
          const SizedBox(height: 8),
          AdminStepperField(
            label: '리모컨 카운트다운(초)',
            value: remoteCountdownSec,
            onChanged: onRemoteCountdownSecChanged,
            min: 5,
            max: 15,
          ),
        ],
      ),
    );

    final filterCard = AdminSectionCard(
      icon: Icons.filter,
      title: '필터 설정',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '색감 필터 (다중 선택)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colorFilterOptions.map((opt) {
              final isSelected = colorFilterNames.contains(opt);
              return FilterChip(
                label: Text(
                  opt,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                selected: isSelected,
                showCheckmark: true,
                checkmarkColor: Colors.white,
                selectedColor: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surfaceContainerHighest
                    .withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                onSelected: (selected) {
                  final newList = List<String>.from(colorFilterNames);
                  if (selected) {
                    newList.add(opt);
                  } else {
                    newList.remove(opt);
                    if (newList.isEmpty) newList.add('없음');
                  }

                  if (opt == '없음' && selected) {
                    newList.clear();
                    newList.add('없음');
                  } else if (opt != '없음' && selected) {
                    newList.remove('없음');
                  }
                  onColorFilterChanged(newList);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );

    final screenTimeCard = AdminSectionCard(
      icon: Icons.schedule,
      title: '시간 설정',
      subtitle: '각 화면의 타임아웃을 설정합니다.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminStepperField(
            label: '인트로 확인 안내 대기 시간(초)', // was '인트로 클립 재생 시간(초)'
            value: introClipSec,
            onChanged: onIntroClipSecChanged,
            min: 5,
            max: 120,
          ),
          const SizedBox(height: 12),
          AdminStepperField(
            label: '인쇄 대기 화면 유지 시간(초)', // Moved from debug options
            value: printWaitDurationSeconds,
            onChanged: onPrintWaitDurationSecondsChanged,
            min: 10,
            max: 300,
          ),
          const SizedBox(height: 16),
          // NOTE: PhaseTimeoutKeys.debugLabelForAdminKey requires phase_timeout_keys.dart
          // If not available, comment out the filter logic below
          ...timeoutsAndGuides.entries
              // .where(
              //   (e) => PhaseTimeoutKeys.debugLabelForAdminKey(e.key) != '미연결',
              // )
              .map((e) {
                final key = e.key;
                final v = e.value;
                return _TimeoutRow(
                  key: ValueKey(key),
                  screenName: key,
                  timeoutSec: v.timeout,
                  onTimeoutChanged: (n) =>
                      onTimeoutAndGuideChanged(key, n, null),
                  // debugConnectionLabel: PhaseTimeoutKeys.debugLabelForAdminKey(
                  //   key,
                  // ),
                );
              }),
        ],
      ),
    );

    final etcCard = AdminSectionCard(
      icon: Icons.settings,
      title: '기타 설정',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminStepperField(
            label: '사진 1장 가격 (원)',
            value: photoPrice,
            onChanged: onPhotoPriceChanged,
            min: 0,
            max: 10000,
            step: 100,
          ),
          const SizedBox(height: 12),
          AdminTextField(
            label: '고객 사진 로컬 백업',
            value: backupPath,
            onChanged: onBackupPathChanged,
            hint: '폴더 경로',
          ),
          const SizedBox(height: 12),
          AdminDropdownField<int>(
            label: '언어팩',
            value: localeIndex >= 0 && localeIndex < localeOptions.length
                ? localeIndex
                : 0,
            items: List.generate(localeOptions.length, (i) => i),
            itemLabel: (i) => localeOptions[i],
            onChanged: (i) => onLocaleChanged(i ?? 0),
          ),
        ],
      ),
    );

    final themeCard = AdminSectionCard(
      icon: Icons.palette,
      title: '테마',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminColorField(
            label: '전체 배경색',
            color: themeBackground,
            onColorChanged: onThemeBackgroundChanged,
          ),
          const SizedBox(height: 12),
          AdminColorField(
            label: '키 컬러',
            color: themeKeyColor,
            onColorChanged: onThemeKeyColorChanged,
          ),
          const SizedBox(height: 12),
          AdminColorField(
            label: '전체 글자색',
            color: themeTextColor,
            onColorChanged: onThemeTextColorChanged,
          ),
          const SizedBox(height: 12),
          AdminColorField(
            label: '버튼 배경색',
            color: themeButtonBg,
            onColorChanged: onThemeButtonBgChanged,
          ),
          const SizedBox(height: 12),
          AdminColorField(
            label: '버튼 글자색',
            color: themeButtonText,
            onColorChanged: onThemeButtonTextChanged,
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
                '기능 설정',
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
                  // Left Column: Camera, Screen Time
                  Expanded(
                    child: Column(
                      children: [
                        cameraConfigCard,
                        const SizedBox(height: 24),
                        screenTimeCard,
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right Column: Filter, Etc, Theme
                  Expanded(
                    child: Column(
                      children: [
                        filterCard,
                        // const SizedBox(height: 24),
                        // etcCard,
                        const SizedBox(height: 24),
                        themeCard,
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '기능 설정',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              cameraConfigCard,
              const SizedBox(height: 16),
              filterCard,
              const SizedBox(height: 16),
              screenTimeCard,
              const SizedBox(height: 16),
              etcCard,
              const SizedBox(height: 16),
              themeCard,
            ],
          );
        }
      },
    );
  }
}
