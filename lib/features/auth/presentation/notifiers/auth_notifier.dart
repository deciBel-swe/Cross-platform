import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/auth_state.dart';
import '../providers/auth_provider.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  FutureOr<AuthState> build() async {
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
      // Ignore errors during check, fallback to unauthenticated state.
    }

    return const AuthUnauthenticated();
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
        throw Exception(e.message);
      } catch (e, st) {
        debugPrint('[AuthNotifier] Unexpected Exception: $e\n$st');
        throw Exception(e.toString());
      }
    });

    debugPrint('[AuthNotifier] State is now: $state');
  }

  Future<void> logout() async {
    final secureStorage = ref.read(secureStorageServiceProvider);
    await secureStorage.clearAll();

    state = const AsyncData(AuthUnauthenticated());
  }

  Future<void> handleWebViewLoginSuccess({
    required String accessToken,
    required String refreshToken,
  }) async {
    final secureStorage = ref.read(secureStorageServiceProvider);
    final repo = ref.read(authRepositoryProvider);

    state = const AsyncLoading();

    try {
      await secureStorage.saveRawTokenPair(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      final userEither = await repo.getCurrentUser();

      final authState = userEither.fold<AuthState>(
        (failure) => throw Exception(failure.message),
        (user) {
          if (user != null) {
            return AuthAuthenticated(user: user);
          }
          return const AuthUnauthenticated();
        },
      );

      state = AsyncData(authState);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}