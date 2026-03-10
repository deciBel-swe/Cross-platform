import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../models/login_response_model.dart';
import '../datasources/auth_mock_fixtures.dart';

/// Mock implementation of [IAuthRepository] for testing and development.
@Environment('mock')
@LazySingleton(as: IAuthRepository)
class MockAuthRepository implements IAuthRepository {
  @override
  Future<AuthUser> loginWithGoogle() async {
    // Simulate network latency
    await Future.delayed(AuthMockFixtures.delay);

    final mockResponse = AuthMockFixtures.mockLoginResponse;
    final model = LoginResponseModel.fromJson(mockResponse);

    return model.user.toDomain();
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    // Simulate reading from local storage without delay
    // Note: In Phase 4, this will be tied to SecureStorageService.
    final mockResponse = AuthMockFixtures.mockLoginResponse;
    final model = LoginResponseModel.fromJson(mockResponse);

    return model.user.toDomain();
  }
}
