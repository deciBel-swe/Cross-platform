import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/core/services/picker_service.dart';
import 'package:decibel/core/storage/shared_prefs_service.dart';
import 'package:decibel/features/library_profile/domain/entities/user_profile.dart'
    as profile;
import 'package:decibel/features/library_profile/presentation/notifiers/user_profile_notifier.dart';
import 'package:decibel/features/library_profile/presentation/providers/user_profile_provider.dart';
import 'package:decibel/features/upload/domain/entities/track_upload_metadata.dart';
import 'package:decibel/features/upload/domain/repositories/i_upload_repository.dart';
import 'package:decibel/features/upload/presentation/providers/upload_notifier.dart';
import 'package:decibel/features/upload/presentation/widgets/privacy_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPrefsService extends Mock implements SharedPrefsService {}

class MockPickerService extends Mock implements IPickerService {}

class MockUploadRepository extends Mock implements IUploadRepository {}

class FakeTrackUploadMetadata extends Fake implements TrackUploadMetadata {}

class FakeUserProfileNotifier extends UserProfileNotifier {
  @override
  Future<Either<Failure, profile.UserProfile>> build() async {
    return const Right(
      profile.UserProfile(
        id: 1,
        role: 'ARTIST',
        email: 'artist@example.com',
        username: 'artist',
        emailVerified: true,
        tier: profile.UserTier.artistPro,
        profileDetails: profile.UserProfileDetails(favoriteGenres: <String>[]),
        privacySettings: profile.PrivacySettings(
          isPrivate: false,
          showHistory: true,
        ),
        stats: profile.UserStats(followers: 0, following: 0, tracksCount: 0),
      ),
    );
  }
}

void main() {
  late MockSharedPrefsService mockPrefs;
  late MockPickerService mockPicker;
  late MockUploadRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(FakeTrackUploadMetadata());
  });

  setUp(() {
    mockPrefs = MockSharedPrefsService();
    mockPicker = MockPickerService();
    mockRepo = MockUploadRepository();

    // Default mock behavior
    when(
      () => mockPrefs.getLastPrivacySettings(),
    ).thenAnswer((_) async => false);
    when(
      () => mockPrefs.saveLastPrivacySettings(any()),
    ).thenAnswer((_) async {});
  });

  // Helper function to build our widget wrapped in ProviderScope
  Widget buildWidgetUnderTest(ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: PrivacySettings())),
      ),
    );
  }

  testWidgets('selecting Unlisted radio button updates notifier to private', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker),
        uploadRepositoryProvider.overrideWithValue(mockRepo),
        userProfileProvider.overrideWith(() => FakeUserProfileNotifier()),
      ],
    );
    addTearDown(container.dispose);

    // Wait for the AsyncNotifier to finish initializing
    await container.read(uploadNotifierProvider.future);

    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // Act: Tap the unlisted/private Radio control (value: true)
    await tester.tap(find.byType(Radio<bool>).at(1));
    await tester.pump();

    // Assert: Check the Riverpod state directly
    final state = container.read(uploadNotifierProvider).value!;
    expect(state.isPrivate, true);
  });

  testWidgets(
    'selecting Public radio button clears schedule and updates privacy',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
          pickerServiceProvider.overrideWithValue(mockPicker),
          uploadRepositoryProvider.overrideWithValue(mockRepo),
          userProfileProvider.overrideWith(() => FakeUserProfileNotifier()),
        ],
      );
      addTearDown(container.dispose);

      await container.read(uploadNotifierProvider.future);

      // First, let's manually inject a release date into the state so we can prove it gets cleared
      container.read(uploadNotifierProvider.notifier).togglePrivacy(true);
      container
          .read(uploadNotifierProvider.notifier)
          .updateReleaseDate(DateTime(2026, 1, 1));

      await tester.pumpWidget(buildWidgetUnderTest(container));
      await tester.pumpAndSettle();

      // Act: Tap the public Radio control (value: false)
      await tester.tap(find.byType(Radio<bool>).at(0));
      await tester.pump();

      // Assert: Privacy is false, and the release date was forcefully cleared
      final state = container.read(uploadNotifierProvider).value!;
      expect(state.isPrivate, false);
      expect(state.releaseDate, isNull);
    },
  );

  testWidgets('toggling schedule switch ON opens the Date Picker dialog', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker),
        uploadRepositoryProvider.overrideWithValue(mockRepo),
        userProfileProvider.overrideWith(() => FakeUserProfileNotifier()),
      ],
    );
    addTearDown(container.dispose);

    await container.read(uploadNotifierProvider.future);

    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // Act: Tap the Switch widget
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle(); // Wait for the dialog animation to render

    // Assert: Verify that the Flutter DatePickerDialog is now on screen!
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });
}
