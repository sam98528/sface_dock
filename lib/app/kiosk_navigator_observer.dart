// lib/app/kiosk_navigator_observer.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the current route name for F-key shortcuts (F1 admin, F2 home, F5 exit).
class KioskNavigatorObserver extends NavigatorObserver {
  String? _currentRouteName;

  String? get currentRouteName => _currentRouteName;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _currentRouteName = route.settings.name;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _currentRouteName = previousRoute?.settings.name;
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _currentRouteName = newRoute?.settings.name;
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _currentRouteName = previousRoute?.settings.name;
  }
}

/// Global provider for the navigator observer.
final navigatorObserverProvider = Provider<KioskNavigatorObserver>((ref) {
  return KioskNavigatorObserver();
});

/// Route name constants
const String adminRouteName = '/admin';
const String verificationRouteName = '/verification';
const String homeRouteName = '/';
