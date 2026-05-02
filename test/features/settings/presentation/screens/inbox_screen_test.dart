import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/features/settings/presentation/providers/messaging_providers.dart';
import 'package:decibel/features/settings/presentation/screens/inbox_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../settings_test_helpers.dart';

void main() {
  testWidgets('InboxScreen renders conversations and opens a chat route', (
    tester,
  ) async {
    final messagingRepository = FakeMessagingRepository()
      ..conversationsPage = paginated([
        conversation(id: '1_2', lastMessage: 'hello', unreadCount: 2),
      ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          messagingRepositoryProvider.overrideWithValue(messagingRepository),
          profileRepositoryProvider.overrideWithValue(
            FakeProfileRepository(profile: userProfile(displayName: 'Friend')),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: RoutePaths.messages,
            routes: [
              GoRoute(
                path: RoutePaths.messages,
                builder: (_, _) => const InboxScreen(),
              ),
              GoRoute(
                path: '${RoutePaths.chat}/:conversationId',
                builder: (_, state) => Scaffold(
                  body: Text('Chat ${state.pathParameters['conversationId']}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Friend'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('Friend'));
    await tester.pumpAndSettle();

    expect(find.text('Chat 1_2'), findsOneWidget);
  });
}
