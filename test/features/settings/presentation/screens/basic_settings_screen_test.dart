import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/features/settings/presentation/screens/basic_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('BasicSettingsScreen opens the change app icon route', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: RoutePaths.basicSettings,
          routes: [
            GoRoute(
              path: RoutePaths.basicSettings,
              builder: (_, _) => const BasicSettingsScreen(),
            ),
            GoRoute(
              path: RoutePaths.changeAppIcon,
              builder: (_, _) => const Scaffold(body: Text('Change icon')),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Basic Settings'), findsOneWidget);
    await tester.tap(find.text('Change app icon'));
    await tester.pumpAndSettle();

    expect(find.text('Change icon'), findsOneWidget);
  });
}
