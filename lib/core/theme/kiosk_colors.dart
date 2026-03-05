import 'package:flutter/material.dart';

/// SFaceDock Kiosk Color Palette
class KioskColors {
  KioskColors._();

  // Key Colors (Brand)
  static const Color primary = Color(0xFFFF97D5); // Pink
  static const Color secondary = Color(0xFF67EBD6); // Teal
  static const Color tertiary = Color(0xFFAE62EE); // Purple

  // Neutrals (White → Black)
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFF3F3F3);
  static const Color grey100 = Color(0xFFE0E0E0);
  static const Color grey200 = Color(0xFFB8B8B8);
  static const Color grey300 = Color(0xFF8F8F8F);
  static const Color grey400 = Color(0xFF7A7A7A);
  static const Color black = Color(0xFF000000);

  // Semantic
  static const Color error = Color(0xFFEA3F56);
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFA000);

  // Convenience aliases
  static const Color background = white;
  static const Color surface = white;
  static const Color surfaceHighlight = grey50;
  static const Color textPrimary = black;
  static const Color textSecondary = grey300;
  static const Color textDisabled = grey200;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0xCCFFFFFF),
      Color(0x99FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
