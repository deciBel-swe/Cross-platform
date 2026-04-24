import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import 'auth_provider.dart';

sealed class ForgotPasswordState {
  const ForgotPasswordState();
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  const ForgotPasswordSuccess(this.message);

  final String message;
}

class ForgotPasswordError extends ForgotPasswordState {
  const ForgotPasswordError(this.message);

  final String message;
}

class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
  @override
  ForgotPasswordState build() {
    return const ForgotPasswordInitial();
  }

  Future<void> submit(String email) async {
    state = const ForgotPasswordLoading();

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.forgotPassword(email);

    result.fold(
      (Failure failure) => state = ForgotPasswordError(failure.message),
      (String message) => state = ForgotPasswordSuccess(message),
    );
  }

  void clearError() {
    if (state is ForgotPasswordError) {
      state = const ForgotPasswordInitial();
    }
  }

  void reset() {
    state = const ForgotPasswordInitial();
  }
}

final forgotPasswordProvider =
    NotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
      ForgotPasswordNotifier.new,
    );
