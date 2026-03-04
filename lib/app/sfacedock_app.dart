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
          return KioskViewport(
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const IntroScreen(), // Start with IntroScreen
        routes: {
          adminRouteName: (context) => const AdminScreen(),
          introRouteName: (context) => const IntroScreen(),
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

/// Placeholder intro screen - will be replaced with actual implementation
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 120,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 32),
            Text(
              'SFace Photo Kiosk',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '셀프 포토 스튜디오',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to StartScreen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('StartScreen을 구현해야 합니다')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '시작하기',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '관리자 설정: F1 | 홈으로: F2 | 종료: F5',
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}