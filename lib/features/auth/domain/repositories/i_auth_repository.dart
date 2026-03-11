import '../entities/auth_user.dart';

/// Abstract contract for the authentication repository.
abstract class IAuthRepository {
  /// Initiates the Google OAuth login flow and returns the authenticated user upon success.
  ///
  /// Throws [AppException] subclasses on failure, which should be mapped to [Failure] if needed.
  Future<AuthUser> loginWithGoogle();

  /// Retrieves the current authenticated user off local storage/session if one exists.
  ///
  /// Returns null if no user is currently logged in or the session has expired.
  Future<AuthUser?> getCurrentUser();

  /// Logs out the current user by clearing authentication tokens.
  ///
  /// This method should invalidate any stored tokens (access and refresh)
  /// and clear any cached user session data.
  ///
  /// Returns a [Future<void>] that completes when the logout operation is finished.
  ///
  /// Throws [AppException] subclasses on failure, which should be mapped to [Failure] if needed.
  //Future<void> logout();
}
