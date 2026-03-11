import 'auth_user.dart';

//I used those states for the UI/routing to react to the authentication state
/// Represents the various states of authentication in the application.
sealed class AuthState {
  const AuthState();
}

/// State when a user is successfully authenticated.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});

  /// The authenticated user entity.
  final AuthUser user;
}

/// State when no user is currently authenticated.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State representing an ongoing authentication process.
class AuthLoading extends AuthState {
  const AuthLoading();
}
