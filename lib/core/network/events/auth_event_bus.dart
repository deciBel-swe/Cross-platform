import 'dart:async';

/// A global event bus for authentication-related events.
///
/// This singleton allows the core networking layer (like [AuthInterceptor])
/// to broadcast forced logout events (e.g., when a refresh token fails)
/// directly to the Presentation layer ([AuthNotifier]) without creating
/// circular dependencies.
class AuthEventBus {
  // Private constructor
  AuthEventBus._internal();

  // Singleton instance
  static final AuthEventBus _instance = AuthEventBus._internal();

  /// Returns the singleton instance of [AuthEventBus].
  factory AuthEventBus() => _instance;

  final _logoutController = StreamController<void>.broadcast();

  /// A stream that emits an event whenever the user must be forcibly logged out.
  Stream<void> get logoutStream => _logoutController.stream;

  /// Broadcasts a forced logout event to all active listeners.
  ///
  /// Useful when session restoration fails or the refresh token is rejected
  /// by the server.
  void emitLogout() {
    _logoutController.add(null);
  }

  /// Closes the underlying stream. Should typically only be called during app teardown.
  void dispose() {
    _logoutController.close();
  }
}
