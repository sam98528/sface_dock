// lib/core/session/controllers/session_controller.dart
//
// Session lifecycle controller - manages user session state

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../state/session_state.dart';
import 'device_auth_controller.dart';

/// SessionController manages session lifecycle.
///
/// Basic flow:
/// 1. idle -> startSession() -> active
/// 2. active -> endSession() -> ended
/// 3. ended -> resetToIdle() -> idle
class SessionController extends StateNotifier<SessionState> {
  SessionController(this.ref) : super(const SessionState.idle());

  final Ref ref;
  String? _currentSessionId;

  /// Start a new session
  Future<void> startSession() async {
    // Check if device is authenticated
    final authState = ref.read(deviceAuthControllerProvider);
    final isLoggedIn = authState.maybeWhen(
      loggedIn: (_, __, ___) => true,
      orElse: () => false,
    );

    if (!isLoggedIn) {
      state = const SessionState.deviceError(
        errorCodes: ['DEVICE_NOT_AUTHENTICATED'],
      );
      return;
    }

    // Generate session ID
    _currentSessionId = const Uuid().v4();

    // Set state to active
    state = const SessionState.active();
  }

  /// End current session
  void endSession() {
    state = const SessionState.ended(reason: SessionEndReason.normal);
  }

  /// Reset to idle state (ready for new session)
  void resetToIdle() {
    _currentSessionId = null;
    state = const SessionState.idle();
  }

  /// Force terminate session with specific reason
  void forceTerminate(SessionEndReason reason) {
    _currentSessionId = null;
    state = SessionState.ended(reason: reason);
  }

  /// Get current session ID
  String? get currentSessionId => _currentSessionId;
}

/// Provider for SessionController
final sessionControllerProvider =
    StateNotifierProvider<SessionController, SessionState>(
  (ref) => SessionController(ref),
);
