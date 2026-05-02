import 'dart:async';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_mock_fixtures.dart';
import '../models/login_response_model.dart';

@Environment('mock')
@LazySingleton(as: IAuthRepository)
/// Mock implementation of [IAuthRepository] for testing and development.
/// This version is specialized for testing the 400-second token expiration.
class MockAuthRepository implements IAuthRepository {
  MockAuthRepository(this._secureStorageService);
  final SecureStorageService _secureStorageService;

  @override
  Future<Either<Failure, AuthUser>> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    return loginWithGoogle();
  }

  @override
  Future<Either<Failure, Unit>> registerWithEmailPassword({
    required String email,
    required String displayName,
    required String password,
    required DateTime dateOfBirth,
    required String gender,
    String? city,
    String? country,
    required String captchaToken,
  }) async {
    await Future<void>.delayed(AuthMockFixtures.delay);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, AuthUser>> loginWithGoogle() async {
    // Standard async delay for realistic UI loading states
    await Future<void>.delayed(AuthMockFixtures.delay);

    // Load mock data; 'expiresIn' should be set to 400 in fixtures for testing
    final model = LoginResponseModel.fromJson(
      AuthMockFixtures.mockLoginResponse,
    );

    // Save tokens and calculate exact expiration timestamp
    await _secureStorageService.saveTokenPair(model);

    return Right(model.user.toDomain());
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    // Check storage for token expiry; returns true if 400s has passed
    final isExpired = await _secureStorageService.isAccessTokenExpired();
    final hasRefreshToken =
        (await _secureStorageService.getRefreshToken()) != null;

    if (isExpired && hasRefreshToken) {
      final refreshResult = await refreshToken();
      return refreshResult.fold(
        (failure) => const Right(null),
        (user) => Right(user),
      );
    }

    if (isExpired) {
      // Returning null triggers the app's 'Unauthenticated' state/redirect
      return const Right(null);
    }

    final user = await _secureStorageService.getUser();
    return Right(user?.toDomain());
  }

  @override
  Future<Either<Failure, AuthUser>> refreshToken() async {
    await Future<void>.delayed(AuthMockFixtures.delay);

    final model = LoginResponseModel.fromJson(
      AuthMockFixtures.mockRefreshedTokenResponse,
    );

    await _secureStorageService.saveTokenPair(model);
    return Right(model.user.toDomain());
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    // Wipe all local session data
    await _secureStorageService.clearAll();
    return const Right(unit);
  }

  @override
  Future<Either<Failure, (String, int?)>> resendVerificationCode({
    required String email,
  }) async {
    await Future<void>.delayed(AuthMockFixtures.delay);

    // Example responses based on different scenarios
    final random = Random();

    // Scenario 1: Valid resend (70% chance for easier testing)
    if (random.nextDouble() < 0.70) {
      return const Right((
        'Verification code sent. It will expire in 10 minutes.',
        60, // 60 seconds cooldown
      ));
    }

    // Scenario 2: Already verified (10% chance)
    if (random.nextDouble() < 0.10) {
      return const Left(AuthFailure('This account is already verified.'));
    }

    // Scenario 3: Invalid email (5% chance)
    if (random.nextDouble() < 0.05) {
      return const Left(AuthFailure('Invalid email format.'));
    }

    // Scenario 4: Resend cooldown active (10% chance)
    if (random.nextDouble() < 0.10) {
      return const Left(
        AuthFailure('Resend cooldown active. Please try again later.'),
      );
    }

    // Scenario 5: Server error (5% chance)
    return const Left(ServerFailure('Failed to resend verification code.'));
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    await Future<void>.delayed(AuthMockFixtures.delay);

    if (email.toLowerCase().contains('error')) {
      return const Left(
        AuthFailure('Unable to send reset link right now. Please try again.'),
      );
    }

    return const Right('Password recovery started.');
  }

  @override
  Future<Either<Failure, String>> resetPassword(
    String token,
    String newPassword,
  ) async {
    await Future<void>.delayed(AuthMockFixtures.delay);

    if (newPassword.contains('error')) {
      return const Left(AuthFailure('Reset failed'));
    }

    return const Right('Password reset completed.');
  }

  @override
  Future<Either<Failure, String>> verifyEmail(String token) async {
    await Future<void>.delayed(AuthMockFixtures.delay);

    if (token.isEmpty || token.contains('invalid')) {
      return const Left(AuthFailure('Invalid or expired verification token.'));
    }

    return const Right('Email verified successfully.');
  }
}
