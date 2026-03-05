import 'package:flutter/material.dart';

/// Kiosk Typography — LINESeed font family
class KioskTypography {
  KioskTypography._();

  static const String fontFamily = 'LINESeed';

  /// 1920x1080 터치스크린 키오스크용 가독성 크기.
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: _style(72, FontWeight.bold),
      displayMedium: _style(56, FontWeight.bold),
      displaySmall: _style(44, FontWeight.bold),
      headlineLarge: _style(40, FontWeight.w600),
      headlineMedium: _style(34, FontWeight.w600),
      headlineSmall: _style(28, FontWeight.w600),
      titleLarge: _style(26, FontWeight.w400),
      titleMedium: _style(20, FontWeight.w400),
      titleSmall: _style(18, FontWeight.w400),
      bodyLarge: _style(20, FontWeight.normal),
      bodyMedium: _style(18, FontWeight.normal),
      bodySmall: _style(15, FontWeight.normal),
      labelLarge: _style(18, FontWeight.w600),
      labelMedium: _style(16, FontWeight.w600),
      labelSmall: _style(14, FontWeight.w600),
    );
  }

  static const TextHeightBehavior textHeightBehavior = TextHeightBehavior(
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle _style(double size, FontWeight weight) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: 1.2,
    );
  }
}
