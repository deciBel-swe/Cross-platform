import 'dart:io';
import 'package:decibel/core/services/picker_service.dart';
import 'package:decibel/core/storage/shared_prefs_service.dart';
import 'package:decibel/features/upload/presentation/providers/upload_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


/// 1. Create the Mocks using Mocktail
class MockPickerService extends Mock implements IPickerService {}
class MockSharedPrefsService extends Mock implements SharedPrefsService {}
class MockFile extends Mock implements File {}

void main() {
  late MockPickerService mockPicker;
  late MockSharedPrefsService mockPrefs;

  /// 2. Set up fresh mocks before each test runs
  setUp(() {
    mockPicker = MockPickerService();
    mockPrefs = MockSharedPrefsService();
    
    // The notifier always checks privacy settings on startup, so we mock it.
    when(() => mockPrefs.getLastPrivacySettings()).thenAnswer((_) async => false);
  });

  test('pickAudioFile updates state with the selected file', () async {
    // Arrange: Tell the mock what to do when "pickAudioFile" is called
    final fakeFile = MockFile();
  
    // Give moke the path of the file
    when(() => fakeFile.path).thenReturn('fake/path/audio.mp3');
    
    // Give mock the size for size check
    when(() => fakeFile.lengthSync()).thenReturn(5 * 1024 * 1024);

    // Return our mocked file
    when(() => mockPicker.pickAudioFile()).thenAnswer((_) async => fakeFile);

    // Create a Riverpod container and override the real service with our mock
    final container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker), 
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

  test('pickAudioFile throws error when file exceeds 500MB', () async {
    final massiveFile = MockFile();
    when(() => massiveFile.path).thenReturn('huge_audio.mp3');
    
    // Pretend the file is 600 MB
    when(() => massiveFile.lengthSync()).thenReturn(600 * 1024 * 1024); 
    
    when(() => mockPicker.pickAudioFile()).thenAnswer((_) async => massiveFile);

    final container = ProviderContainer(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(mockPrefs),
        pickerServiceProvider.overrideWithValue(mockPicker), 
      ],
    );
    addTearDown(container.dispose);
    final notifier = container.read(uploadNotifierProvider.notifier);
    await container.read(uploadNotifierProvider.future); 

    // Act
    await notifier.pickAudioFile();

    // Assert: Check that Riverpod caught the AsyncError
    final currentState = container.read(uploadNotifierProvider);
    expect(currentState.hasError, true);
    expect(currentState.error.toString(), 'File exceeds 500MB limit.');
  });
}