import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/core/router/app_router.dart';
import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/domain/entities/auth_user.dart';
import 'package:decibel/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/library/domain/entities/paginated_tracks.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_edit_request.dart';
import 'package:decibel/features/library/domain/entities/track_peaks.dart';
import 'package:decibel/features/library_profile/domain/repositories/track_repository.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class MockAuthNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  MockAuthNotifier(this._initialState);
  final AuthState _initialState;

  @override
  FutureOr<AuthState> build() => _initialState;

  @override
  Future<void> loginWithGoogle() async {}

  @override
  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> registerWithEmailPassword({
    required String email,
    required String displayName,
    required String password,
    required DateTime dateOfBirth,
    required String gender,
    String? city,
    String? country,
    required String captchaToken,
  }) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<(String, int?)> resendVerificationCode({required String email}) async {
    return ('Code sent', null);
  }

  @override
  Future<void> refreshUser() async {}
}

class FakeTrackRepository implements TrackRepository {
  FakeTrackRepository({
    this.resolvedTracksByIdentifier = const <String, int>{},
  });

  final Map<String, int> resolvedTracksByIdentifier;

  @override
  Future<Either<Failure, int>> resolveTrackIdentifier(
    String trackIdentifier,
  ) async {
    final parsed = int.tryParse(trackIdentifier);
    if (parsed != null) {
      return Right(parsed);
    }

    final resolved = resolvedTracksByIdentifier[trackIdentifier];
    if (resolved != null) {
      return Right(resolved);
    }

    return Left(ServerFailure('Cannot resolve track: $trackIdentifier'));
  }

  @override
  Future<Either<Failure, bool>> deleteTrackCover(int trackId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteTrack(int trackId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Track>> fetchTrackById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PaginatedTracks>> fetchMyTracks({
    required int page,
    required int size,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TrackPeaks>> fetchTrackPeaksById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> fetchTrackStatusById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PaginatedTracks>> fetchTracks({
    required int userId,
    required int page,
    required int size,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Track>> updateTrackMetadata({
    required int trackId,
    required TrackEditRequest request,
  }) {
    throw UnimplementedError();
  }
}

/// App wrapper to test the router with a mocked state
Widget createTestApp(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, child) {
        final GoRouter router = ref.watch(appRouterProvider);
        return MaterialApp.router(
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    ),
  );
}

void main() {
  group('AppRouter Guard Tests', () {
    testWidgets(
      'should redirect to /start if unauthenticated and accessing /home',
      (tester) async {
        // Arrange: Force the AuthState to completely unauthenticated
        final container = ProviderContainer(
          overrides: [
            authStateProvider.overrideWith(
              () => MockAuthNotifier(const AuthUnauthenticated()),
            ),
          ],
        );

        await tester.pumpWidget(createTestApp(container));
        await tester.pumpAndSettle();

        final router = container.read(appRouterProvider);

        // Act: Try to navigate bypass the guard directly into /home
        router.go(RoutePaths.home);
        await tester.pumpAndSettle();

        // Assert: The RouteGuard intercepted the navigation and forced it back to /start
        final location = router.routerDelegate.currentConfiguration.uri.path;
        expect(location, equals(RoutePaths.start));
      },
    );

    testWidgets('should allow access to /home if authenticated', (
      tester,
    ) async {
      // Arrange: Force the AuthState to authenticated
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(
            () => MockAuthNotifier(
              const AuthAuthenticated(
                user: AuthUser(id: 1, username: 'test', tier: UserTier.free),
              ),
            ),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(container));
      await tester.pumpAndSettle();

      final router = container.read(appRouterProvider);

      // Act: Try to navigate to home
      router.go(RoutePaths.home);
      await tester.pumpAndSettle();

      // Assert: the Navigation successfully landed on /home
      final location = router.routerDelegate.currentConfiguration.uri.path;
      expect(location, equals(RoutePaths.home));
    });

    testWidgets(
      'should kick authenticated users out of /login directly to /home',
      (tester) async {
        // Arrange: Force the AuthState to authenticated
        final container = ProviderContainer(
          overrides: [
            authStateProvider.overrideWith(
              () => MockAuthNotifier(
                const AuthAuthenticated(
                  user: AuthUser(id: 1, username: 'test', tier: UserTier.free),
                ),
              ),
            ),
          ],
        );

        await tester.pumpWidget(createTestApp(container));
        await tester.pumpAndSettle();

        final router = container.read(appRouterProvider);

        // Act: An already authenticated user tries to open the login screen manually
        router.go(RoutePaths.login);
        await tester.pumpAndSettle();

        // Assert: The Router intercepts them and pushes them safely into /home
        final location = router.routerDelegate.currentConfiguration.uri.path;
        expect(location, equals(RoutePaths.home));
      },
    );

    testWidgets('should open deep-link profile for non-reserved username', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(
            () => MockAuthNotifier(
              const AuthAuthenticated(
                user: AuthUser(id: 1, username: 'test', tier: UserTier.free),
              ),
            ),
          ),
          trackRepositoryProvider.overrideWithValue(FakeTrackRepository()),
        ],
      );

      await tester.pumpWidget(createTestApp(container));
      await tester.pumpAndSettle();

      final router = container.read(appRouterProvider);
      router.go('/artistname');
      await tester.pumpAndSettle();

      final location = router.routerDelegate.currentConfiguration.uri.path;
      expect(location, equals(RoutePaths.publicProfile('artistname')));
    });

    testWidgets('should block reserved top-level deep-link segment', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(
            () => MockAuthNotifier(
              const AuthAuthenticated(
                user: AuthUser(id: 1, username: 'test', tier: UserTier.free),
              ),
            ),
          ),
          trackRepositoryProvider.overrideWithValue(FakeTrackRepository()),
        ],
      );

      await tester.pumpWidget(createTestApp(container));
      await tester.pumpAndSettle();

      final router = container.read(appRouterProvider);
      router.go('/user');
      await tester.pumpAndSettle();

      final location = router.routerDelegate.currentConfiguration.uri.path;
      expect(location, equals(RoutePaths.home));
    });

    testWidgets('should resolve numeric deep-link track directly', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(
            () => MockAuthNotifier(
              const AuthAuthenticated(
                user: AuthUser(id: 1, username: 'test', tier: UserTier.free),
              ),
            ),
          ),
          trackRepositoryProvider.overrideWithValue(FakeTrackRepository()),
        ],
      );

