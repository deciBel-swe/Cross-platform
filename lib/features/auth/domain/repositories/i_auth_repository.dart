import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';

/// Abstract contract for the authentication repository.
abstract class IAuthRepository {
  /// Initiates the Google OAuth login flow and returns the authenticated user upon success.
  ///
  /// Returns a failure if authentication process gets interrupted, or fails for another reason.
  Future<Either<Failure, AuthUser>> loginWithGoogle();

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
