import 'package:decibel/features/settings/presentation/widgets/inbox/inbox_app_bar.dart';
import 'package:decibel/features/settings/presentation/widgets/inbox/inbox_avatar_text.dart';
import 'package:decibel/features/settings/presentation/widgets/inbox/inbox_empty_state.dart';
import 'package:decibel/features/settings/presentation/widgets/inbox/inbox_loading_tile.dart';
import 'package:decibel/features/settings/presentation/widgets/inbox/inbox_new_message_fab.dart';
import 'package:decibel/features/settings/presentation/widgets/inbox/inbox_time_ago.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Widget app(Widget child) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(body: child),
    );
  }

  group('inbox widgets', () {
    test('buildInboxAvatarText returns an initial or fallback', () {
      expect(buildInboxAvatarText(' Alice '), 'A');
      expect(buildInboxAvatarText(''), '?');
    });

    test('formatInboxTimeAgo returns compact relative labels', () {
      final now = DateTime.now();

      expect(formatInboxTimeAgo(now.add(const Duration(minutes: 1))), 'Now');
      expect(
        formatInboxTimeAgo(now.subtract(const Duration(minutes: 3))),
        '3m',
      );
      expect(formatInboxTimeAgo(now.subtract(const Duration(hours: 2))), '2h');
      expect(formatInboxTimeAgo(now.subtract(const Duration(days: 4))), '4d');
    });

    testWidgets('InboxAppBar renders the direct messages title', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(appBar: InboxAppBar()),
        ),
      );

      expect(find.text('Direct Messages'), findsOneWidget);
    });

    testWidgets('InboxEmptyState renders empty inbox copy', (tester) async {
      await tester.pumpWidget(app(const InboxEmptyState()));

      expect(find.text('No messages yet.'), findsOneWidget);
    });

    testWidgets('InboxLoadingTile renders loading placeholders', (
      tester,
    ) async {
      await tester.pumpWidget(app(const InboxLoadingTile()));

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.text('Loading profile...'), findsOneWidget);
    });

    testWidgets('InboxNewMessageFab navigates to the new message route', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) =>
                const Scaffold(floatingActionButton: InboxNewMessageFab()),
          ),
          GoRoute(
            path: '/messages/new',
            builder: (_, _) => const Scaffold(body: Text('New message page')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('New message page'), findsOneWidget);
    });
  });
}
