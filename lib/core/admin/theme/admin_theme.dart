// lib/screens/admin/theme/admin_theme.dart

import 'package:flutter/material.dart';

/// 1920×1080 키오스크·터치 전제 어드민 전용 상수 및 테마.
/// 앱 전역 테마는 건드리지 않고, AdminScreen에서만 이 테마를 적용.
class AdminTheme {
  AdminTheme._();

  /// 터치용 최소 높이 (버튼·탭·스위치·스테퍼·드롭다운 트리거)
  static const double kAdminTouchMinHeight = 48;

  /// 주요 액션 버튼 최소 높이 (설정 저장, 테스트 인화, 첫 화면으로 등)
  static const double kAdminPrimaryButtonMinHeight = 56;

  /// 왼쪽 네비게이션 레일 너비
  static const double kAdminRailWidth = 280;

  /// 카드 내부 패딩
  static const double kAdminCardPadding = 24;

  /// 라벨 폭 (폼 필드 라벨 통일)
  static const double kAdminLabelWidth = 180;

  /// [context]의 상위 테마를 기반으로 어드민용 TextTheme·버튼 스타일만 오버라이드.
  static ThemeData theme(BuildContext context) {
    final parent = Theme.of(context);
    final baseText = parent.textTheme;

    final adminTextTheme = baseText.copyWith(
      bodyLarge: baseText.bodyLarge?.copyWith(
        fontFamily: 'Pretendard',
        fontSize: 16,
        height: 1.4,
        letterSpacing: 0,
      ),
      bodyMedium: baseText.bodyMedium?.copyWith(
        fontFamily: 'Pretendard',
        fontSize: 16,
        height: 1.4,
        letterSpacing: 0,
      ),
      bodySmall: baseText.bodySmall?.copyWith(
        fontFamily: 'Pretendard',
        fontSize: 14,
        height: 1.4,
        letterSpacing: 0,
      ),
      titleMedium: baseText.titleMedium?.copyWith(
        fontFamily: 'Pretendard',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: 0,
      ),
      titleSmall: baseText.titleSmall?.copyWith(
        fontFamily: 'Pretendard',
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.35,
        letterSpacing: 0,
      ),
      labelLarge: baseText.labelLarge?.copyWith(
        fontFamily: 'Pretendard',
        fontSize: 14,
        height: 1.35,
        letterSpacing: 0,
      ),
      headlineSmall: baseText.headlineSmall?.copyWith(
        fontFamily: 'Pretendard',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.25,
      ),
    );

    return parent.copyWith(
      textTheme: adminTextTheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, kAdminPrimaryButtonMinHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, kAdminTouchMinHeight),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(kAdminTouchMinHeight, kAdminTouchMinHeight),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
