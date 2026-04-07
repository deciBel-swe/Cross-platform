import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/events/auth_event_bus.dart';
import '../../domain/entities/auth_state.dart';
import '../providers/auth_provider.dart';

/// Manages the authentication state of the application.
///
/// This notifier acts as the central hub for all authentication related
/// business logic. It communicates with the [IAuthRepository] to perform
/// network operations (like Google Sign-In) and the [SecureStorageService]
/// to manage local session tokens.
///
/// **Responsibilities:**
/// * **Initialization:** During [build], it checks for an existing, unexpired
///   session in secure storage and automatically logs the user in if valid.
/// * **Authentication:** Provides [loginWithGoogle] to initiate the OAuth flow
///   and securely update the state upon success or failure.
/// * **Session Management:** Provides [logout] to invalidate the backend
///   session and return the user to an unauthenticated state.
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  FutureOr<AuthState> build() async {
    // Listen for forced logouts from interceptors or other backend-driven events
    final logoutSub = AuthEventBus().logoutStream.listen((_) {
      debugPrint(
        '[AuthNotifier] Received forced logout event from AuthEventBus',
      );
      logout();
    });

    ref.onDispose(() {
      logoutSub.cancel();
    });

    final secureStorage = ref.watch(secureStorageServiceProvider);
    final repo = ref.watch(authRepositoryProvider);

    final isExpired = await secureStorage.isAccessTokenExpired();
    if (isExpired) {
      return const AuthUnauthenticated();
    }

    try {
      final userEither = await repo.getCurrentUser();
      return userEither.fold((failure) => const AuthUnauthenticated(), (user) {
        if (user != null) {
          return AuthAuthenticated(user: user);
        }
        return const AuthUnauthenticated();
      });
    } catch (_) {
      return const AuthUnauthenticated();
    }
  }

  Future<void> loginWithGoogle() async {
    debugPrint('[AuthNotifier] loginWithGoogle() started.');
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);

      try {
        debugPrint('[AuthNotifier] calling repo.loginWithGoogle()...');
        final userEither = await repo.loginWithGoogle();

        return userEither.fold(
          (failure) {
            debugPrint('[AuthNotifier] Failure: ${failure.message}');
            throw Exception(failure.message);
          },
          (user) {
            debugPrint(
              '[AuthNotifier] repo.loginWithGoogle() succeeded! User: ${user.username} (ID: ${user.id}, Tier: ${user.tier.name})',
            );
            return AuthAuthenticated(user: user);
          },
        );
      } on AppException catch (e) {
        debugPrint('[AuthNotifier] AppException: ${e.message}');
        // Will be caught by UI async guard
        throw Exception(e.message);
      } catch (e, st) {
        debugPrint('[AuthNotifier] Unexpected Exception: $e\n$st');
        throw Exception(e.toString());
      }
    });

    // If the login failed, recover to unauthenticated state so the router
    // can redirect back to the start/login screen instead of staying on splash.
    if (state.hasError) {
      state = const AsyncData(AuthUnauthenticated());
    }

    debugPrint('[AuthNotifier] State is now: $state');
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);

      final userEither = await repo.loginWithEmailPassword(
        email: email,
        password: password,
      );

      return userEither.fold(
        (failure) => throw Exception(failure.message),
        (user) => AuthAuthenticated(user: user),
      );
    });

    if (state.hasError) {
      state = const AsyncData(AuthUnauthenticated());
    }
  }

  Future<void> registerWithEmailPassword({
    required String email,
    required String username,
    required String password,
    required DateTime dateOfBirth,
    required String gender,
    String? city,
    String? country,
    required String captchaToken,
  }) async {
    final repo = ref.read(authRepositoryProvider);

    final registerEither = await repo.registerWithEmailPassword(
      email: email,
      username: username,
      password: password,
      dateOfBirth: dateOfBirth,
      gender: gender,
      city: city,
      country: country,
      captchaToken: captchaToken,
    );

    registerEither.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);

    try {
      final logoutResult = await repo.logout();
      logoutResult.fold(
        (failure) =>
            debugPrint('[AuthNotifier] logout failed: ${failure.message}'),
        (_) => debugPrint('[AuthNotifier] logout succeeded.'),
      );
    } catch (e, st) {
      debugPrint('[AuthNotifier] Unexpected Exception during logout: $e\n$st');
    } finally {
      state = const AsyncData(AuthUnauthenticated());
    }
  }
}
