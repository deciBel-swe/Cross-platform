import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/notifications/presentation/notifiers/unread_count_notifier.dart';
import 'package:decibel/features/notifications/presentation/providers/notification_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../notification_test_helpers.dart';

void main() {
  group('UnreadCountNotifier', () {
    test('build returns the unread count from the repository', () async {
      final repository = FakeNotificationRepository(unreadCount: 8);
      final container = ProviderContainer(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      expect(await container.read(unreadCountProvider.future), 8);
    });

    test('build exposes repository failures as AsyncError', () async {
      final repository = FakeNotificationRepository()
        ..unreadCountFailure = const ServerFailure('count failed');
      final container = ProviderContainer(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(unreadCountProvider.future),
        throwsA(isA<Exception>()),
      );
      expect(container.read(unreadCountProvider).hasError, isTrue);
    });

    test('clearBadge sets the unread count to zero locally', () async {
      final repository = FakeNotificationRepository(unreadCount: 8);
      final container = ProviderContainer(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(unreadCountProvider.future);
      container.read(unreadCountProvider.notifier).clearBadge();

      expect(container.read(unreadCountProvider).value, 0);
    });
  });
}
