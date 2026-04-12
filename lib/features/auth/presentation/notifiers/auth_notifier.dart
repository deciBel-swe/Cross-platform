import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_reset_provider.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/events/auth_event_bus.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/i_auth_repository.dart';
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

    try {
      final secureStorage = ref.watch(secureStorageServiceProvider);
      final repo = ref.watch(authRepositoryProvider);

      final hasRefreshToken = await secureStorage.getRefreshToken() != null;
      if (!hasRefreshToken) {
        return const AuthUnauthenticated();
      }

      final userEither = await repo.getCurrentUser();
      return userEither.fold((failure) => const AuthUnauthenticated(), (user) {
        if (user != null) {
          return AuthAuthenticated(user: user);
        }
        return const AuthUnauthenticated();
      });
    } catch (e, st) {
      debugPrint('[AuthNotifier] build() failed: $e\n$st');
      return const AuthUnauthenticated();
    }
  }

  Future<void> refreshUser() async {
    final currentVal = state.valueOrNull;
    if (currentVal is AuthAuthenticated) {
      final repo = ref.read(authRepositoryProvider);
      final userEither = await repo.getCurrentUser();
      userEither.fold(
        (failure) {}, // ignore failure
        (user) {
          if (user != null) {
            state = AsyncData(AuthAuthenticated(user: user));
          }
        },
      );
    }
  }

  Future<void> loginWithGoogle() async {
    debugPrint('[AuthNotifier] loginWithGoogle() started.');
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);

      debugPrint('[AuthNotifier] calling repo.loginWithGoogle()...');
      final userEither = await repo.loginWithGoogle();

      final user = userEither.fold(
        (failure) {
          debugPrint('[AuthNotifier] Failure: ${failure.message}');
          throw Exception(failure.message);
        },
        (user) {
          debugPrint(
            '[AuthNotifier] repo.loginWithGoogle() succeeded! User: ${user.username} (ID: ${user.id}, Tier: ${user.tier.name})',
          );
          return user;
        },
      );

      state = AsyncData(AuthAuthenticated(user: user));
    } on AppException catch (e) {
      debugPrint('[AuthNotifier] AppException: ${e.message}');
      state = const AsyncData(AuthUnauthenticated());
      throw Exception(e.message);
    } catch (e, st) {
      debugPrint('[AuthNotifier] Unexpected Exception: $e\n$st');
      state = const AsyncData(AuthUnauthenticated());
      throw Exception(e.toString());
    }

    debugPrint('[AuthNotifier] State is now: $state');
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);

      final userEither = await repo.loginWithEmailPassword(
        email: email,
        password: password,
      );

      final user = userEither.fold(
        (failure) => throw Exception(failure.message),
        (user) => user,
      );

      state = AsyncData(AuthAuthenticated(user: user));
    } catch (e) {
      state = const AsyncData(AuthUnauthenticated());
      rethrow;
    }
  }

  Future<void> registerWithEmailPassword({
    required String email,
    required String displayName,
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
      displayName: displayName,
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
        (_) async {
          debugPrint('[AuthNotifier] logout succeeded.');
          await _invalidateUserCaches();
        },
      );
    } catch (e, st) {
      debugPrint('[AuthNotifier] Unexpected Exception during logout: $e\n$st');
      await _invalidateUserCaches();
    } finally {
      state = const AsyncData(AuthUnauthenticated());
    }
  }

  Future<void> _invalidateUserCaches() async {
    debugPrint('[AuthNotifier] Triggering global state reset...');
    // Forces a total destruction and recreation of the ProviderScope.
    await ref.read(appResetProvider.notifier).reset();
  }
}
