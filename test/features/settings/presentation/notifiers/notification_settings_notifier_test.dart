import 'dart:async';

import 'package:decibel/features/settings/domain/entities/notification_settings.dart';
import 'package:decibel/features/settings/domain/repositories/notification_settings_repository.dart';
import 'package:decibel/features/settings/presentation/notifiers/notification_settings_notifier.dart';
import 'package:decibel/features/settings/presentation/providers/notification_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationSettingsRepository extends Mock
    implements NotificationSettingsRepository {}

void main() {
  const initialSettings = NotificationSettings(
    notifyOnFollow: true,
    notifyOnLike: true,
    notifyOnRepost: true,
    notifyOnComment: true,
    notifyOnDM: true,
  );

  const updatedSettings = NotificationSettings(
    notifyOnFollow: false,
    notifyOnLike: true,
    notifyOnRepost: true,
    notifyOnComment: true,
    notifyOnDM: true,
  );

  setUpAll(() {
    registerFallbackValue(initialSettings);
  });

  late MockNotificationSettingsRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockNotificationSettingsRepository();
    container = ProviderContainer(
      overrides: [
        notificationSettingsRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
      ],
    );

    when(
      () => mockRepository.getNotificationSettings(),
    ).thenAnswer((_) async => initialSettings);
  });

  tearDown(() {
    container.dispose();
  });

  test(
    'updateSettings stores the saved response when the repository succeeds',
    () async {
      when(
        () => mockRepository.updateNotificationSettings(updatedSettings),
      ).thenAnswer((_) async => updatedSettings);

      await container.read(notificationSettingsProvider.future);
      await container
          .read(notificationSettingsProvider.notifier)
          .updateSettings(updatedSettings);

      final state = container.read(notificationSettingsProvider);

      expect(state.hasValue, isTrue);
      expect(state.value?.notifyOnFollow, isFalse);
      verify(
        () => mockRepository.updateNotificationSettings(updatedSettings),
      ).called(1);
    },
  );

  test(
    'updateSettings emits an error then restores the previous state when the repository fails',
    () async {
      final emittedStates = <AsyncValue<NotificationSettings>>[];

      when(
        () => mockRepository.updateNotificationSettings(updatedSettings),
      ).thenThrow(Exception('save failed'));

      final subscription = container.listen<AsyncValue<NotificationSettings>>(
        notificationSettingsProvider,
        (previous, next) {
          emittedStates.add(next);
        },
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await container.read(notificationSettingsProvider.future);
      await container
          .read(notificationSettingsProvider.notifier)
          .updateSettings(updatedSettings);

      final state = container.read(notificationSettingsProvider);
      final lastValue = state.valueOrNull;

      expect(emittedStates.any((state) => state.hasError), isTrue);
      expect(state.hasValue, isTrue);
      expect(lastValue?.notifyOnFollow, initialSettings.notifyOnFollow);
      expect(lastValue?.notifyOnDM, initialSettings.notifyOnDM);
    },
  );

  test(
    'rapid updates keep the latest optimistic state while saves finish sequentially',
    () async {
      final firstSaved = Completer<NotificationSettings>();
      final secondSaved = Completer<NotificationSettings>();
      final savedSettings = <NotificationSettings>[];

      final firstUpdate = initialSettings.copyWith(notifyOnFollow: false);
      final secondUpdate = firstUpdate.copyWith(notifyOnLike: false);

      when(() => mockRepository.updateNotificationSettings(any())).thenAnswer((
        invocation,
      ) {
        final settings =
            invocation.positionalArguments.single as NotificationSettings;
        savedSettings.add(settings);

        if (savedSettings.length == 1) {
          return firstSaved.future;
        }

        return secondSaved.future;
      });

      await container.read(notificationSettingsProvider.future);

      final saveFuture = container
          .read(notificationSettingsProvider.notifier)
          .updateSettings(firstUpdate);
      await Future<void>.delayed(Duration.zero);

      await container
          .read(notificationSettingsProvider.notifier)
          .updateSettings(secondUpdate);

      firstSaved.complete(firstUpdate);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(notificationSettingsProvider).value, secondUpdate);
      expect(savedSettings, [firstUpdate, secondUpdate]);

      secondSaved.complete(secondUpdate);
      await saveFuture;

      expect(container.read(notificationSettingsProvider).value, secondUpdate);
    },
  );
}
