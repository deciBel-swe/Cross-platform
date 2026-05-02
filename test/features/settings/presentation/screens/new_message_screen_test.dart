import 'package:decibel/features/settings/presentation/screens/new_message_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  testWidgets(
    'NewMessageScreen renders search input and empty unauthenticated state',
    (tester) async {
      await tester.pumpWidget(settingsTestApp(const NewMessageScreen()));
      await tester.pumpAndSettle();

      expect(find.text('New message'), findsOneWidget);
      expect(find.text('Search for users...'), findsOneWidget);
      expect(find.text('No users found'), findsOneWidget);
    },
  );
}
