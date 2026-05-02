import 'package:decibel/features/settings/domain/entities/app_icon_option.dart';
import 'package:decibel/features/settings/presentation/providers/app_icon_provider.dart';
import 'package:decibel/features/settings/presentation/screens/change_app_icon_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  testWidgets('ChangeAppIconScreen lists icons and saves a new selection', (
    tester,
  ) async {
    final repository = FakeAppIconRepository(selected: AppIconOption.classic);

    await tester.pumpWidget(
      settingsTestApp(
        const ChangeAppIconScreen(),
        overrides: [appIconRepositoryProvider.overrideWithValue(repository)],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Classic'), findsOneWidget);
    expect(find.text('Black'), findsOneWidget);

    await tester.tap(find.text('Black'));
    await tester.pumpAndSettle();

    expect(repository.savedIcons, [AppIconOption.black]);
  });
}
