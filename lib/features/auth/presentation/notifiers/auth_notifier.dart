import 'dart:async';

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
      final user = await repo.getCurrentUser();
      if (user != null) {
        return AuthAuthenticated(user: user);
      }
    } catch (_) {
      // Ignore errors during check, fallback to unauthenticated state.
    }

    return const AuthUnauthenticated();
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);

      try {
        final user = await repo.loginWithGoogle();

        return AuthAuthenticated(user: user);
      } on AppException catch (e) {
        // Will be caught by UI async guard
        throw Exception(e.message);
      }
    });
  }

  Future<void> logout() async {
    final secureStorage = ref.read(secureStorageServiceProvider);
    await secureStorage.clearAll();

    state = const AsyncData(AuthUnauthenticated());
  }
}
