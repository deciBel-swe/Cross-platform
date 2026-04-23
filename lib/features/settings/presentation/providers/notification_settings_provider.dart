import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/notification_settings_repository.dart';

final notificationSettingsRepositoryProvider =
    Provider<NotificationSettingsRepository>((_) {
  return getIt<NotificationSettingsRepository>();
});
