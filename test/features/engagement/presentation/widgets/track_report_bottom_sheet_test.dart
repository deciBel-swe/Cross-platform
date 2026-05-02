import 'dart:async';
import 'package:decibel/features/engagement/domain/repositories/track_social_repository.dart';
import 'package:decibel/features/engagement/presentation/providers/track_social_provider.dart';
import 'package:decibel/features/engagement/presentation/widgets/track_report_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackSocialRepository extends Mock implements ITrackSocialRepository {}

void main() {
  const trackId = 1;
  late MockTrackSocialRepository mockRepository;

  setUp(() {
    mockRepository = MockTrackSocialRepository();
  });

  group('TrackReportBottomSheet', () {
    testWidgets('submits report correctly', (tester) async {
      // Use a completer to control when the repository call finishes
      final completer = Completer<void>();
      when(() => mockRepository.reportTrack(
            trackId: any(named: 'trackId'),
            reason: any(named: 'reason'),
            description: any(named: 'description'),
          )).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: TrackReportBottomSheet(trackId: trackId),
            ),
          ),
        ),
      );

      // Select a reason
      await tester.tap(find.text('Spam'));
      await tester.pump();

      // Enter description
      await tester.enterText(find.byType(TextField), 'Testing report');
      await tester.pump();

      // Submit
      await tester.tap(find.text('Submit Report'));
      await tester.pump(); // Trigger _submit
      
      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Finish the call
      completer.complete();
      await tester.pumpAndSettle();

      verify(() => mockRepository.reportTrack(
            trackId: trackId,
            reason: 'Spam',
            description: 'Testing report',
          )).called(1);
    });

    testWidgets('shows error snackbar on failure', (tester) async {
      when(() => mockRepository.reportTrack(
            trackId: any(named: 'trackId'),
            reason: any(named: 'reason'),
            description: any(named: 'description'),
          )).thenThrow(Exception('Network error'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: TrackReportBottomSheet(trackId: trackId),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Spam'));
      await tester.pump();

      await tester.tap(find.text('Submit Report'));
      await tester.pump(); // Start submission
      await tester.pumpAndSettle(); // Wait for error state and SnackBar animation

      expect(find.textContaining('Network error'), findsOneWidget);
    });
  });
}
