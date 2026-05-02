import 'package:decibel/features/settings/domain/entities/social_settings.dart';
import 'package:decibel/features/settings/presentation/notifiers/social_settings_notifier.dart';
import 'package:decibel/features/settings/presentation/providers/social_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  group('SocialSettingsNotifier', () {
    test('build loads social settings from the repository', () async {
      final repository = FakeSocialSettingsRepository(
        settings: const SocialSettings(isPrivate: true, showHistory: false),
      );
      final container = ProviderContainer(
        overrides: [
          socialSettingsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final settings = await container.read(socialSettingsProvider.future);

      expect(settings.isPrivate, isTrue);
      expect(settings.showHistory, isFalse);
    });

    test('toggles are optimistic and debounce the saved update', () async {
      final repository = FakeSocialSettingsRepository();
      final container = ProviderContainer(
        overrides: [
          socialSettingsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(socialSettingsProvider.future);
      await container
          .read(socialSettingsProvider.notifier)
          .toggleProfilePrivacy(true);

      expect(container.read(socialSettingsProvider).value?.isPrivate, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 550));
      expect(repository.updates.single.isPrivate, isTrue);
    });

    test('failed debounced save rolls back to the burst start state', () async {
      final repository = FakeSocialSettingsRepository()
        ..updateError = Exception('save failed');
      final container = ProviderContainer(
        overrides: [
          socialSettingsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(socialSettingsProvider.future);
      await container
          .read(socialSettingsProvider.notifier)
          .toggleHistoryVisibility(false);
      await Future<void>.delayed(const Duration(milliseconds: 550));

      expect(container.read(socialSettingsProvider).value?.showHistory, isTrue);
    });
  });
}
