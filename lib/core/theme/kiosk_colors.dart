import 'package:flutter/material.dart';

/// Premium Kiosk Color Palette (Light Theme)
/// Clean, Modern, Trustworthy.
class KioskColors {
  KioskColors._();

  // Core Backgrounds
  static const Color background = Color(0xFFF8F9FD); // Off-white / Very light blue-grey
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceHighlight = Color(0xFFEFF1F5); // Light Grey for containers

  // Accents
  static const Color primary = Color(0xFF2962FF); // Deep Royal Blue (Premium Trust)
  static const Color secondary = Color(0xFF6200EA); // Deep Purple
  static const Color accent = Color(0xFFFF4081); // Pink Accent

  // Text
  static const Color textPrimary = Color(0xFF1A1D1F); // Almost Black
  static const Color textSecondary = Color(0xFF5F6368); // Medium Grey
  static const Color textDisabled = Color(0xFF9AA0A6); // Light Grey

  // Semantic
  static const Color error = Color(0xFFD32F2F); // Standard Red
  static const Color success = Color(0xFF00C853); // Standard Green
  static const Color warning = Color(0xFFFFA000); // Amber

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2962FF), Color(0xFF448AFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0xCCFFFFFF), // White with 80% opacity
      Color(0x99FFFFFF), // White with 60% opacity
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows (Soft, Diffuse)
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Color(0x0D000000), // 5% Black
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
