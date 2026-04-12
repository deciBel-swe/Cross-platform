import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';

/// Abstract contract for the authentication repository.
abstract class IAuthRepository {
  /// Logs in with email and password and returns the authenticated user.
  Future<Either<Failure, AuthUser>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  /// Registers a new user account using local credentials.
  Future<Either<Failure, Unit>> registerWithEmailPassword({
    required String email,
    required String displayName,
    required String password,
    required DateTime dateOfBirth,
    required String gender,
    String? city,
    String? country,
    required String captchaToken,
  });

  /// Initiates the Google OAuth login flow and returns the authenticated user upon success.
  ///
  /// Returns a failure if authentication process gets interrupted, or fails for another reason.
  Future<Either<Failure, AuthUser>> loginWithGoogle();

  /// Refreshes the current authentication token.
  Future<Either<Failure, AuthUser>> refreshToken();

  /// Retrieves the current authenticated user off local storage/session if one exists.
  ///
  /// Returns null if no user is currently logged in or the session has expired.
  Future<Either<Failure, AuthUser?>> getCurrentUser();

  /// Logs out the current user from the backend and clears the local session.
  ///
  /// Returns a failure if the backend logout request fails.
  /// Local authentication data should still be cleared afterwards.
  Future<Either<Failure, Unit>> logout();
}
