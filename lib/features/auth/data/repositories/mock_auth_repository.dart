import 'dart:async';

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
    final hasRefreshToken = (await _secureStorageService.getRefreshToken()) != null;

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
}
