import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/features/settings/presentation/providers/blocked_users_provider.dart';
import 'package:decibel/features/settings/presentation/screens/blocked_users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../settings_test_helpers.dart';

void main() {
  testWidgets('BlockedUsersScreen loads blocked users and can unblock one', (
    tester,
  ) async {
    final repository = FakeBlockedUsersRepository(
      pages: {
        0: blockedUsersPage([blockedUser(id: 2, username: 'blocked')]),
      },
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          blockedUsersRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: RoutePaths.blockedUsers,
            routes: [
              GoRoute(
                path: RoutePaths.blockedUsers,
                builder: (_, _) => const BlockedUsersScreen(),
              ),
              GoRoute(
                path: '${RoutePaths.publicProfileBase}/:id',
                builder: (_, state) => Scaffold(
                  body: Text('Profile ${state.pathParameters['id']}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('blocked'), findsOneWidget);
    await tester.tap(find.text('Unblock'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Unblock').last);
    await tester.pumpAndSettle();

    expect(repository.unblockedIds, [2]);
    expect(find.textContaining('successfully'), findsOneWidget);
  });
}
