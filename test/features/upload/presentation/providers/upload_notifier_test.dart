import 'dart:io';
import 'package:decibel/core/services/picker_service.dart';
import 'package:decibel/core/services/waveform_extraction_service.dart';
import 'package:decibel/core/storage/shared_prefs_service.dart';
import 'package:decibel/features/upload/domain/repositories/i_upload_repository.dart';
import 'package:decibel/features/upload/presentation/providers/upload_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// 1. Create the Mocks using Mocktail
class MockPickerService extends Mock implements IPickerService {}

class MockSharedPrefsService extends Mock implements SharedPrefsService {}

class MockUploadRepository extends Mock implements IUploadRepository {}

class MockWaveformExtractionService extends Mock
    implements WaveformExtractionService {}

class MockFile extends Mock implements File {}

void main() {
  late MockPickerService mockPicker;
  late MockSharedPrefsService mockPrefs;
  late MockUploadRepository mockRepo;
  late MockWaveformExtractionService mockWaveformService;
  late ProviderContainer container;

  /// 2. Set up fresh mocks before each test runs
  setUp(() {
    mockPicker = MockPickerService();
    mockPrefs = MockSharedPrefsService();
    mockRepo = MockUploadRepository();
    mockWaveformService = MockWaveformExtractionService();

    // The notifier always checks privacy settings on startup, so we mock it.
    when(
      () => mockPrefs.getLastPrivacySettings(),
    ).thenAnswer((_) async => false);

    when(
      () => mockPicker.getAudioDuration(any()),
    ).thenAnswer((_) async => const Duration(seconds: 180));

    when(
      () => mockWaveformService.extractWaveform(
        any(),
        noOfSamples: any(named: 'noOfSamples'),
      ),
    ).thenAnswer((_) async => [0.1, 0.3, 0.2]);

    container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker),
        waveformExtractionServiceProvider.overrideWithValue(
          mockWaveformService,
        ),
        uploadRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  // Helper to wait for the notifier to initialize
  Future<UploadNotifier> initNotifier() async {
    final notifier = container.read(uploadNotifierProvider.notifier);
    await container.read(uploadNotifierProvider.future);
    return notifier;
  }

  test('Loads saved privacy settings and initial genre suggestions', () async {
    when(
      () => mockPrefs.getLastPrivacySettings(),
    ).thenAnswer((_) async => true);

    final notifier = await initNotifier();
    final state = container.read(uploadNotifierProvider).value!;

    expect(state.isPrivate, true);
    expect(notifier.genreSuggestions.length, 3);
  });

  group('UploadNotifier - Synchronous Updates', () {
    test('UpdateTitle updates the title', () async {
      final notifier = await initNotifier();
      notifier.updateTitle('New Track');
      expect(
        container.read(uploadNotifierProvider).valueOrNull?.title,
        'New Track',
      );
    });

    test('updateDescription updates the description', () async {
      final notifier = await initNotifier();
      notifier.updateDescription('the track of the beginning after the end');
      expect(
        container.read(uploadNotifierProvider).value!.description,
        'the track of the beginning after the end',
      );
    });

    test('updateGenre updates the genre and rotates suggestions', () async {
      final notifier = await initNotifier();
      final initialSuggestions = List<String>.from(notifier.genreSuggestions);

      // Pick a genre that is currently in the suggestions pool
      final pickedGenre = initialSuggestions.first;
      notifier.updateGenre(pickedGenre);

      final state = container.read(uploadNotifierProvider).value!;
      expect(state.genre, pickedGenre);

      // Verify rotation: The picked genre should be replaced in the suggestions
      expect(notifier.genreSuggestions.contains(pickedGenre), false);
    });

    test('togglePrivacy updates state and saves to prefs', () async {
      when(
        () => mockPrefs.saveLastPrivacySettings(any()),
      ).thenAnswer((_) async {});
      final notifier = await initNotifier();

      notifier.togglePrivacy(true);

      expect(container.read(uploadNotifierProvider).value!.isPrivate, true);
      verify(() => mockPrefs.saveLastPrivacySettings(true)).called(1);
    });

    test(
      'updateReleaseDate and clearReleaseDate manage the schedule',
      () async {
        final notifier = await initNotifier();
        final date = DateTime(2026, 1, 1);

        notifier.updateReleaseDate(date);
        expect(container.read(uploadNotifierProvider).value!.releaseDate, date);

        notifier.clearReleaseDate();
        expect(container.read(uploadNotifierProvider).value!.releaseDate, null);
      },
    );
  });

  group('UploadNotifier - Tag Management', () {
    test('addTag adds a tag if valid', () async {
      final notifier = await initNotifier();
      notifier.addTag('Pop');
      expect(
        container.read(uploadNotifierProvider).value!.tags.contains('Pop'),
        true,
      );
    });

    test('addTag ignores empty strings', () async {
      final notifier = await initNotifier();
      notifier.addTag('  ');
      expect(container.read(uploadNotifierProvider).value!.tags.isEmpty, true);
    });

    test('addTag respects the 10 tag limit', () async {
      final notifier = await initNotifier();
      // Add 10 different tags
      for (int i = 0; i < 10; i++) {
        notifier.addTag('Tag$i');
      }
      // Try to add an 11th
      notifier.addTag('Tag11');

      final tags = container.read(uploadNotifierProvider).value!.tags;
      expect(tags.length, 10);
      expect(tags.contains('Tag11'), false);
    });

    test('removeTag removes an existing tag', () async {
      final notifier = await initNotifier();
      notifier.addTag('Pop');
      notifier.removeTag('Pop');
      expect(container.read(uploadNotifierProvider).value!.tags.isEmpty, true);
    });
  });

  group('UploadNotifier - File Pickers', () {
    test('pickCoverImage updates state on success', () async {
      final fakeImage = MockFile();
      when(() => fakeImage.path).thenReturn('image.jpg');
      when(() => fakeImage.lengthSync()).thenReturn(2 * 1024 * 1024);
      // Pass the MIME Magic Bytes check
      // These are the actual hex bytes that identify a file as image/jpeg
      final jpegMagicBytes = [
        0xFF,
        0xD8,
        0xFF,
        0xE0,
        0x00,
        0x10,
        0x4A,
        0x46,
        0x49,
        0x46,
        0x00,
        0x01,
        0x01,
        0x01,
        0x00,
        0x48,
      ];
      when(
        () => fakeImage.openRead(any(), any()),
      ).thenAnswer((_) => Stream.fromIterable([jpegMagicBytes]));
      when(
        () => mockPicker.pickCoverImage(),
      ).thenAnswer((_) async => fakeImage);

      final notifier = await initNotifier();
      await notifier.pickCoverImage();

      expect(
        container.read(uploadNotifierProvider).value!.coverImage?.path,
        'image.jpg',
      );
    });

    test('pickAudioFile updates state with the selected file', () async {
      // Arrange: Tell the mock what to do when "pickAudioFile" is called
      final fakeFile = MockFile();

      // Give moke the path of the file
      when(() => fakeFile.path).thenReturn('fake/path/audio.mp3');

      // Give mock the size for size check
      when(() => fakeFile.lengthSync()).thenReturn(5 * 1024 * 1024);

      final mp3MagicBytes = [
        0x49,
        0x44,
        0x33,
        0x03,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0,
        0,
        0,
        0,
        0,
        0,
      ];
      when(
        () => fakeFile.openRead(any(), any()),
      ).thenAnswer((_) => Stream.fromIterable([mp3MagicBytes]));

      when(() => mockPicker.pickAudioFile()).thenAnswer((_) async => fakeFile);

      // MOCK THE DURATION SO IT PASSES THE 1-SECOND CHECK!
      when(
        () => mockPicker.getAudioDuration(any()),
      ).thenAnswer((_) async => const Duration(seconds: 180));

      // Create a Riverpod container and override the real service with our mock
      final container = ProviderContainer(
        overrides: [
          sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
          pickerServiceProvider.overrideWithValue(mockPicker),
          waveformExtractionServiceProvider.overrideWithValue(
            mockWaveformService,
          ),
        ],
      );
      addTearDown(container.dispose);

      // Read the notifier to trigger its build method
      final notifier = container.read(uploadNotifierProvider.notifier);
      await container.read(uploadNotifierProvider.future);

      // Act: Call the method we are testing "pickAudioFile"
      await notifier.pickAudioFile();

      // Assert: Verify the state actually changed to hold our fake file
      final currentState = container.read(uploadNotifierProvider).value;
      expect(currentState?.audioFile?.path, 'fake/path/audio.mp3');

      // Verify the mock was actually called once
      verify(() => mockPicker.pickAudioFile()).called(1);
    });

    test('pickAudioFile fails when duration is less than 1 second', () async {
      final fakeFile = MockFile();
      when(() => fakeFile.path).thenReturn('fake/path/audio.mp3');
      when(() => fakeFile.lengthSync()).thenReturn(5 * 1024 * 1024);

      final mp3MagicBytes = [
        0x49,
        0x44,
        0x33,
        0x03,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0,
        0,
        0,
        0,
        0,
        0,
      ];
      when(
        () => fakeFile.openRead(any(), any()),
      ).thenAnswer((_) => Stream.fromIterable([mp3MagicBytes]));

      when(() => mockPicker.pickAudioFile()).thenAnswer((_) async => fakeFile);

      // MOCK A 0-SECOND DURATION TO TRIGGER THE ERROR
      when(
        () => mockPicker.getAudioDuration(any()),
      ).thenAnswer((_) async => const Duration(seconds: 0));

      final container = ProviderContainer(
        overrides: [
          sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
          pickerServiceProvider.overrideWithValue(mockPicker),
          waveformExtractionServiceProvider.overrideWithValue(
            mockWaveformService,
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(uploadNotifierProvider.notifier);
      await container.read(uploadNotifierProvider.future);

      await notifier.pickAudioFile();

      final state = container.read(uploadNotifierProvider);
      expect(state.hasError, true);
      expect(
        state.error.toString(),
        contains('Audio file must be at least 1 second long'),
      );
    });

    test(
      'pickAudioFile rejects fake extensions (Magic Bytes mismatch)',
      () async {
        final fakeFile = MockFile();
        when(() => fakeFile.path).thenReturn('fake_audio.mp3');
        when(() => fakeFile.lengthSync()).thenReturn(5 * 1024 * 1024);

        // We pass in empty/junk bytes that DO NOT match an MP3 signature
        when(() => fakeFile.openRead(any(), any())).thenAnswer(
          (_) => Stream.fromIterable([
            [0x00, 0x00, 0x00, 0x00],
          ]),
        );

        when(
          () => mockPicker.pickAudioFile(),
        ).thenAnswer((_) async => fakeFile);

        final notifier = await initNotifier();
        await notifier.pickAudioFile();

        final state = container.read(uploadNotifierProvider);
        expect(state.hasError, true);
        expect(state.error.toString(), contains('FAKE EXTENSION'));
      },
    );

    test('pickAudioFile rejects files over 20MB', () async {
      final hugeFile = MockFile();
      when(() => hugeFile.path).thenReturn('audio.mp3');

      // Pretend the file is 25 MB
      when(() => hugeFile.lengthSync()).thenReturn(25 * 1024 * 1024);

      // Provide real MP3 ID3 magic bytes so it passes the MIME check
      final mp3MagicBytes = [
        0x49,
        0x44,
        0x33,
        0x03,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0x00,
        0,
        0,
        0,
        0,
        0,
        0,
      ];
      when(
        () => hugeFile.openRead(any(), any()),
      ).thenAnswer((_) => Stream.fromIterable([mp3MagicBytes]));

      when(() => mockPicker.pickAudioFile()).thenAnswer((_) async => hugeFile);

      final notifier = await initNotifier();
      await notifier.pickAudioFile();

      final state = container.read(uploadNotifierProvider);
      expect(state.hasError, true);
      expect(state.error.toString(), contains('exceeds 20MB limit'));
    });

    test(
      'pickAudioFile fails when duration cannot be read (Test Environment constraint)',
      () async {
        final validFile = MockFile();
        when(() => validFile.path).thenReturn('audio.mp3');
        when(() => validFile.lengthSync()).thenReturn(5 * 1024 * 1024);

        final mp3MagicBytes = [
          0x49,
          0x44,
          0x33,
          0x03,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0,
          0,
          0,
          0,
          0,
          0,
        ];
        when(
          () => validFile.openRead(any(), any()),
        ).thenAnswer((_) => Stream.fromIterable([mp3MagicBytes]));

        when(
          () => mockPicker.pickAudioFile(),
        ).thenAnswer((_) async => validFile);

        when(
          () => mockPicker.getAudioDuration(any()),
        ).thenAnswer((_) async => const Duration(seconds: 0));

        final notifier = await initNotifier();
        await notifier.pickAudioFile();

        // Because the test environment lacks native Windows/Android audio drivers,
        // AudioPlayer fails to get the duration, triggering your 1-second fallback error.
        final state = container.read(uploadNotifierProvider);
        expect(state.hasError, true);
        expect(
          state.error.toString(),
          contains('Audio file must be at least 1 second long.'),
        );
      },
    );
  });
}
