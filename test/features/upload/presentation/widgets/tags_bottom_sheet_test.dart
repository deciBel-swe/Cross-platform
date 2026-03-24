import 'dart:async';
import 'package:decibel/core/services/picker_service.dart';
import 'package:decibel/core/storage/shared_prefs_service.dart';
import 'package:decibel/features/upload/domain/entities/track_upload_metadata.dart';
import 'package:decibel/features/upload/domain/repositories/i_upload_repository.dart';
import 'package:decibel/features/upload/presentation/providers/upload_notifier.dart';
import 'package:decibel/features/upload/presentation/widgets/tags_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPrefsService extends Mock implements SharedPrefsService {}

class MockPickerService extends Mock implements IPickerService {}

class MockUploadRepository extends Mock implements IUploadRepository {}

// Re-using SeededUploadNotifier so we can force specific tag lists!
class SeededUploadNotifier extends UploadNotifier {
  SeededUploadNotifier(this.initialState);
  final TrackUploadMetadata initialState;

  @override
  FutureOr<TrackUploadMetadata> build() async {
    return initialState;
  }
}

void main() {
  late MockSharedPrefsService mockPrefs;
  late MockPickerService mockPicker;
  late MockUploadRepository mockRepo;

  setUp(() {
    mockPrefs = MockSharedPrefsService();
    mockPicker = MockPickerService();
    mockRepo = MockUploadRepository();
  });

  // Helper function to build our widget wrapped in ProviderScope
  Widget buildWidgetUnderTest(ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(
          // BottomSheets need a material ancestor to render properly
          body: TagsBottomSheet(),
        ),
      ),
    );
  }

  testWidgets('typing a tag and pressing enter adds it to the state', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker),
        uploadRepositoryProvider.overrideWithValue(mockRepo),
        uploadNotifierProvider.overrideWith(
          () => SeededUploadNotifier(const TrackUploadMetadata()),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(uploadNotifierProvider.future);
    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // 1. Act: Enter text into the tag field
    await tester.enterText(find.byType(TextField), 'Synthwave');

    // 2. Act: Simulate pressing the "Enter/Done" key on the virtual keyboard
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // 3. Assert: The state was updated and the chip is rendered
    final state = container.read(uploadNotifierProvider).value!;
    expect(state.tags.contains('Synthwave'), true);
    expect(
      find.text('Synthwave'),
      findsOneWidget,
    ); // Proves the InputChip rendered
  });

  testWidgets('tapping delete icon on a tag removes it from the state', (
    tester,
  ) async {
    // 1. Arrange: Seed the state with one tag
    const seededState = TrackUploadMetadata(tags: ['Pop']);

    final container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker),
        uploadRepositoryProvider.overrideWithValue(mockRepo),
        uploadNotifierProvider.overrideWith(
          () => SeededUploadNotifier(seededState),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(uploadNotifierProvider.future);
    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // Prove the chip is there initially
    expect(find.text('Pop'), findsOneWidget);

    // 2. Act: Find the delete icon inside the InputChip and tap it
    // Flutter uses Icons.cancel by default for the InputChip delete icon
    final deleteIconFinder = find.descendant(
      of: find.byType(InputChip),
      matching: find.byType(Icon),
    );

    await tester.tap(deleteIconFinder);
    await tester.pump();

    // 3. Assert: The tag is gone from state and UI
    final state = container.read(uploadNotifierProvider).value!;
    expect(state.tags.isEmpty, true);
    expect(find.text('Pop'), findsNothing);
  });
}
