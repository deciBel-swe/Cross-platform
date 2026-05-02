import 'package:decibel/features/settings/presentation/providers/notification_settings_provider.dart';
import 'package:decibel/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  testWidgets('NotificationSettingsScreen renders toggles and updates one', (
    tester,
  ) async {
    final repository = FakeNotificationSettingsRepository();

    await tester.pumpWidget(
      settingsTestApp(
        const NotificationSettingsScreen(),
        overrides: [
          notificationSettingsRepositoryProvider.overrideWithValue(repository),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New Followers'), findsOneWidget);
    expect(find.text('Direct Messages'), findsOneWidget);

    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pumpAndSettle();

    expect(repository.updates.single.notifyOnFollow, isFalse);
  });
}
