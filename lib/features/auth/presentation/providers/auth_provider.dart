import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../notifiers/auth_notifier.dart';
import '../notifiers/resend_timer_notifier.dart';

final authRepositoryProvider = Provider<IAuthRepository>((_) {
  return getIt<IAuthRepository>();
});

final secureStorageServiceProvider = Provider<SecureStorageService>((_) {
  return getIt<SecureStorageService>();
});

final authStateProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final resendTimerProvider = NotifierProvider<ResendTimerNotifier, int>(
  ResendTimerNotifier.new,
);
