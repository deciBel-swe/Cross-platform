import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/core/storage/secure_storage_service.dart';
import 'package:decibel/core/storage/shared_prefs_service.dart';
import 'package:decibel/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:decibel/features/auth/data/models/auth_user_model.dart';
import 'package:decibel/features/auth/data/models/device_info_model.dart';
import 'package:decibel/features/auth/data/models/login_response_model.dart';
import 'package:decibel/features/auth/data/models/refresh_token_response_model.dart';
import 'package:decibel/features/auth/data/repositories/auth_repository.dart';
import 'package:decibel/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:decibel/features/offline/data/datasources/offline_local_data_source.dart';

class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockSharedPrefsService extends Mock implements SharedPrefsService {}

class MockOfflineLocalDataSource extends Mock implements OfflineLocalDataSource {}

void main() {
  late AuthRepository repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockSecureStorageService mockSecureStorageService;
  late MockSharedPrefsService mockSharedPrefsService;
  late MockOfflineLocalDataSource mockOfflineLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockSecureStorageService = MockSecureStorageService();
    mockSharedPrefsService = MockSharedPrefsService();
    mockOfflineLocalDataSource = MockOfflineLocalDataSource();
    repository = AuthRepository(
      mockRemoteDataSource,
      mockSecureStorageService,
      mockSharedPrefsService,
      mockOfflineLocalDataSource,
    );

    registerFallbackValue(
      const DeviceInfoModel(
        deviceName: 'unknown_device',
        deviceType: 'flutter_app',
        fingerPrint: 'unknown',
      ),
    );
  });

  group('AuthRepository', () {
    const tAuthUser = AuthUser(
      id: 1,
      username: 'test_user',
      tier: UserTier.free,
      profileUrl: 'test_url',
      avatarUrl: 'test_avatar',
    );

    const tLoginResponseModel = LoginResponseModel(
      accessToken: 'access_token',
      expiresIn: 3600,
      user: AuthUserModel(
        id: 1,
        username: 'test_user',
        tier: 'free',
        profileUrl: 'test_url',
        avatarUrl: 'test_avatar',
      ),
    );

    const tRefreshTokenResponseModel = RefreshTokenResponseModel(
      accessToken: 'new_access_token',
      expiresIn: 3600,
      refreshToken: 'new_refresh_token',
    );

    test(
      'getCurrentUser should return null if access token is expired and no refresh token',
      () async {
        // Arrange
        when(
          () => mockSecureStorageService.isAccessTokenExpired(),
        ).thenAnswer((_) async => true);
        when(
          () => mockSecureStorageService.getRefreshToken(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, const Right<Failure, AuthUser?>(null));
        verify(() => mockSecureStorageService.isAccessTokenExpired()).called(1);
        verify(() => mockSecureStorageService.getRefreshToken()).called(1);
      },
    );

    test(
      'getCurrentUser should attempt refresh if access token is expired and refresh token exists',
      () async {
        // Arrange
        when(
          () => mockSecureStorageService.isAccessTokenExpired(),
        ).thenAnswer((_) async => true);
        when(
          () => mockSecureStorageService.getRefreshToken(),
        ).thenAnswer((_) async => 'refresh_token');
        when(
          () => mockSecureStorageService.getAccessToken(),
        ).thenAnswer((_) async => 'old_access_token');
        when(
          () => mockRemoteDataSource.refreshToken(
            refreshToken: 'refresh_token',
            accessToken: 'old_access_token',
          ),
        ).thenAnswer((_) async => tRefreshTokenResponseModel);
        when(
          () => mockSecureStorageService.saveRefreshTokens(
            accessToken: 'new_access_token',
            refreshToken: 'new_refresh_token',
            expiresIn: 3600,
          ),
        ).thenAnswer((_) async => {});
        when(
          () => mockSecureStorageService.getUser(),
        ).thenAnswer((_) async => tLoginResponseModel.user);
        when(
          () => mockOfflineLocalDataSource.clearAll(),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => null)?.id, tAuthUser.id);
        verify(
          () => mockRemoteDataSource.refreshToken(
            refreshToken: 'refresh_token',
            accessToken: 'old_access_token',
          ),
        ).called(1);
      },
    );

    test(
      'getCurrentUser should return null if access token is not expired AND no user in storage',
      () async {
        // Arrange
        when(
          () => mockSecureStorageService.isAccessTokenExpired(),
        ).thenAnswer((_) async => false);
        when(
          () => mockSecureStorageService.getUser(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, const Right<Failure, AuthUser?>(null));
        verify(() => mockSecureStorageService.isAccessTokenExpired()).called(1);
      },
    );

    test(
      'loginWithGoogle should return AuthUser on successful login and save tokens',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.loginWithGoogle(any()),
        ).thenAnswer((_) async => tLoginResponseModel);
        when(
          () => mockSecureStorageService.saveTokenPair(tLoginResponseModel),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.loginWithGoogle();

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should return Right'), (user) {
          expect(user.id, tAuthUser.id);
          expect(user.username, tAuthUser.username);
          expect(user.tier, tAuthUser.tier);
        });
        verify(() => mockRemoteDataSource.loginWithGoogle(any())).called(1);
        verify(
          () => mockSecureStorageService.saveTokenPair(tLoginResponseModel),
        ).called(1);
      },
    );

    test(
      'loginWithGoogle should throw ServerFailure on ServerException',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.loginWithGoogle(any()),
        ).thenThrow(const ServerException('Server error'));

        // Act
        final result = await repository.loginWithGoogle();

        // Assert
        expect(
          result,
          const Left<Failure, AuthUser>(ServerFailure('Server error')),
        );
      },
    );

    test('loginWithGoogle should throw AuthFailure on AuthException', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.loginWithGoogle(any()),
      ).thenThrow(const AuthException('Auth error'));

      // Act
      final result = await repository.loginWithGoogle();

      // Assert
      expect(result, const Left<Failure, AuthUser>(AuthFailure('Auth error')));
    });

    test(
      'logout should call remote logout, clear storage, and return unit on success',
      () async {
        // Arrange
        when(() => mockRemoteDataSource.logout()).thenAnswer((_) async {});
        when(
          () => mockSecureStorageService.clearAll(),
        ).thenAnswer((_) async => {});
        when(
          () => mockSharedPrefsService.clearAll(),
        ).thenAnswer((_) async => {});
        when(
          () => mockOfflineLocalDataSource.clearAll(),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, const Right<Failure, Unit>(unit));
        verify(() => mockRemoteDataSource.logout()).called(1);
        verify(() => mockSecureStorageService.clearAll()).called(1);
        verify(() => mockSharedPrefsService.clearAll()).called(1);
        verify(() => mockOfflineLocalDataSource.clearAll()).called(1);
      },
    );

    test(
      'logout should clear storage and return ServerFailure when backend logout fails',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.logout(),
        ).thenThrow(const ServerException('Logout failed'));
        when(
          () => mockSecureStorageService.clearAll(),
        ).thenAnswer((_) async => {});
        when(
          () => mockSharedPrefsService.clearAll(),
        ).thenAnswer((_) async => {});
        when(
          () => mockOfflineLocalDataSource.clearAll(),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.logout();

        // Assert
        expect(
          result,
          const Left<Failure, Unit>(ServerFailure('Logout failed')),
        );
        verify(() => mockRemoteDataSource.logout()).called(1);
        verify(() => mockSecureStorageService.clearAll()).called(1);
        verify(() => mockSharedPrefsService.clearAll()).called(1);
        verify(() => mockOfflineLocalDataSource.clearAll()).called(1);
      },
    );
  });
}
