import 'package:decibel/core/services/picker_service.dart';
import 'package:decibel/core/storage/shared_prefs_service.dart';
import 'package:decibel/features/upload/domain/repositories/i_upload_repository.dart';
import 'package:decibel/features/upload/presentation/providers/upload_notifier.dart';
import 'package:decibel/features/upload/presentation/widgets/genre_bottom_sheet.dart';
import 'package:decibel/features/upload/presentation/widgets/tags_bottom_sheet.dart';
import 'package:decibel/features/upload/presentation/widgets/track_details_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPrefsService extends Mock implements SharedPrefsService {}

class MockPickerService extends Mock implements IPickerService {}

class MockUploadRepository extends Mock implements IUploadRepository {}

void main() {
  late MockSharedPrefsService mockPrefs;
  late MockPickerService mockPicker;
  late MockUploadRepository mockRepo;

  setUp(() {
    mockPrefs = MockSharedPrefsService();
    mockPicker = MockPickerService();
    mockRepo = MockUploadRepository();

    // Default mock behavior
    when(
      () => mockPrefs.getLastPrivacySettings(),
    ).thenAnswer((_) async => false);
  });

  // Helper function to build our widget wrapped in ProviderScope
  Widget buildWidgetUnderTest(ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(
          // Wrap in SingleChildScrollView to prevent pixel overflow during keyboard simulation
          body: SingleChildScrollView(child: TrackDetailsForm()),
        ),
      ),
    );
  }

  testWidgets('typing in Title field updates the notifier state', (
    tester,
  ) async {
    // 1. Arrange
    final container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker),
        uploadRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(uploadNotifierProvider.future);
    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle(); // Wait for notifier to finish initializing

    // 2. Act: Enter text into the Title field
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title *'),
      'My Awesome Track',
    );
    await tester.pump(); // Let Riverpod process the change

    // 3. Assert: Check the Riverpod state directly!
    final state = container.read(uploadNotifierProvider).value!;
    expect(state.title, 'My Awesome Track');
  });

  testWidgets('typing in Description field updates the notifier state', (
    tester,
  ) async {
    // 1. Arrange
    final container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker),
        uploadRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(uploadNotifierProvider.future);
    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // 2. Act: Enter text into the Description field
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'This is a description',
    );
    await tester.pump();

    // 3. Assert
    final state = container.read(uploadNotifierProvider).value!;
    expect(state.description, 'This is a description');
  });

  testWidgets('tapping a suggested genre chip updates the notifier state', (
    tester,
  ) async {
    // 1. Arrange
    final container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker),
        uploadRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(uploadNotifierProvider.future);
    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // The notifier loads 3 default genre suggestions initially
    final initialSuggestions = container
        .read(uploadNotifierProvider.notifier)
        .genreSuggestions;
    final targetGenre = initialSuggestions.first;

    // 2. Act: Tap the first genre chip that appears
    await tester.tap(find.text(targetGenre));
    await tester.pump(); // Rebuild UI

    // 3. Assert: Verify the state holds the picked genre
    final state = container.read(uploadNotifierProvider).value!;
    expect(state.genre, targetGenre);
  });

  testWidgets('tapping PICK GENRE opens the GenreBottomSheet', (tester) async {
    // 1. Arrange
    final container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker),
        uploadRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(uploadNotifierProvider.future);
    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // 2. Act: Tap the PICK GENRE chip
    await tester.tap(find.text('PICK GENRE'));
    await tester
        .pumpAndSettle(); // Wait for the bottom sheet animation to finish

    // 3. Assert: Verify the GenreBottomSheet is now on screen
    expect(find.byType(GenreBottomSheet), findsOneWidget);
  });

  testWidgets('tapping the Tags tile opens the TagsBottomSheet', (
    tester,
  ) async {
    // 1. Arrange
    final container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker),
        uploadRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(uploadNotifierProvider.future);
    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // 2. Act: Tap the ListTile that says Tags
    await tester.tap(find.text('Tags'));
    await tester.pumpAndSettle(); // Wait for bottom sheet animation

    // 3. Assert: Verify the TagsBottomSheet is now on screen
    expect(find.byType(TagsBottomSheet), findsOneWidget);
  });
}
