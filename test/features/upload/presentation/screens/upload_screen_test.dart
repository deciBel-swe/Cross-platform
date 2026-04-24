import 'dart:async';
import 'package:decibel/core/services/picker_service.dart';
import 'package:decibel/core/storage/shared_prefs_service.dart';
import 'package:decibel/features/upload/domain/entities/track_upload_metadata.dart';
import 'package:decibel/features/upload/domain/repositories/i_upload_repository.dart';
import 'package:decibel/features/upload/presentation/providers/upload_notifier.dart';
import 'package:decibel/features/upload/presentation/screens/upload_screen.dart';
import 'package:decibel/features/upload/presentation/widgets/files_selection_header.dart';
import 'package:decibel/features/upload/presentation/widgets/privacy_settings.dart';
import 'package:decibel/features/upload/presentation/widgets/submit_section.dart';
import 'package:decibel/features/upload/presentation/widgets/track_details_form.dart';
import 'package:decibel/features/upload/presentation/widgets/track_info_checklist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPrefsService extends Mock implements SharedPrefsService {}

class MockPickerService extends Mock implements IPickerService {}

class MockUploadRepository extends Mock implements IUploadRepository {}

class MockGoRouter extends Mock implements GoRouter {}

class SeededUploadNotifier extends UploadNotifier {
  SeededUploadNotifier(this.initialState);
  final TrackUploadMetadata initialState;

  @override
  FutureOr<TrackUploadMetadata> build() async {
    return initialState;
  }
}

// A custom Notifier that intentionally hangs in the loading state forever
class LoadingUploadNotifier extends UploadNotifier {
  @override
  FutureOr<TrackUploadMetadata> build() async {
    // Return an unresolved future so state.value remains null
    return Completer<TrackUploadMetadata>().future;
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

  testWidgets(
    'displays CircularProgressIndicator when state is null "loading"',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            uploadNotifierProvider.overrideWith(() => LoadingUploadNotifier()),
          ],
          child: const MaterialApp(home: UploadScreen()),
        ),
      );

      // Assert: We should see a loading spinner and NO app bar or forms
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TrackDetailsForm), findsNothing);
    },
  );

  testWidgets('displays full UI when metadata is loaded', (tester) async {
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

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: UploadScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Assert: Check that every sub-widget is mounted
    expect(find.byType(TrackInfoChecklist), findsOneWidget);
    expect(find.byType(FileSelectionHeader), findsOneWidget);
    expect(find.byType(TrackDetailsForm), findsOneWidget);
    expect(find.byType(PrivacySettings), findsOneWidget);
    expect(find.byType(SubmitSection), findsOneWidget);
  });

  testWidgets('tapping back button calls context.pop()', (tester) async {
    final mockRouter = MockGoRouter();

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

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: InheritedGoRouter(
            goRouter: mockRouter,
            child: const UploadScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Act: Tap the back arrow in the AppBar
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();

    // Assert
    verify(() => mockRouter.pop()).called(1);
  });
}
