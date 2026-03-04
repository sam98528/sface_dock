// lib/core/admin/controllers/locale_controller.dart
//
// Locale management for the kiosk app

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supported locales for the kiosk app
enum AppLocale {
  ko('ko', 'KR', '한국어'),
  en('en', 'US', 'English'),
  ja('ja', 'JP', '日本語'),
  zhCN('zh', 'CN', '简体中文'),
  zhTW('zh', 'TW', '繁體中文');

  const AppLocale(this.languageCode, this.countryCode, this.displayName);

  final String languageCode;
  final String countryCode;
  final String displayName;

  Locale toLocale() => Locale(languageCode, countryCode);
}

/// Locale controller - manages app locale
class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(AppLocale.ko.toLocale());

  /// Set locale by AppLocale enum
  void setLocale(AppLocale locale) {
    state = locale.toLocale();
  }

  /// Set locale by language code
  void setLocaleByCode(String languageCode) {
    final locale = AppLocale.values.firstWhere(
      (l) => l.languageCode == languageCode,
      orElse: () => AppLocale.ko,
    );
    state = locale.toLocale();
  }
}

/// Provider for locale controller
final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>(
  (ref) => LocaleController(),
);
