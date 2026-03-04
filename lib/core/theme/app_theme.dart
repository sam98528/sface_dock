import 'package:flutter/material.dart';
import 'kiosk_colors.dart';
import 'kiosk_typography.dart';

/// 앱 테마 컬러 및 스타일 정의.
/// Admin 설정에서 주입 가능 (배경/키/글자/버튼 색상).
class AppTheme {
  AppTheme._();

  // Admin 테마 상태 (Defaults to Premium Light)
  static Color themeBackground = KioskColors.background;
  static Color themeKeyColor = KioskColors.primary;
  static Color themeTextColor = KioskColors.textPrimary;
  static Color themeButtonBg = KioskColors.primary;
  static Color themeButtonText = Colors.white;

  // Legacy compatibility (Mapped to new system)
  static Color get keyColor => themeKeyColor;
  static Color get subColor => KioskColors.secondary;

  /// Admin에서 저장한 5가지 테마 색상 적용
  static void setThemeFromAdmin({
    required Color background,
    required Color key,
    required Color text,
    required Color buttonBg,
    required Color buttonText,
  }) {
    themeBackground = background;
    themeKeyColor = key;
    themeTextColor = text;
    themeButtonBg = buttonBg;
    themeButtonText = buttonText;
  }

  /// MaterialApp용 ThemeData 생성
  /// Light Theme 기반으로 변경.
  static ThemeData buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light, // Switch to Light
      scaffoldBackgroundColor: themeBackground,

      // ColorScheme: Admin 색 + 파생 색 명시
      colorScheme: ColorScheme.light(
        primary: themeKeyColor,
        onPrimary: themeButtonText,
        primaryContainer: themeKeyColor.withValues(alpha: 0.1),
        onPrimaryContainer: themeKeyColor,
        secondary: KioskColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: KioskColors.secondary.withValues(alpha: 0.1),
        onSecondaryContainer: KioskColors.secondary,
        surface: themeBackground,
        onSurface: themeTextColor,
        surfaceContainerHighest: KioskColors.surfaceHighlight,
        surfaceContainerLow: Colors.white,
        outline: themeTextColor.withValues(alpha: 0.2),
        outlineVariant: themeTextColor.withValues(alpha: 0.1),
        onSurfaceVariant: KioskColors.textSecondary,
        error: KioskColors.error,
        onError: Colors.white,
        errorContainer: KioskColors.error.withValues(alpha: 0.1),
        onErrorContainer: KioskColors.error,
      ),

      // Typography
      textTheme: KioskTypography.textTheme.apply(
        bodyColor: themeTextColor,
        displayColor: themeTextColor,
      ),

      // Component Themes
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: themeButtonBg,
          foregroundColor: themeButtonText,
          textStyle: KioskTypography.textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Larger radius
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20), // Larger padding
          elevation: 0,
        ),
      ),

      iconTheme: IconThemeData(color: themeTextColor),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: KioskTypography.textTheme.titleLarge?.copyWith(
          color: themeTextColor,
        ),
        iconTheme: IconThemeData(color: themeTextColor),
      ),
    );
  }
}
