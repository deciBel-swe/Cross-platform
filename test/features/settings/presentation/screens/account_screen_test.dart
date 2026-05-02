import 'package:decibel/features/library_profile/presentation/notifiers/user_profile_notifier.dart'
    as profile_notifier;
import 'package:decibel/features/settings/presentation/providers/change_email_provider.dart';
import 'package:decibel/features/settings/presentation/screens/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../settings_test_helpers.dart';

void main() {
  testWidgets('AccountScreen renders the email and validates editing', (
    tester,
  ) async {
    final changeEmailRepository = FakeChangeEmailRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profile_notifier.profileRepositoryProvider.overrideWithValue(
            FakeProfileRepository(
              profile: userProfile(email: 'listener@example.com'),
            ),
          ),
          changeEmailRepositoryProvider.overrideWithValue(
            changeEmailRepository,
          ),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const AccountScreen()),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('listener@example.com'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'bad-email');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(find.textContaining('email'), findsWidgets);
  });

  testWidgets('AccountScreen shows confirmation for a valid email change', (
    tester,
  ) async {
    final changeEmailRepository = FakeChangeEmailRepository()
      ..response = 'Check your inbox';

    await tester.pumpWidget(
      settingsTestApp(
        const AccountScreen(),
        overrides: [
          profile_notifier.profileRepositoryProvider.overrideWithValue(
            FakeProfileRepository(
              profile: userProfile(email: 'listener@example.com'),
            ),
          ),
          changeEmailRepositoryProvider.overrideWithValue(
            changeEmailRepository,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'new@example.com');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Change Email'), findsOneWidget);
    expect(
      find.textContaining('Are you sure you want to change your email?'),
      findsOneWidget,
    );
    expect(changeEmailRepository.requestedEmails, isEmpty);
  });
}
