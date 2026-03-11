import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:decibel/core/router/app_router.dart';
import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/domain/entities/auth_user.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/auth/presentation/notifiers/auth_notifier.dart';

class MockAuthNotifier extends AsyncNotifier<AuthState>
    implements AuthNotifier {
  MockAuthNotifier(this._initialState);
  final AuthState _initialState;

  @override
  FutureOr<AuthState> build() => _initialState;

  @override
  Future<void> loginWithGoogle() async {}

  @override
  Future<void> logout() async {}
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
      'should redirect to /login if unauthenticated and accessing /home',
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

        // Assert: The RouteGuard intercepted the navigation and forced it back to /login
        final location = router.routerDelegate.currentConfiguration.uri.path;
        expect(location, equals(RoutePaths.login));
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
  });
}
