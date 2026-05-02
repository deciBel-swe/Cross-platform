import 'package:decibel/features/notifications/domain/entities/activity_notification.dart';
import 'package:decibel/features/notifications/presentation/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../notification_test_helpers.dart';

void main() {
  Widget app(Widget child) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(body: child),
    );
  }

  bool hasRichText(WidgetTester tester, String value) {
    return tester
        .widgetList<RichText>(find.byType(RichText))
        .any((widget) => widget.text.toPlainText().contains(value));
  }

  group('NotificationCard', () {
    testWidgets('renders the action text for every notification type', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          Column(
            children: [
              NotificationCard(
                notification: activityNotification(
                  type: NotificationType.follow,
                ),
                onTap: () {},
              ),
              NotificationCard(
                notification: activityNotification(
                  id: 2,
                  type: NotificationType.like,
                  resourceType: ResourceType.track,
                ),
                onTap: () {},
              ),
              NotificationCard(
                notification: activityNotification(
                  id: 3,
                  type: NotificationType.repost,
                  resourceType: ResourceType.track,
                ),
                onTap: () {},
              ),
              NotificationCard(
                notification: activityNotification(
                  id: 4,
                  type: NotificationType.comment,
                  resourceType: ResourceType.track,
                ),
                onTap: () {},
              ),
              NotificationCard(
                notification: activityNotification(
                  id: 5,
                  type: NotificationType.reply,
                  resourceType: ResourceType.track,
                ),
                onTap: () {},
              ),
              NotificationCard(
                notification: activityNotification(
                  id: 6,
                  type: NotificationType.unknown,
                  isRead: true,
                  displayName: null,
                  username: 'fallback',
                  resourceType: ResourceType.unknown,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      expect(hasRichText(tester, 'started following you'), isTrue);
      expect(hasRichText(tester, 'liked your track'), isTrue);
      expect(hasRichText(tester, 'reposted your track'), isTrue);
      expect(hasRichText(tester, 'commented on your track'), isTrue);
      expect(hasRichText(tester, 'replied to your comment'), isTrue);
      expect(hasRichText(tester, 'interacted with your content'), isTrue);
      expect(hasRichText(tester, 'fallback'), isTrue);
    });

    testWidgets('calls onTap for user and track resources only', (
      tester,
    ) async {
      var taps = 0;

      await tester.pumpWidget(
        app(
          Column(
            children: [
              NotificationCard(
                notification: activityNotification(
                  resourceType: ResourceType.user,
                ),
                onTap: () => taps++,
              ),
              NotificationCard(
                notification: activityNotification(
                  id: 2,
                  resourceType: ResourceType.playlist,
                ),
                onTap: () => taps++,
              ),
              NotificationCard(
                notification: activityNotification(
                  id: 3,
                  resourceType: ResourceType.unknown,
                ),
                onTap: () => taps++,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(NotificationCard).at(0));
      await tester.tap(find.byType(NotificationCard).at(1));
      await tester.tap(find.byType(NotificationCard).at(2));

      expect(taps, 1);
    });

    testWidgets('renders relative time labels', (tester) async {
      await tester.pumpWidget(
        app(
          Column(
            children: [
              NotificationCard(
                notification: activityNotification(
                  createdAt: DateTime.now().subtract(
                    const Duration(minutes: 4),
                  ),
                ),
                onTap: () {},
              ),
              NotificationCard(
                notification: activityNotification(
                  id: 2,
                  createdAt: DateTime.now().subtract(const Duration(hours: 2)),
                ),
                onTap: () {},
              ),
              NotificationCard(
                notification: activityNotification(
                  id: 3,
                  createdAt: DateTime.now().subtract(const Duration(days: 3)),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.text('4m ago'), findsOneWidget);
      expect(find.text('2h ago'), findsOneWidget);
      expect(find.text('3d ago'), findsOneWidget);
    });
  });
}
