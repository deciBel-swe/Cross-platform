import 'dart:async';

import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/library/presentation/screens/uploads_library_screen.dart';
import 'package:decibel/features/library_profile/presentation/providers/uploads_provider.dart';
import 'package:decibel/features/library_profile/presentation/widgets/upload_track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeUploadsNotifier extends UploadsNotifier {
  FakeUploadsNotifier({required this.tracks, this.error, this.pendingBuild});

  final List<Track> tracks;
  final Object? error;
  final Future<List<Track>>? pendingBuild;

  int refreshAllCalls = 0;

  @override
  Future<List<Track>> build() async {
    if (pendingBuild != null) {
      return pendingBuild!;
    }
    if (error != null) {
      throw error!;
    }
    return tracks;
  }

  @override
  Future<void> refreshAll() async {
    refreshAllCalls++;
  }

  @override
  Future<void> loadNextPage() async {}
}

void main() {
  Track makeTrack({int id = 1, String title = 'Track 1'}) {
    return Track(
      id: id,
      title: title,
      artist: const Artist(id: 10, username: 'tester'),
      genre: 'Pop',
      tags: const <String>[],
      state: TrackStatus.finished,
      releaseDate: DateTime(2025, 1, 1),
      playCount: 0,
      likeCount: 0,
      repostCount: 0,
      isLiked: false,
      isReposted: false,
      createdAt: DateTime(2025, 1, 1),
    );
  }

  Widget buildTestWidget(FakeUploadsNotifier notifier) {
    return ProviderScope(
      overrides: [uploadsProvider.overrideWith(() => notifier)],
      child: const MaterialApp(home: UploadsLibraryScreen()),
    );
  }

  group('UploadsLibraryScreen', () {
    testWidgets('shows loading indicator while uploads are loading', (
      tester,
    ) async {
      final completer = Completer<List<Track>>();
      final notifier = FakeUploadsNotifier(
        tracks: const <Track>[],
        pendingBuild: completer.future,
      );

      await tester.pumpWidget(buildTestWidget(notifier));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(const <Track>[]);
    });

    testWidgets('shows empty state when there are no uploads', (tester) async {
      final notifier = FakeUploadsNotifier(tracks: const <Track>[]);

      await tester.pumpWidget(buildTestWidget(notifier));
      await tester.pumpAndSettle();

      expect(find.text('No uploads yet.'), findsOneWidget);
      expect(find.text('Refresh'), findsOneWidget);
      expect(find.byType(UploadTrackCard), findsNothing);
    });

    testWidgets('shows list of upload cards when uploads exist', (
      tester,
    ) async {
      final notifier = FakeUploadsNotifier(
        tracks: <Track>[
          makeTrack(id: 1, title: 'First Track'),
          makeTrack(id: 2, title: 'Second Track'),
        ],
      );

      await tester.pumpWidget(buildTestWidget(notifier));
      await tester.pumpAndSettle();

      expect(find.byType(UploadTrackCard), findsNWidgets(2));
      expect(find.text('First Track'), findsOneWidget);
      expect(find.text('Second Track'), findsOneWidget);
    });

    testWidgets('shows error state with retry button when provider fails', (
      tester,
    ) async {
      final notifier = FakeUploadsNotifier(
        tracks: const <Track>[],
        error: Exception('boom'),
      );

      await tester.pumpWidget(buildTestWidget(notifier));
      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('tapping empty-state refresh calls refreshAll', (tester) async {
      final notifier = FakeUploadsNotifier(tracks: const <Track>[]);

      await tester.pumpWidget(buildTestWidget(notifier));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Refresh'));
      await tester.pump();

      expect(notifier.refreshAllCalls, 1);
    });
  });
}
