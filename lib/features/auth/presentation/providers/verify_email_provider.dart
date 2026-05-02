import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import 'auth_provider.dart';

sealed class VerifyEmailState {
  const VerifyEmailState();
}

class VerifyEmailInitial extends VerifyEmailState {
  const VerifyEmailInitial();
}

class VerifyEmailLoading extends VerifyEmailState {
  const VerifyEmailLoading();
}

class VerifyEmailSuccess extends VerifyEmailState {
  const VerifyEmailSuccess(this.message);

  final String message;
}

class VerifyEmailError extends VerifyEmailState {
  const VerifyEmailError(this.message);

  final String message;
}

class VerifyEmailNotifier extends Notifier<VerifyEmailState> {
  @override
  VerifyEmailState build() {
    return const VerifyEmailInitial();
  }

  Future<void> submit(String token) async {
    state = const VerifyEmailLoading();

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.verifyEmail(token);

    result.fold(
      (Failure failure) => state = VerifyEmailError(failure.message),
      (String message) => state = VerifyEmailSuccess(message),
    );
  }

  void reset() {
    state = const VerifyEmailInitial();
  }
}

final verifyEmailProvider =
    NotifierProvider<VerifyEmailNotifier, VerifyEmailState>(
      VerifyEmailNotifier.new,
    );
