import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart' as g_sign_in;
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_mock_fixtures.dart';
import '../models/login_response_model.dart';

/// Mock implementation of [IAuthRepository] for testing and development.
@Environment('mock')
@LazySingleton(as: IAuthRepository)
class MockAuthRepository implements IAuthRepository {
  MockAuthRepository(this._secureStorageService);

  final SecureStorageService _secureStorageService;
  @override
  Future<Either<Failure, AuthUser>> loginWithGoogle() async {
    // Launch the REAL Google Auth URL directly to test the consent screen
    final bool isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    if (isMobile) {
      // --- MOBILE: Use official Google Sign In SDK (In-App Popup)
      final clientId = ApiConstants.googleMobileClientId;

      await g_sign_in.GoogleSignIn.instance.initialize(
        clientId: clientId,
        serverClientId: ApiConstants.googleDesktopClientId,
      );

      await g_sign_in.GoogleSignIn.instance.signOut();
      //this account will be removed when we switch to production
      g_sign_in.GoogleSignInAccount account;
      try {
        account = await g_sign_in.GoogleSignIn.instance.authenticate(
          scopeHint: ['email', 'profile'],
        );
      } catch (e) {
        return Left(AuthFailure('Google Sign-In failed or was cancelled: $e'));
      }

      // wow so this is a flag to run only in debug mode very USEFUL
      if (kDebugMode) {
        debugPrint('=== GOOGLE LOGIN SUCCESS ===');
        debugPrint('Email: ${account.email}');
        debugPrint('Display Name: ${account.displayName}');
        debugPrint('Photo URL: ${account.photoUrl}');
        debugPrint('Google ID: ${account.id}');
        debugPrint('============================');
      }

      // We don't actually need the code for mock, we just wait for delay
      await Future<void>.delayed(AuthMockFixtures.delay);
      const mockResponse = AuthMockFixtures.mockLoginResponse;
      final model = LoginResponseModel.fromJson(mockResponse);

      await _secureStorageService.saveTokenPair(model);

      return Right(model.user.toDomain());
    } else {
      // --- DESKTOP MOCK: Bypass browser and local server entirely
      await Future<void>.delayed(AuthMockFixtures.delay);
      const mockResponse = AuthMockFixtures.mockLoginResponse;
      final model = LoginResponseModel.fromJson(mockResponse);

      await _secureStorageService.saveTokenPair(model);

      return Right(model.user.toDomain());
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    final isExpired = await _secureStorageService.isAccessTokenExpired();
    if (isExpired) {
      return const Right(null);
    }

    final userModel = await _secureStorageService.getUser();
    return Right(userModel?.toDomain());
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    await _secureStorageService.clearAll();
    return const Right(unit);
  }
}
