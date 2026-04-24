import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/notification_repository.dart';

/// Bridges the Injectable dependency into the Riverpod tree.
final notificationRepositoryProvider = Provider<INotificationRepository>(
  (ref) => getIt<INotificationRepository>(),
);
