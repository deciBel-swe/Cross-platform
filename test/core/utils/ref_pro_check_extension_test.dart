import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/core/utils/ref_pro_check_extension.dart';
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/domain/entities/auth_user.dart' as auth;
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/library_profile/domain/entities/user_profile.dart';
import 'package:decibel/features/library_profile/presentation/providers/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWidgetRef extends Mock implements WidgetRef {}

void main() {
  late MockWidgetRef mockRef;

  setUp(() {
    mockRef = MockWidgetRef();
  });

  group('RefProCheckX', () {
    const tProfile = UserProfile(
      id: 1,
      role: 'user',
      email: 'test@example.com',
      username: 'testuser',
      emailVerified: true,
      tier: UserTier.pro,
      profileDetails: UserProfileDetails(favoriteGenres: []),
      privacySettings: PrivacySettings(isPrivate: false, showHistory: true),
      stats: UserStats(followers: 0, following: 0, tracksCount: 0),
    );

    const tAuthUser = auth.AuthUser(
      id: 1,
      username: 'testuser',
      tier: auth.UserTier.pro,
    );

    test('isPro should return true if userProfileProvider has pro tier', () {
      when(
        () => mockRef.watch(userProfileProvider),
      ).thenReturn(const AsyncData(Right(tProfile)));

      expect(mockRef.isPro, isTrue);
    });

    test(
      'isPro should return true if userProfileProvider fails but authStateProvider has pro tier',
      () {
        when(
          () => mockRef.watch(userProfileProvider),
        ).thenReturn(const AsyncData(Left(ServerFailure('Error'))));
        when(
          () => mockRef.watch(authStateProvider),
        ).thenReturn(const AsyncData(AuthAuthenticated(user: tAuthUser)));

        expect(mockRef.isPro, isTrue);
      },
    );

    test('isPro should return false if both say free tier', () {
      when(() => mockRef.watch(userProfileProvider)).thenReturn(
        const AsyncData(
          Right(
            UserProfile(
              id: 1,
              role: 'user',
              email: 'test@example.com',
              username: 'testuser',
              emailVerified: true,
              tier: UserTier.free,
              profileDetails: UserProfileDetails(favoriteGenres: []),
              privacySettings: PrivacySettings(
                isPrivate: false,
                showHistory: true,
              ),
              stats: UserStats(followers: 0, following: 0, tracksCount: 0),
            ),
          ),
        ),
      );

      when(() => mockRef.watch(authStateProvider)).thenReturn(
        const AsyncData(
          AuthAuthenticated(
            user: auth.AuthUser(
              id: 1,
              username: 'testuser',
              tier: auth.UserTier.free,
            ),
          ),
        ),
      );

      expect(mockRef.isPro, isFalse);
    });

    test('isPro should return false if loading and unauthenticated', () {
      when(
        () => mockRef.watch(userProfileProvider),
      ).thenReturn(const AsyncLoading());
      when(
        () => mockRef.watch(authStateProvider),
      ).thenReturn(const AsyncData(AuthUnauthenticated()));

      expect(mockRef.isPro, isFalse);
    });
  });
}
