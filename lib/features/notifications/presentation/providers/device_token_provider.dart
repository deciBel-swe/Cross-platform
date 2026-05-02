import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/firebase_messaging_service.dart.dart';
import '../../domain/repositories/notification_repository.dart';
import '../notifiers/notification_feed_notifier.dart';
import '../notifiers/unread_count_notifier.dart';
import 'notification_providers.dart';

final firebaseMessagingServiceProvider = Provider<FirebaseMessagingService>((
  ref,
) {
  return getIt<FirebaseMessagingService>();
});

/// Runs on app shell startup to keep the backend registration token in sync.
final syncDeviceTokenProvider = FutureProvider<void>((ref) async {
  final firebaseService = ref.watch(firebaseMessagingServiceProvider);
  final repository = ref.watch(notificationRepositoryProvider);

  final foregroundSubscription = firebaseService.onForegroundMessage.listen((
    _,
  ) {
    ref.invalidate(notificationFeedProvider);
    ref.invalidate(unreadCountProvider);
  });
  ref.onDispose(foregroundSubscription.cancel);

  final hasPermission = await firebaseService.requestPermission();
  if (!hasPermission) {
    return;
  }

  final tokenRefreshSubscription = firebaseService.onTokenRefresh.listen((
    String token,
  ) {
    unawaited(
      _syncDeviceToken(repository: repository, token: token, source: 'refresh'),
    );
  });
  ref.onDispose(tokenRefreshSubscription.cancel);

  final token = await firebaseService.getDeviceToken();
  await _syncDeviceToken(
    repository: repository,
    token: token,
    source: 'initial',
  );
});

Future<void> _syncDeviceToken({
  required INotificationRepository repository,
  required String? token,
  required String source,
}) async {
  if (token == null || token.isEmpty) {
    return;
  }

  final failure = await repository.registerDeviceToken(token);
  if (failure != null) {
    return;
  }

}
