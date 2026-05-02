import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/features/notifications/presentation/providers/notification_providers.dart';
import 'package:decibel/features/notifications/presentation/widgets/notification_bell_badge.dart';
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
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const Scaffold(body: NotificationBellBadge()),
            ),
            GoRoute(
              path: RoutePaths.notifications,
              builder: (_, _) => const Scaffold(body: Text('Notifications')),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('shows unread counts and caps large values', (tester) async {
    await tester.pumpWidget(app(FakeNotificationRepository(unreadCount: 120)));
    await tester.pumpAndSettle();

    expect(find.text('99+'), findsOneWidget);
  });

  testWidgets('hides the badge for zero and error states', (tester) async {
    await tester.pumpWidget(app(FakeNotificationRepository(unreadCount: 0)));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsNothing);

    await tester.pumpWidget(
      app(
        FakeNotificationRepository()
          ..unreadCountFailure = const ServerFailure('count failed'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('opens the notifications route when tapped', (tester) async {
    await tester.pumpWidget(app(FakeNotificationRepository(unreadCount: 5)));
    await tester.pumpAndSettle();

    final button = tester.widget<IconButton>(find.byType(IconButton));
    button.onPressed!();
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
  });
}
