import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/i_auth_repository.dart';

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
  const ForgotPasswordSuccess();
}

class ForgotPasswordError extends ForgotPasswordState {
  const ForgotPasswordError(this.message);

  final String message;
}

class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
  late final IAuthRepository _authRepository;

  @override
  ForgotPasswordState build() {
    _authRepository = getIt<IAuthRepository>();
    return const ForgotPasswordInitial();
  }

  Future<void> submit(String email) async {
    state = const ForgotPasswordLoading();

    final result = await _authRepository.forgotPassword(email);

    result.fold(
      (Failure failure) => state = ForgotPasswordError(failure.message),
      (_) => state = const ForgotPasswordSuccess(),
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
