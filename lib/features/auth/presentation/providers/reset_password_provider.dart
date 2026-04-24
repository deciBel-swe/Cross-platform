import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import 'auth_provider.dart';

sealed class ResetPasswordState {
  const ResetPasswordState();
}

class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading();
}

class ResetPasswordSuccess extends ResetPasswordState {
  const ResetPasswordSuccess(this.message);

  final String message;
}

class ResetPasswordError extends ResetPasswordState {
  const ResetPasswordError(this.message);

  final String message;
}

class ResetPasswordNotifier extends Notifier<ResetPasswordState> {
  @override
  ResetPasswordState build() {
    return const ResetPasswordInitial();
  }

  Future<void> submit(String token, String newPassword) async {
    state = const ResetPasswordLoading();

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.resetPassword(token, newPassword);

    result.fold(
      (Failure failure) => state = ResetPasswordError(failure.message),
      (String message) => state = ResetPasswordSuccess(message),
    );
  }

  void clearError() {
    if (state is ResetPasswordError) {
      state = const ResetPasswordInitial();
    }
  }

  void reset() {
    state = const ResetPasswordInitial();
  }
}

final resetPasswordProvider =
    NotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
      ResetPasswordNotifier.new,
    );