      await tester.pumpWidget(createTestApp(container));
      await tester.pumpAndSettle();

      final router = container.read(appRouterProvider);
      router.go('/artistname/123');
      await tester.pumpAndSettle();

      final location = router.routerDelegate.currentConfiguration.uri.path;
      expect(location, equals(RoutePaths.trackPreview(123)));
    });

    testWidgets('should resolve slug deep-link track via repository', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(
            () => MockAuthNotifier(
              const AuthAuthenticated(
                user: AuthUser(id: 1, username: 'test', tier: UserTier.free),
              ),
            ),
          ),
          trackRepositoryProvider.overrideWithValue(
            FakeTrackRepository(
              resolvedTracksByIdentifier: const <String, int>{
                'my-cool-track': 77,
              },
            ),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(container));
      await tester.pumpAndSettle();

      final router = container.read(appRouterProvider);
      router.go('/artistname/my-cool-track');
      await tester.pumpAndSettle();

      final location = router.routerDelegate.currentConfiguration.uri.path;
      expect(location, equals(RoutePaths.trackPreview(77)));
    });

    testWidgets('should fall back to home when track slug cannot resolve', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(
            () => MockAuthNotifier(
              const AuthAuthenticated(
                user: AuthUser(id: 1, username: 'test', tier: UserTier.free),
              ),
            ),
          ),
          trackRepositoryProvider.overrideWithValue(FakeTrackRepository()),
        ],
      );

      await tester.pumpWidget(createTestApp(container));
      await tester.pumpAndSettle();

      final router = container.read(appRouterProvider);
      router.go('/artistname/non-existent-slug');
      await tester.pumpAndSettle();

      final location = router.routerDelegate.currentConfiguration.uri.path;
      expect(location, equals(RoutePaths.home));
    });
  });
}
