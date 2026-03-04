// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/admin/controllers/admin_controller.dart';
import '../core/admin/screens/admin_screen.dart';
import '../core/theme/app_theme.dart';
import '../utils/app_lifecycle.dart';
import '../widgets/kiosk_viewport.dart';
import 'kiosk_navigator_observer.dart';

/// Route names
const String adminRouteName = '/admin';
const String homeRouteName = '/';
const String verificationRouteName = '/verification';  // TODO: Create verification screen

/// Main kiosk application widget.
/// - Wraps content in KioskViewport (1920x1080 fixed)
/// - F1 shortcut for admin screen
/// - F2 shortcut to return to home
/// - F5 shortcut to exit app
class KioskApp extends ConsumerStatefulWidget {
  const KioskApp({super.key});

  @override
  ConsumerState<KioskApp> createState() => _KioskAppState();
}

class _KioskAppState extends ConsumerState<KioskApp> {
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
        title: 'Kiosk Template',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.buildTheme(),
        navigatorKey: _navigatorKey,
        navigatorObservers: [navigatorObserver],
        builder: (context, child) {
          return KioskViewport(
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const HomeScreen(),
        routes: {
          adminRouteName: (context) => const AdminScreen(),
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

/// Placeholder home screen - replace with your actual home screen.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              Icons.computer,
              size: 120,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 32),
            Text(
              'Kiosk Template',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Replace this screen with your app content',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keyboard Shortcuts:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ShortcutRow(
                    keyLabel: 'F1',
                    description: 'Open Admin Screen',
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _ShortcutRow(
                    keyLabel: 'F2',
                    description: 'Return to Home',
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _ShortcutRow(
                    keyLabel: 'F5',
                    description: 'Exit Application',
                    colorScheme: colorScheme,
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

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({
    required this.keyLabel,
    required this.description,
    required this.colorScheme,
  });

  final String keyLabel;
  final String description;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            keyLabel,
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          description,
          style: TextStyle(
            color: colorScheme.onPrimaryContainer,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
