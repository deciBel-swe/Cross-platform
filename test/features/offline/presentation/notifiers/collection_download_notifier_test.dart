import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/offline/data/datasources/offline_local_data_source.dart';
import 'package:decibel/features/offline/domain/repositories/i_offline_repository.dart';
import 'package:decibel/features/offline/presentation/notifiers/collection_download_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOfflineRepository extends Mock implements IOfflineRepository {}

class FakeTrack extends Fake implements Track {}

class FakeOfflineCollectionInfo extends Fake implements OfflineCollectionInfo {}

Track _makeTrack(int id) => Track(
      id: id,
      title: 'Track $id',
      artist: const Artist(id: 10, username: 'artist'),
      trackUrl: 'https://example.com/track$id.mp3',
      genre: 'Chill',
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

const _tCollection = OfflineCollectionInfo(
  id: 1,
  title: 'Test Playlist',
  coverUrl: null,
  trackIds: [1, 2],
);

void main() {
  late MockOfflineRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(FakeTrack());
    registerFallbackValue(FakeOfflineCollectionInfo());
    registerFallbackValue(<Track>[]);
    registerFallbackValue((double p) {});
  });

  setUp(() {
    mockRepo = MockOfflineRepository();
    
    // Default stubs to prevent 'Null' is not a subtype of 'Future<Either<Failure, void>>'
    when(() => mockRepo.saveCollectionMetadata(any()))
        .thenAnswer((_) async => const Right(null));
    when(() => mockRepo.downloadTracks(any(), onProgress: any(named: 'onProgress')))
        .thenAnswer((_) async => const Right(null));
  });

  // ── CollectionDownloadState ────────────────────────────────────────────────

  group('CollectionDownloadState', () {
    test('default values are sensible', () {
      const state = CollectionDownloadState();
      expect(state.progress, 0.0);
      expect(state.isDownloading, false);
      expect(state.isDone, false);
      expect(state.error, isNull);
    });

    test('copyWith updates progress', () {
      const state = CollectionDownloadState();
      final updated = state.copyWith(progress: 0.5);
      expect(updated.progress, 0.5);
      expect(updated.isDownloading, false);
    });

    test('copyWith preserves existing fields when not overridden', () {
      const state =
          CollectionDownloadState(isDownloading: true, progress: 0.3);
      final updated = state.copyWith(progress: 0.6);
      expect(updated.progress, 0.6);
      expect(updated.isDownloading, true);
    });

    test('copyWith with error=null clears previous error', () {
      const state = CollectionDownloadState(error: 'oops');
      final updated = state.copyWith(isDownloading: false);
      // The implementation passes error directly (not `error ?? this.error`),
      // so null clears the field.
      expect(updated.error, isNull);
    });
  });

  // ── CollectionDownloadNotifier ─────────────────────────────────────────────

  group('CollectionDownloadNotifier', () {
    test('initial state is idle with no error', () {
      final notifier = CollectionDownloadNotifier(mockRepo);
      expect(notifier.state.isDownloading, false);
      expect(notifier.state.isDone, false);
      expect(notifier.state.error, isNull);
      expect(notifier.state.progress, 0.0);
    });

    test('download sets isDownloading=true, saves metadata, and resolves to isDone', () async {
      final tracks = [_makeTrack(1), _makeTrack(2)];

      final notifier = CollectionDownloadNotifier(mockRepo);
      final downloadFuture = notifier.download(
        tracks: tracks,
        collectionInfo: _tCollection,
      );

      // Immediately after calling download, isDownloading should be true
      expect(notifier.state.isDownloading, true);

      await downloadFuture;

      expect(notifier.state.isDownloading, false);
      expect(notifier.state.isDone, true);
      expect(notifier.state.progress, 1.0);
      expect(notifier.state.error, isNull);
    });

    test('calls saveCollectionMetadata before downloadTracks', () async {
      final tracks = [_makeTrack(1)];
      final callOrder = <String>[];

      when(() => mockRepo.saveCollectionMetadata(any())).thenAnswer((_) async {
        callOrder.add('save');
        return const Right(null);
      });
      when(
        () => mockRepo.downloadTracks(any(), onProgress: any(named: 'onProgress')),
      ).thenAnswer((_) async {
        callOrder.add('download');
        return const Right(null);
      });

      final notifier = CollectionDownloadNotifier(mockRepo);
      await notifier.download(tracks: tracks, collectionInfo: _tCollection);

      expect(callOrder, ['save', 'download']);
    });

    test('sets error state on repository failure', () async {
      final tracks = [_makeTrack(1)];
      const tFailureMessage = 'Connection lost';

      when(
        () => mockRepo.downloadTracks(any(), onProgress: any(named: 'onProgress')),
      ).thenAnswer(
        (_) async => const Left(NetworkFailure(tFailureMessage)),
      );

      final notifier = CollectionDownloadNotifier(mockRepo);
      await notifier.download(tracks: tracks, collectionInfo: _tCollection);

      expect(notifier.state.isDownloading, false);
      expect(notifier.state.isDone, false);
      expect(notifier.state.error, tFailureMessage);
    });

    test('ignores second download call while already downloading', () async {
      final tracks = [_makeTrack(1)];
      int saveCallCount = 0;

      when(() => mockRepo.saveCollectionMetadata(any())).thenAnswer((_) async {
        saveCallCount++;
        return const Right(null);
      });

      final notifier = CollectionDownloadNotifier(mockRepo);
      // Start first download without awaiting
      final first = notifier.download(tracks: tracks, collectionInfo: _tCollection);
      // Attempt second download while first is running
      await notifier.download(tracks: tracks, collectionInfo: _tCollection);
      await first;

      // saveCollectionMetadata should only be called once
      expect(saveCallCount, 1);
    });

    test('progress updates are reflected in state during downloadTracks', () async {
      final tracks = [_makeTrack(1), _makeTrack(2)];
      final progressValues = <double>[];

      when(
        () => mockRepo.downloadTracks(any(), onProgress: any(named: 'onProgress')),
      ).thenAnswer((inv) async {
        final onProgress =
            inv.namedArguments[const Symbol('onProgress')] as void Function(double)?;
        onProgress?.call(0.5);
        onProgress?.call(1.0);
        return const Right(null);
      });

      final notifier = CollectionDownloadNotifier(mockRepo);
      // Hook into state changes
      notifier.addListener((state) => progressValues.add(state.progress));
      await notifier.download(tracks: tracks, collectionInfo: _tCollection);

      expect(progressValues, contains(0.5));
    });
  });
}
