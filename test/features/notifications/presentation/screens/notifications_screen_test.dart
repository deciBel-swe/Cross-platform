import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/features/notifications/domain/entities/activity_notification.dart';
import 'package:decibel/features/notifications/presentation/notifiers/notification_feed_notifier.dart';
import 'package:decibel/features/notifications/presentation/providers/notification_providers.dart';
import 'package:decibel/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:decibel/features/notifications/presentation/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../notification_test_helpers.dart';

void main() {
  Widget app(FakeNotificationRepository repository) {
    return ProviderScope(
      overrides: [notificationRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: RoutePaths.notifications,
          routes: [
            GoRoute(
              path: RoutePaths.notifications,
              builder: (_, _) => const NotificationsScreen(),
            ),
            GoRoute(
              path: '${RoutePaths.publicProfileBase}/:id',
              builder: (_, state) =>
                  Scaffold(body: Text('User ${state.pathParameters['id']}')),
            ),
            GoRoute(
              path: '${RoutePaths.trackPreviewBase}/:trackId',
              builder: (_, state) => Scaffold(
                body: Text('Track ${state.pathParameters['trackId']}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('renders empty state when there are no notifications', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(FakeNotificationRepository(pages: {0: const []})),
    );
    await tester.pumpAndSettle();

    expect(find.text('No notifications yet.'), findsOneWidget);
  });

  testWidgets('renders error state when the feed fails', (tester) async {
    await tester.pumpWidget(
      app(
        FakeNotificationRepository()
          ..getNotificationsFailure = const ServerFailure('feed failed'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('feed failed'), findsOneWidget);
  });

  testWidgets('renders notifications and marks all as read', (tester) async {
    final repository = FakeNotificationRepository(
      pages: {
        0: [
          activityNotification(id: 1, isRead: false),
          activityNotification(
            id: 2,
            type: NotificationType.like,
            resourceType: ResourceType.track,
            resourceId: 44,
            isRead: false,
          ),
        ],
      },
      unreadCount: 2,
    );

    await tester.pumpWidget(app(repository));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('started following you', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('liked your track', findRichText: true),
      findsOneWidget,
    );

    await tester.tap(find.text('Mark all as read'));
    await tester.pumpAndSettle();

    expect(repository.markAllCalls, 1);
  });

  testWidgets('navigates to user destinations', (tester) async {
    await tester.pumpWidget(
      app(
        FakeNotificationRepository(
          pages: {
            0: [
              activityNotification(
                id: 1,
                resourceType: ResourceType.user,
                resourceId: 12,
              ),
            ],
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(NotificationCard).first);
    await tester.pumpAndSettle();

    expect(find.text('User 12'), findsOneWidget);
  });

  testWidgets('navigates to track destinations', (tester) async {
    await tester.pumpWidget(
      app(
        FakeNotificationRepository(
          pages: {
            0: [
              activityNotification(
                id: 2,
                type: NotificationType.like,
                resourceType: ResourceType.track,
                resourceId: 44,
              ),
            ],
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(NotificationCard).first);
    await tester.pumpAndSettle();

    expect(find.text('Track 44'), findsOneWidget);
  });

  testWidgets('fetches the next page when scrolled near the bottom', (
    tester,
  ) async {
    final repository = FakeNotificationRepository(
      pages: {
        0: List<ActivityNotification>.generate(
          20,
          (index) => activityNotification(id: index + 1, username: 'u$index'),
        ),
        1: [
          activityNotification(
            id: 99,
            username: 'last_user',
            displayName: 'Last User',
          ),
        ],
      },
    );

    await tester.pumpWidget(app(repository));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -3000));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(NotificationsScreen)),
    );
    expect(
      container
          .read(notificationFeedProvider)
          .value
          ?.notifications
          .map((item) => item.id),
      contains(99),
    );
  });
}
