import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repositories/change_email_repository.dart';
import '../notifiers/change_email_notifier.dart';

final changeEmailRepositoryProvider = Provider<ChangeEmailRepository>((_) {
  return getIt<ChangeEmailRepository>();
});
final changeEmailProvider =
    NotifierProvider<ChangeEmailNotifier, ChangeEmailState>(
      ChangeEmailNotifier.new,
    );

