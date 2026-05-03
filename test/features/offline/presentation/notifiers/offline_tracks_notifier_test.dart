import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/offline/domain/repositories/i_offline_repository.dart';
import 'package:decibel/features/offline/domain/usecases/get_offline_tracks_usecase.dart';
import 'package:decibel/features/offline/presentation/notifiers/offline_tracks_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOfflineRepository extends Mock implements IOfflineRepository {}

Track _makeTrack(int id) => Track(
      id: id,
      title: 'Track $id',
      artist: const Artist(id: 10, username: 'artist'),
      trackUrl: 'https://example.com/track$id.mp3',
      genre: 'Ambient',
      tags: const [],
      state: TrackStatus.finished,
      releaseDate: DateTime(2024),
      playCount: 5,
      likeCount: 1,
      repostCount: 0,
      isLiked: false,
      isReposted: false,
      createdAt: DateTime(2024),
      trackDurationSeconds: 300,
    );

void main() {
  late MockOfflineRepository mockRepo;

  setUp(() {
    mockRepo = MockOfflineRepository();
  });

  group('OfflineTracksNotifier', () {
    // ── initial state ────────────────────────────────────────────────────────

    test('initial state is AsyncLoading', () {
      final useCase = GetOfflineTracksUseCase(mockRepo);
      // Use a stub so loadTracks does not crash, even though we only check
      // state before awaiting.
      when(() => mockRepo.getDownloadedTracks())
          .thenAnswer((_) async => const Right([]));
      final notifier = OfflineTracksNotifier(useCase);

      expect(notifier.state, isA<AsyncLoading<List<Track>>>());
    });

    // ── loadTracks success ───────────────────────────────────────────────────

    test('loadTracks transitions to AsyncData with track list on success', () async {
      final tTracks = [_makeTrack(1), _makeTrack(2)];
      when(() => mockRepo.getDownloadedTracks())
          .thenAnswer((_) async => Right(tTracks));

      final useCase = GetOfflineTracksUseCase(mockRepo);
      final notifier = OfflineTracksNotifier(useCase);

      await notifier.loadTracks();

      final state = notifier.state;
      expect(state.hasValue, true);
      expect(state.value!.length, 2);
      expect(state.value![0].id, 1);
    });

    test('loadTracks transitions to AsyncData([]) for empty list', () async {
      when(() => mockRepo.getDownloadedTracks())
          .thenAnswer((_) async => const Right([]));

      final useCase = GetOfflineTracksUseCase(mockRepo);
      final notifier = OfflineTracksNotifier(useCase);

      await notifier.loadTracks();

      expect(notifier.state.value, isEmpty);
    });

    // ── loadTracks failure ───────────────────────────────────────────────────

    test('loadTracks transitions to AsyncError with failure message on failure', () async {
      when(() => mockRepo.getDownloadedTracks()).thenAnswer(
        (_) async => const Left(CacheFailure('read error')),
      );

      final useCase = GetOfflineTracksUseCase(mockRepo);
      final notifier = OfflineTracksNotifier(useCase);

      await notifier.loadTracks();

      final state = notifier.state;
      expect(state.hasError, true);
      expect(state.error, 'read error');
    });

    // ── repeated calls ───────────────────────────────────────────────────────

    test('calling loadTracks twice re-fetches from repository both times', () async {
      when(() => mockRepo.getDownloadedTracks())
          .thenAnswer((_) async => const Right([]));

      final useCase = GetOfflineTracksUseCase(mockRepo);
      final notifier = OfflineTracksNotifier(useCase);

      await notifier.loadTracks();
      await notifier.loadTracks();

      verify(() => mockRepo.getDownloadedTracks()).called(2);
    });

    // ── state resets to AsyncLoading on every call ───────────────────────────

    test('loadTracks resets to AsyncLoading before resolving', () async {
      when(() => mockRepo.getDownloadedTracks())
          .thenAnswer((_) async => const Right([]));

      final useCase = GetOfflineTracksUseCase(mockRepo);
      final notifier = OfflineTracksNotifier(useCase);

      // Settle first call
      await notifier.loadTracks();
      expect(notifier.state.hasValue, true);

      // Start second call — before awaiting, state should be AsyncLoading
      final secondCall = notifier.loadTracks();
      expect(notifier.state, isA<AsyncLoading<List<Track>>>());
      await secondCall;
    });
  });
}
