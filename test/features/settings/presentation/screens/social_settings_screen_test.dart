import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/features/settings/presentation/providers/social_settings_provider.dart';
import 'package:decibel/features/settings/presentation/screens/social_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../settings_test_helpers.dart';

void main() {
  testWidgets('SocialSettingsScreen renders toggles and opens blocked users', (
    tester,
  ) async {
    final repository = FakeSocialSettingsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          socialSettingsRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: RoutePaths.socialSettings,
            routes: [
              GoRoute(
                path: RoutePaths.socialSettings,
                builder: (_, _) => const SocialSettingsScreen(),
              ),
              GoRoute(
                path: RoutePaths.blockedUsers,
                builder: (_, _) => const Scaffold(body: Text('Blocked route')),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Private Profile'), findsOneWidget);
    expect(find.text('Show Listening History'), findsOneWidget);

    await tester.tap(find.text('Blocked users'));
    await tester.pumpAndSettle();

    expect(find.text('Blocked route'), findsOneWidget);
  });
}
