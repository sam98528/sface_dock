// lib/app/sfacedock_app.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfacedock/core/theme/kiosk_typography.dart';
import 'package:sfacedock/presentation/screens/photo_grid_screen.dart';

import '../core/admin/controllers/admin_controller.dart';
import '../core/admin/models/admin_settings_model.dart';
import '../presentation/screens/admin_screen.dart';
import '../core/device/device_controller_proxy_provider.dart';
import '../core/services/audio_service.dart';
import '../core/services/image_prefetch_service.dart';
import '../core/theme/app_theme.dart';
import '../utils/app_lifecycle.dart';
import '../widgets/kiosk_viewport.dart';
import 'kiosk_navigator_observer.dart';
import '../presentation/screens/intro_screen.dart';
import '../presentation/screens/intro_loading_screen.dart';
import '../presentation/screens/cart_screen.dart';
import '../presentation/screens/payment_screen.dart';
import '../presentation/screens/print_loading_screen.dart';
import '../presentation/screens/qr_scanner_screen.dart';
import '../presentation/screens/completion_screen.dart';
import '../presentation/screens/maintenance_screen.dart';

/// Route names
const String adminRouteName = '/admin';
const String homeRouteName = '/';
const String introRouteName = '/intro';
const String introLoadingRouteName = '/intro-loading';
const String startRouteName = '/start';
const String photoGridRouteName = '/photo-grid';
const String cartRouteName = '/cart';
const String paymentRouteName = '/payment';
const String endRouteName = '/end';
const String qrScannerRouteName = '/qr-scanner';
const String printLoadingRouteName = '/print-loading';
const String completionRouteName = '/completion';
const String maintenanceRouteName = '/maintenance';

/// Main SFaceDock kiosk application widget.
/// - Wraps content in KioskViewport (1920x1080 fixed)
/// - F1 shortcut for admin screen
/// - F2 shortcut to return to home
/// - F5 shortcut to exit app
class SFaceDockApp extends ConsumerStatefulWidget {
  const SFaceDockApp({super.key});

  @override
  ConsumerState<SFaceDockApp> createState() => _SFaceDockAppState();
}

class _SFaceDockAppState extends ConsumerState<SFaceDockApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _isShuttingDown = false;

  @override
  void initState() {
    super.initState();
    // Initialize theme from admin settings
    final adminSettings = ref.read(adminControllerProvider);
    AppTheme.setThemeFromAdmin(
      background: adminSettings.themeBackground,
      key: adminSettings.themeKeyColor,
      text: adminSettings.themeTextColor,
      buttonBg: adminSettings.themeButtonBg,
      buttonText: adminSettings.themeButtonText,
    );
    // Initialize audio service and start BGM
    final audio = ref.read(kioskAudioServiceProvider);
    final bgmVolume = adminSettings.bgmVolume;
    audio.setBgmVolume(bgmVolume);
    audio.startBgm();
  }

  @override
  Widget build(BuildContext context) {
    // Watch theme version to rebuild when admin settings change
    ref.watch(adminThemeVersionProvider);

    // Sync BGM volume with admin settings
    ref.listen(adminControllerProvider, (AdminSettings? prev, AdminSettings next) {
      if (prev?.bgmVolume != next.bgmVolume) {
        ref.read(kioskAudioServiceProvider).setBgmVolume(next.bgmVolume);
      }
    });

    final navigatorObserver = ref.watch(navigatorObserverProvider);

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: MaterialApp(
        title: 'SFace Photo Kiosk',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.buildTheme(),
        locale: const Locale('ko'),
        supportedLocales: const [Locale('ko')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        navigatorKey: _navigatorKey,
        navigatorObservers: [navigatorObserver],
        builder: (context, child) {
          return DefaultTextHeightBehavior(
            textHeightBehavior: KioskTypography.textHeightBehavior,
            child: KioskViewport(child: child ?? const SizedBox.shrink()),
          );
        },
        home: const IntroScreen(), // Start with IntroScreen
        routes: {
          adminRouteName: (context) => const AdminScreen(),
          introRouteName: (context) => const IntroScreen(),
          introLoadingRouteName: (context) => const IntroLoadingScreen(),
          photoGridRouteName: (context) => const PhotoGridScreen(),
          cartRouteName: (context) => const CartScreen(),
          paymentRouteName: (context) => const PaymentScreen(),
          qrScannerRouteName: (context) => const QrScannerScreen(),
          printLoadingRouteName: (context) => const PrintLoadingScreen(),
          completionRouteName: (context) => const CompletionScreen(),
          maintenanceRouteName: (context) => const MaintenanceScreen(),
        },
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) async {
    if (event is! KeyDownEvent) return;

    final navigatorObserver = ref.read(navigatorObserverProvider);
    final currentRoute = navigatorObserver.currentRouteName;

    // F1: Open admin screen
    if (event.logicalKey == LogicalKeyboardKey.f1) {
      if (currentRoute != adminRouteName) {
        _navigatorKey.currentState?.pushNamed(adminRouteName);
      }
      return;
    }

    // F2: Return to home screen
    if (event.logicalKey == LogicalKeyboardKey.f2) {
      if (currentRoute != homeRouteName && currentRoute != introRouteName) {
        // Suspend hardware but keep IPC pipe open — await로 해제 완료 후 화면 전환
        final proxy = ref.read(deviceControllerProxyProvider);
        if (proxy.isConnected) {
          await proxy.suspendHardware();
          debugPrint('[F2] Hardware suspended - returning to intro');
        }

        // Resume background pre-fetching when returning to idle screen
        ref.read(imagePrefetchProvider.notifier).resume();
        _navigatorKey.currentState?.pushNamedAndRemoveUntil(
          introRouteName,
          (route) => false,
        );
      }
      return;
    }

    // F4: Maintenance screen (점검중)
    if (event.logicalKey == LogicalKeyboardKey.f4) {
      if (currentRoute != maintenanceRouteName) {
        _navigatorKey.currentState?.pushNamedAndRemoveUntil(
          maintenanceRouteName,
          (route) => false,
        );
      }
      return;
    }

    // F5: Exit app + shutdown service (개발 중 재시작 시 서비스도 같이 종료)
    if (event.logicalKey == LogicalKeyboardKey.f5) {
      // 연타 방어
      if (_isShuttingDown) return;
      _isShuttingDown = true;

      final proxy = ref.read(deviceControllerProxyProvider);
      if (proxy.isConnected) {
        debugPrint('[F5] Shutting down service before exit...');
        // try-catch + await: .then() 체인의 예외 전파 문제 해결
        try {
          await proxy.shutdownService().timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              debugPrint('[F5] shutdownService timed out - forcing exit');
              return false;
            },
          );
        } catch (_) {}
        try {
          await proxy.disconnect().timeout(
            const Duration(seconds: 2),
            onTimeout: () {},
          );
        } catch (_) {}
      }
      debugPrint('[F5] Cleanup done - exiting');
      exitApp();
      return;
    }
  }
}
