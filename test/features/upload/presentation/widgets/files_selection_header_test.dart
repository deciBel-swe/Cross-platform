import 'dart:async';
import 'dart:io';
import 'package:decibel/core/services/picker_service.dart';
import 'package:decibel/core/storage/shared_prefs_service.dart';
import 'package:decibel/features/upload/domain/entities/track_upload_metadata.dart';
import 'package:decibel/features/upload/domain/repositories/i_upload_repository.dart';
import 'package:decibel/features/upload/presentation/providers/upload_notifier.dart';
import 'package:decibel/features/upload/presentation/widgets/files_selection_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPrefsService extends Mock implements SharedPrefsService {}

class MockPickerService extends Mock implements IPickerService {}

class MockUploadRepository extends Mock implements IUploadRepository {}

// Mock the File object again so we can fake the file size
class MockFile extends Mock implements File {}

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

  Widget buildWidgetUnderTest(ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: Scaffold(body: FileSelectionHeader())),
    );
  }

  testWidgets('displays default UI when no files are selected', (tester) async {
    final container = ProviderContainer(
      overrides: [
        uploadNotifierProvider.overrideWith(
          () => SeededUploadNotifier(const TrackUploadMetadata()),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(uploadNotifierProvider.future);

    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // Assert: Check for default placeholders
    expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
    expect(find.text('No file selected'), findsOneWidget);
    expect(find.text('Replace file'), findsOneWidget);
  });

  testWidgets('displays formatted file name and size when audio file exists', (
    tester,
  ) async {
    // 1. Arrange: Create a mock file to simulate a 10MB MP3 file
    final mockAudioFile = MockFile();
    when(() => mockAudioFile.path).thenReturn('fake/path/my_song.mp3');
    // 10 MB in bytes
    when(() => mockAudioFile.lengthSync()).thenReturn(10 * 1024 * 1024);

    final seededState = TrackUploadMetadata(audioFile: mockAudioFile);

    final container = ProviderContainer(
      overrides: [
        uploadNotifierProvider.overrideWith(
          () => SeededUploadNotifier(seededState),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(uploadNotifierProvider.future);

    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // 2. Assert
    expect(find.text('my_song.mp3'), findsOneWidget);
    expect(find.text('MP3 - 10.00(MB)'), findsOneWidget);
  });

  testWidgets('tapping cover art placeholder calls pickCoverImage', (
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

    // Tell the mock picker to just return null so it doesn't crash
    when(() => mockPicker.pickCoverImage()).thenAnswer((_) async => null);

    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // Act: Tap the container holding the camera icon
    await tester.tap(find.byIcon(Icons.camera_alt_outlined));
    await tester.pump();

    // Assert: The picker service was called
    verify(() => mockPicker.pickCoverImage()).called(1);
  });

  testWidgets('tapping Replace file calls pickAudioFile', (tester) async {
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

    when(() => mockPicker.pickAudioFile()).thenAnswer((_) async => null);

    await tester.pumpWidget(buildWidgetUnderTest(container));
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.text('Replace file'));
    await tester.pump();

    // Assert
    verify(() => mockPicker.pickAudioFile()).called(1);
  });
}
