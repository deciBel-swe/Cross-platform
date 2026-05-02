import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/offline/presentation/notifiers/collection_download_notifier.dart';
import 'package:decibel/features/offline/presentation/providers/collection_download_provider.dart';
import 'package:decibel/features/offline/presentation/widgets/collection_download_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ── Fakes / Mocks ─────────────────────────────────────────────────────────────

class FakeCollectionDownloadNotifier extends StateNotifier<CollectionDownloadState>
    implements CollectionDownloadNotifier {
  FakeCollectionDownloadNotifier(super.initialState);

  @override
  Future<void> download({
    required List<Track> tracks,
    required collectionInfo,
  }) async {}
}

Track _makeTrack(int id) => Track(
      id: id,
      title: 'Track $id',
      artist: const Artist(id: 1, username: 'artist'),
      trackUrl: 'https://example.com/$id.mp3',
      genre: 'Pop',
      tags: const [],
      state: TrackStatus.finished,
      releaseDate: DateTime(2024),
      playCount: 0,
      likeCount: 0,
      repostCount: 0,
      isLiked: false,
      isReposted: false,
      createdAt: DateTime(2024),
      trackDurationSeconds: 180,
    );

// ── helpers ───────────────────────────────────────────────────────────────────

/// Wraps the widget under test with MaterialApp + ProviderScope, overriding
/// [collectionDownloadProvider] with a [FakeCollectionDownloadNotifier]
/// seeded with [state].
Widget _buildWidget({
  required CollectionDownloadState state,
  int collectionId = 1,
  List<Track>? tracks,
}) {
  final fakeNotifier = FakeCollectionDownloadNotifier(state);

  return ProviderScope(
    overrides: [
      collectionDownloadProvider(collectionId).overrideWith((_) => fakeNotifier),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: CollectionDownloadButton(
          collectionId: collectionId,
          collectionTitle: 'My Playlist',
          tracks: tracks ?? [_makeTrack(1)],
        ),
      ),
    ),
  );
}

// ── tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('CollectionDownloadButton', () {
    testWidgets('shows download icon when idle (not downloading, not done)',
        (tester) async {
      await tester.pumpWidget(
        _buildWidget(state: const CollectionDownloadState()),
      );
      await tester.pump();

      expect(find.byIcon(Icons.download_outlined), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.download_done_rounded), findsNothing);
    });

    testWidgets('shows CircularProgressIndicator while downloading', (tester) async {
      await tester.pumpWidget(
        _buildWidget(
          state: const CollectionDownloadState(isDownloading: true, progress: 0.4),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.download_outlined), findsNothing);
    });

    testWidgets('shows download_done icon when isDone is true', (tester) async {
      await tester.pumpWidget(
        _buildWidget(
          state: const CollectionDownloadState(isDone: true, progress: 1.0),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.download_done_rounded), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('CircularProgressIndicator is indeterminate when progress == 0',
        (tester) async {
      await tester.pumpWidget(
        _buildWidget(
          state: const CollectionDownloadState(isDownloading: true, progress: 0.0),
        ),
      );
      await tester.pump();

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      // value == null means indeterminate
      expect(indicator.value, isNull);
    });

    testWidgets('CircularProgressIndicator uses progress value when > 0',
        (tester) async {
      await tester.pumpWidget(
        _buildWidget(
          state: const CollectionDownloadState(isDownloading: true, progress: 0.6),
        ),
      );
      await tester.pump();

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.value, closeTo(0.6, 0.01));
    });

    testWidgets('has semantics label "Download collection for offline"',
        (tester) async {
      await tester.pumpWidget(
        _buildWidget(state: const CollectionDownloadState()),
      );
      await tester.pump();

      expect(
        find.bySemanticsLabel('Download collection for offline'),
        findsOneWidget,
      );
    });
  });
}
