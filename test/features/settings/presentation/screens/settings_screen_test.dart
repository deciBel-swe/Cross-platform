import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('SettingsScreen renders settings destinations', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: RoutePaths.settings,
          routes: [
            GoRoute(
              path: RoutePaths.settings,
              builder: (_, _) => const SettingsScreen(),
            ),
            GoRoute(
              path: RoutePaths.accountSettings,
              builder: (_, _) => const Scaffold(body: Text('Account route')),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Basic Settings'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Social Settings'), findsOneWidget);

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(find.text('Account route'), findsOneWidget);
  });
}
