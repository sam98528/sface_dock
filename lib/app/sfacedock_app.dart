// lib/app/sfacedock_app.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/admin/controllers/admin_controller.dart';
import '../core/admin/screens/admin_screen.dart';
import '../core/theme/app_theme.dart';
import '../utils/app_lifecycle.dart';
import '../widgets/kiosk_viewport.dart';
import 'kiosk_navigator_observer.dart';
import '../presentation/screens/intro_screen.dart';
import '../presentation/screens/intro_loading_screen.dart';

/// Route names
const String adminRouteName = '/admin';
const String homeRouteName = '/';
const String introRouteName = '/intro';
const String startRouteName = '/start';
const String photoGridRouteName = '/photo-grid';
const String cartRouteName = '/cart';
const String paymentRouteName = '/payment';
const String endRouteName = '/end';

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

  @override
  Widget build(BuildContext context) {
    // Watch theme version to rebuild when admin settings change
    ref.watch(adminThemeVersionProvider);

    final navigatorObserver = ref.watch(navigatorObserverProvider);

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: MaterialApp(
        title: 'SFace Photo Kiosk',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.buildTheme(),
        navigatorKey: _navigatorKey,
        navigatorObservers: [navigatorObserver],
        builder: (context, child) {
          return KioskViewport(child: child ?? const SizedBox.shrink());
        },
        home: const IntroScreen(), // Start with IntroScreen
        routes: {
          adminRouteName: (context) => const AdminScreen(),
          introRouteName: (context) => const IntroScreen(),
          '/loading': (context) => const IntroLoadingScreen(),
          // TODO: Add other routes as screens are implemented
        },
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
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
      if (currentRoute != homeRouteName) {
        _navigatorKey.currentState?.popUntil((route) => route.isFirst);
      }
      return;
    }

    // F5: Exit app
    if (event.logicalKey == LogicalKeyboardKey.f5) {
      exitApp();
      return;
    }
  }
}
