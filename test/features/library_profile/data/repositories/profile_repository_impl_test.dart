import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/core/storage/secure_storage_service.dart';
import 'package:decibel/features/auth/data/models/auth_user_model.dart';
import 'package:decibel/features/library_profile/data/datasources/profile_local_data_source.dart';
import 'package:decibel/features/library_profile/data/datasources/profile_remote_data_source.dart';
import 'package:decibel/features/library_profile/data/models/user_profile_model.dart';
import 'package:decibel/features/library_profile/data/repositories/profile_repository_impl.dart';
import 'package:decibel/features/library_profile/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements IProfileRemoteDataSource {}

class MockLocalDataSource extends Mock implements IProfileLocalDataSource {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

const tProfileModel = UserProfileModel(
  id: 1,
  role: 'user',
  email: 'test@example.com',
  username: 'testuser',
  emailVerified: true,
  tier: UserTier.pro,
  profileDetails: ProfileDetailsModel(favoriteGenres: []),
  privacySettings: PrivacySettingsModel(isPrivate: false, showHistory: true),
  stats: UserStatsModel(followers: 0, following: 0, tracksCount: 0),
);

const tAuthUser = AuthUserModel(id: 1, username: 'testuser', tier: 'FREE');

void main() {
  late ProfileRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late MockSecureStorageService mockSecure;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    mockSecure = MockSecureStorageService();
    repository = ProfileRepositoryImpl(mockRemote, mockLocal, mockSecure);
    registerFallbackValue(tProfileModel);
    registerFallbackValue(tAuthUser);
  });

  group('ProfileRepositoryImpl', () {
    test(
      'getUserProfile should fetch from remote, cache, and sync auth user',
      () async {
        // Arrange
        when(
          () => mockRemote.getUserProfile(),
        ).thenAnswer((_) async => tProfileModel);
        when(
          () => mockLocal.cacheUserProfile(any()),
        ).thenAnswer((_) async => {});
        when(() => mockSecure.getUser()).thenAnswer((_) async => tAuthUser);
        when(() => mockSecure.updateUser(any())).thenAnswer((_) async => {});

        // Act
        final result = await repository.getUserProfile();

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRemote.getUserProfile()).called(1);
        verify(() => mockLocal.cacheUserProfile(tProfileModel)).called(1);
        verify(
          () => mockSecure.updateUser(
            any(that: predicate<AuthUserModel>((u) => u.tier == 'PRO')),
          ),
        ).called(1);
      },
    );

    test(
      'getUserProfile should return local cache when remote fails with NetworkException',
      () async {
        // Arrange
        when(
          () => mockRemote.getUserProfile(),
        ).thenThrow(const NetworkException('Offline'));
        when(
          () => mockLocal.getLastUserProfile(),
        ).thenAnswer((_) async => tProfileModel);

        // Act
        final result = await repository.getUserProfile();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should be Right'),
          (r) => expect(r.id, tProfileModel.id),
        );
        verify(() => mockLocal.getLastUserProfile()).called(1);
      },
    );

    test(
      'getUserProfile should return NetworkFailure when offline and no cache',
      () async {
        // Arrange
        when(
          () => mockRemote.getUserProfile(),
        ).thenThrow(const NetworkException('Offline'));
        when(
          () => mockLocal.getLastUserProfile(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getUserProfile();

        // Assert
        expect(
          result,
          const Left<NetworkFailure, UserProfile>(
            NetworkFailure('Offline and no cached profile found.'),
          ),
        );
        verify(() => mockLocal.getLastUserProfile()).called(1);
      },
    );
  });
}
