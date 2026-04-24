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

  /// Starts the forgot password flow by requesting a reset email.
  Future<Either<Failure, Unit>> forgotPassword(String email);

  Future<Either<Failure, Unit>> resetPassword(String token,String newPassword,);

  /// Resends the verification email for the given address.
  Future<Either<Failure, Unit>> resendVerification(String email);
}
