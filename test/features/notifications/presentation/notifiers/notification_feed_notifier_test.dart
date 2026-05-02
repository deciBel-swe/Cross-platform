import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/notifications/domain/entities/activity_notification.dart';
import 'package:decibel/features/notifications/presentation/notifiers/notification_feed_notifier.dart';
import 'package:decibel/features/notifications/presentation/notifiers/unread_count_notifier.dart';
import 'package:decibel/features/notifications/presentation/providers/notification_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../notification_test_helpers.dart';

void main() {
  group('NotificationFeedNotifier', () {
    test(
      'build loads initial notifications and detects the last page',
      () async {
        final repository = FakeNotificationRepository(
          pages: {
            0: [
              activityNotification(id: 1),
              activityNotification(id: 2, type: NotificationType.like),
            ],
          },
        );
        final container = ProviderContainer(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        final state = await container.read(notificationFeedProvider.future);

        expect(state.notifications.map((item) => item.id), [1, 2]);
        expect(state.currentPage, 0);
        expect(state.isLastPage, isTrue);
      },
    );

    test('build exposes errors from the repository', () async {
      final repository = FakeNotificationRepository()
        ..getNotificationsFailure = const ServerFailure('feed failed');
      final container = ProviderContainer(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(notificationFeedProvider.future),
        throwsA(isA<Exception>()),
      );
      expect(container.read(notificationFeedProvider).hasError, isTrue);
    });

    test(
      'fetchNextPage appends data and clears bottom loading state',
      () async {
        final firstPage = List<ActivityNotification>.generate(
          20,
          (index) => activityNotification(id: index + 1),
        );
        final repository = FakeNotificationRepository(
          pages: {
            0: firstPage,
            1: [activityNotification(id: 21, type: NotificationType.comment)],
          },
        );
        final container = ProviderContainer(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(notificationFeedProvider.future);
        await container.read(notificationFeedProvider.notifier).fetchNextPage();

        final state = container.read(notificationFeedProvider).value!;
        expect(state.notifications.length, 21);
        expect(state.notifications.last.id, 21);
        expect(state.currentPage, 1);
        expect(state.isLastPage, isTrue);
        expect(state.isFetchingNextPage, isFalse);
      },
    );

    test(
      'fetchNextPage quietly reverts loading state when the page fails',
      () async {
        final repository = FakeNotificationRepository(
          pages: {
            0: List<ActivityNotification>.generate(
              20,
              (index) => activityNotification(id: index + 1),
            ),
          },
        );
        final container = ProviderContainer(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(notificationFeedProvider.future);
        repository.getNotificationsFailure = const ServerFailure('page failed');
        await container.read(notificationFeedProvider.notifier).fetchNextPage();

        final state = container.read(notificationFeedProvider).value!;
        expect(state.notifications.length, 20);
        expect(state.currentPage, 0);
        expect(state.isFetchingNextPage, isFalse);
      },
    );

    test(
      'markAllAsRead clears unread badge and updates local notifications',
      () async {
        final repository = FakeNotificationRepository(
          pages: {
            0: [
              activityNotification(id: 1, isRead: false),
              activityNotification(id: 2, isRead: false),
            ],
          },
          unreadCount: 5,
        );
        final container = ProviderContainer(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(notificationFeedProvider.future);
        await container.read(unreadCountProvider.future);
        await container.read(notificationFeedProvider.notifier).markAllAsRead();

        expect(repository.markAllCalls, 1);
        expect(container.read(unreadCountProvider).value, 0);
        expect(
          container
              .read(notificationFeedProvider)
              .value!
              .notifications
              .every((item) => item.isRead),
          isTrue,
        );
      },
    );

    test('markAllAsRead keeps local state when backend fails', () async {
      final repository = FakeNotificationRepository(
        pages: {
          0: [activityNotification(id: 1, isRead: false)],
        },
      )..markAllFailure = const ServerFailure('cannot mark');
      final container = ProviderContainer(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(notificationFeedProvider.future);
      await container.read(notificationFeedProvider.notifier).markAllAsRead();

      expect(
        container
            .read(notificationFeedProvider)
            .value!
            .notifications
            .single
            .isRead,
        isFalse,
      );
    });
  });
}
