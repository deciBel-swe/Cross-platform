import 'dart:convert';
import 'package:decibel/core/storage/secure_storage_service.dart';
import 'package:decibel/features/library_profile/data/datasources/profile_local_data_source.dart';
import 'package:decibel/features/library_profile/data/models/user_profile_model.dart';
import 'package:decibel/features/library_profile/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late ProfileLocalDataSource dataSource;
  late MockSecureStorageService mockSecureStorageService;

  setUp(() {
    mockSecureStorageService = MockSecureStorageService();
    dataSource = ProfileLocalDataSource(mockSecureStorageService);
  });

  group('ProfileLocalDataSource', () {
    const tProfile = UserProfileModel(
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

    test('cacheUserProfile should save profile to secure storage', () async {
      when(() => mockSecureStorageService.setString(any(), any()))
          .thenAnswer((_) async => {});

      await dataSource.cacheUserProfile(tProfile);

      verify(() => mockSecureStorageService.setString(
            'cached_user_profile',
            jsonEncode(tProfile.toJson()),
          )).called(1);
    });

    test('getLastUserProfile should return cached profile', () async {
      when(() => mockSecureStorageService.getString('cached_user_profile'))
          .thenAnswer((_) async => jsonEncode(tProfile.toJson()));

      final result = await dataSource.getLastUserProfile();

      expect(result, tProfile);
    });

    test('getLastUserProfile should return null if no cache', () async {
      when(() => mockSecureStorageService.getString('cached_user_profile'))
          .thenAnswer((_) async => null);

      final result = await dataSource.getLastUserProfile();

      expect(result, isNull);
    });

    test('clearCache should remove string from storage', () async {
      when(() => mockSecureStorageService.removeString('cached_user_profile'))
          .thenAnswer((_) async => {});

      await dataSource.clearCache();

      verify(() => mockSecureStorageService.removeString('cached_user_profile')).called(1);
    });
  });
}
