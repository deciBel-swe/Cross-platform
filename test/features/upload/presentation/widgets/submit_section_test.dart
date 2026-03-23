import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/core/storage/shared_prefs_service.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/upload/domain/entities/track_upload_metadata.dart';
import 'package:decibel/features/upload/domain/repositories/i_upload_repository.dart';
import 'package:decibel/features/upload/presentation/providers/upload_notifier.dart';
import 'package:decibel/features/upload/presentation/widgets/submit_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockUploadRepository extends Mock implements IUploadRepository {}

class MockSharedPrefsService extends Mock implements SharedPrefsService {}

class MockGoRouter extends Mock implements GoRouter {}

class FakeTrackUploadMetadata extends Fake implements TrackUploadMetadata {}

/// Custom Notifier just for testing.
/// This allows us to seed the starting state exactly how we want it
/// without having to manually click through the UI to set it up.
class SeededUploadNotifier extends UploadNotifier {
  SeededUploadNotifier(this.initialState);
  final TrackUploadMetadata initialState;

  @override
  FutureOr<TrackUploadMetadata> build() async {
    return initialState;
  }
}

void main() {
  late MockUploadRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(FakeTrackUploadMetadata());
  });

  setUp(() {
    mockRepo = MockUploadRepository();
  });
  testWidgets('uploads track successfully and navigates to library', (
    tester,
  ) async {
    // 1. Arrange: Create a VALID state has file and genre
    final validState = TrackUploadMetadata(
      audioFile: File('dummy.mp3'),
      genre: 'Rock',
    );

    final formKey = GlobalKey<FormState>();
    final mockRouter = MockGoRouter();
    final uploadedTrack = Track(
      id: 1,
      title: 'test track',
      artist: const Artist(id: 1, username: 'tester'),
      genre: 'Rock',
      tags: <String>[],
      state: TrackStatus.finished,
      releaseDate: DateTime(2026, 1, 1),
      playCount: 0,
      likeCount: 0,
      repostCount: 0,
      createdAt: DateTime(2026, 1, 1),
    );

    // Tell the repository to return a Success
    when(
      () => mockRepo.uploadTrack(any()),
    ).thenAnswer((_) async => Right(uploadedTrack));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          uploadRepositoryProvider.overrideWithValue(mockRepo),
          uploadNotifierProvider.overrideWith(
            () => SeededUploadNotifier(validState),
          ),
        ],
        child: MaterialApp(
          home: InheritedGoRouter(
            goRouter: mockRouter,
            child: Scaffold(
              body: Form(
                key: formKey,
                child: SubmitSection(formKey: formKey),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 2. Act
    await tester.tap(find.text('Save'));
    await tester.pump(); // Trigger the async uploadTrack

    // Wait for the async repository call to finish
    await tester.pumpAndSettle();

    // 3. Assert
    // Verify the repository was actually called with our data
    verify(() => mockRepo.uploadTrack(any())).called(1);

    // Verify GoRouter was told to navigate to the library
    verify(() => mockRouter.go(RoutePaths.uploadLibrary)).called(1);
  });

  testWidgets('shows error snackbar when backend upload fails', (tester) async {
    // 1. Arrange: Valid state, but the server is going to fail
    final validState = TrackUploadMetadata(
      audioFile: File('dummy.mp3'),
      genre: 'Rock',
    );

    final formKey = GlobalKey<FormState>();

    // Tell the repository to return a Failure
    when(
      () => mockRepo.uploadTrack(any()),
    ).thenAnswer((_) async => const Left(ServerFailure('Upload timeout')));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          uploadRepositoryProvider.overrideWithValue(mockRepo),
          uploadNotifierProvider.overrideWith(
            () => SeededUploadNotifier(validState),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SubmitSection(formKey: formKey),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 2. Act
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pumpAndSettle();

    // 3. Assert
    verify(() => mockRepo.uploadTrack(any())).called(1);

    // Check that the backend error message was shown in the SnackBar
    expect(find.text('Upload timeout'), findsOneWidget);
  });

  testWidgets('shows error snackbar when no audio file is selected', (
    tester,
  ) async {
    // Arrange: Create a state that has a genre, but NO AUDIO FILE
    const fakeStateNoFile = TrackUploadMetadata(audioFile: null, genre: 'Rock');

    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          uploadRepositoryProvider.overrideWithValue(mockRepo),
          uploadNotifierProvider.overrideWith(
            () => SeededUploadNotifier(fakeStateNoFile),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SubmitSection(formKey: formKey),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.text('Save'));
    await tester.pump();

    // Assert: Check for the Audio File error
    expect(find.text('Please select an audio file to upload.'), findsOneWidget);
    verifyNever(() => mockRepo.uploadTrack(any()));
  });

  testWidgets('shows error snackbar when no genre is selected', (tester) async {
    // Arrange: Create a fake state that HAS a file, but no genre
    final fakeStateWithFileOnly = TrackUploadMetadata(
      audioFile: File('dummy.mp3'),
      genre: '',
    );

    final formKey = GlobalKey<FormState>();

    // Pump the widget into the test environment
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          uploadRepositoryProvider.overrideWithValue(mockRepo),
          // Inject the Notifier with the seeded state
          uploadNotifierProvider.overrideWith(
            () => SeededUploadNotifier(fakeStateWithFileOnly),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SubmitSection(formKey: formKey),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Wait for Riverpod to initialize

    // Act: Tap the SAVE button
    await tester.tap(find.text('Save'));
    await tester.pump(); // Trigger a frame to render the SnackBar

    // Assert: The frontend check should catch the missing genre
    expect(find.text('Please select a genre for your track.'), findsOneWidget);

    // Prove that the repository was NEVER called because validation failed
    verifyNever(() => mockRepo.uploadTrack(any()));
  });

  testWidgets('shows error snackbar when genre exceeds 100 characters', (
    tester,
  ) async {
    // Assert: File exists but genre is 101 characters
    final tooLongGenre = List.filled(101, '5').join();
    final fakeState = TrackUploadMetadata(
      audioFile: File('dummy.mp3'),
      genre: tooLongGenre,
    );

    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          uploadRepositoryProvider.overrideWithValue(mockRepo),
          uploadNotifierProvider.overrideWith(
            () => SeededUploadNotifier(fakeState),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SubmitSection(formKey: formKey),
            ),
          ),
        ),
      ),
    );

    //await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.text('Save'));
    await tester.pump();

    // Assert
    expect(
      find.text('Genre must be less than 100 characters.'),
      findsOneWidget,
    );
    verifyNever(() => mockRepo.uploadTrack(any()));
  });
}
