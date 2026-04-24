import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/i_auth_repository.dart';

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
  const ResetPasswordSuccess();
}

class ResetPasswordError extends ResetPasswordState {
  const ResetPasswordError(this.message);

  final String message;
}

class ResetPasswordNotifier extends Notifier<ResetPasswordState> {
  late final IAuthRepository _authRepository;

  @override
  ResetPasswordState build() {
    _authRepository = getIt<IAuthRepository>();
    return const ResetPasswordInitial();
  }

  Future<void> submit(String token, String newPassword) async {
    state = const ResetPasswordLoading();

    final result = await _authRepository.resetPassword(token, newPassword);

    result.fold(
      (Failure failure) => state = ResetPasswordError(failure.message),
      (_) => state = const ResetPasswordSuccess(),
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
