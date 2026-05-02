import 'package:decibel/features/settings/domain/entities/app_icon_option.dart';
import 'package:decibel/features/settings/presentation/providers/app_icon_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  group('AppIconNotifier', () {
    test('build returns the stored icon option', () async {
      final repository = FakeAppIconRepository(selected: AppIconOption.black);
      final container = ProviderContainer(
        overrides: [appIconRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final selected = await container.read(appIconProvider.future);

      expect(selected, AppIconOption.black);
    });

    test('setIcon persists the selected option and updates state', () async {
      final repository = FakeAppIconRepository();
      final container = ProviderContainer(
        overrides: [appIconRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(appIconProvider.future);
      await container
          .read(appIconProvider.notifier)
          .setIcon(AppIconOption.white);

      expect(container.read(appIconProvider).value, AppIconOption.white);
      expect(repository.savedIcons, [AppIconOption.white]);
    });

    test('setIcon exposes an error when persistence fails', () async {
      final repository = FakeAppIconRepository()..setError = Exception('boom');
      final container = ProviderContainer(
        overrides: [appIconRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(appIconProvider.future);
      await container
          .read(appIconProvider.notifier)
          .setIcon(AppIconOption.style1);

      expect(container.read(appIconProvider).hasError, isTrue);
    });
  });
}
