import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/offline/domain/repositories/i_offline_repository.dart';
import 'package:decibel/features/offline/domain/usecases/download_track_usecase.dart';
import 'package:decibel/features/offline/presentation/notifiers/track_download_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOfflineRepository extends Mock implements IOfflineRepository {}

Track _makeTrack({int id = 1, String? trackUrl = 'https://example.com/t.mp3'}) =>
    Track(
      id: id,
      title: 'Track $id',
      artist: const Artist(id: 10, username: 'artist'),
      trackUrl: trackUrl,
      genre: 'Electronic',
      tags: const [],
      state: TrackStatus.finished,
      releaseDate: DateTime(2024),
      playCount: 0,
      likeCount: 0,
      repostCount: 0,
      isLiked: false,
      isReposted: false,
      createdAt: DateTime(2024),
      trackDurationSeconds: 200,
    );


void main() {
  late MockOfflineRepository mockRepo;

  setUp(() {
    mockRepo = MockOfflineRepository();
  });

  // ── state transitions ──────────────────────────────────────────────────────

  group('TrackDownloadNotifier', () {
    test('initial state is AsyncData(null)', () {
      final useCase = DownloadTrackUseCase(mockRepo);
      final notifier = TrackDownloadNotifier(useCase);
      expect(notifier.state, equals(const AsyncData<String?>(null)));
    });

    test('transitions to AsyncLoading then AsyncData(path) on success', () async {
      final tTrack = _makeTrack();
      const tPath = '/docs/tracks/track_1.dat';

      when(() => mockRepo.downloadTrack(tTrack))
          .thenAnswer((_) async => const Right(tPath));

      final useCase = DownloadTrackUseCase(mockRepo);
      final notifier = TrackDownloadNotifier(useCase);

      final states = <AsyncValue<String?>>[];
      // Capture states manually by driving the notifier directly.
      final future = notifier.downloadTrack(tTrack);
      // After calling downloadTrack the notifier sets AsyncLoading synchronously.
      states.add(notifier.state);
      await future;
      states.add(notifier.state);

      expect(states[0], isA<AsyncLoading<String?>>());
      expect(states[1].value, tPath);
    });

    test('transitions to AsyncError on repository failure', () async {
      final tTrack = _makeTrack();

      when(() => mockRepo.downloadTrack(tTrack)).thenAnswer(
        (_) async => const Left(NetworkFailure('offline')),
      );

      final useCase = DownloadTrackUseCase(mockRepo);
      final notifier = TrackDownloadNotifier(useCase);

      await notifier.downloadTrack(tTrack);

      final state = notifier.state;
      expect(state.hasError, true);
      expect(state.error, 'offline');
    });

    test('transitions to AsyncError on server failure with message', () async {
      final tTrack = _makeTrack();
      const tMessage = 'Server blew up';

      when(() => mockRepo.downloadTrack(tTrack)).thenAnswer(
        (_) async => const Left(ServerFailure(tMessage)),
      );

      final useCase = DownloadTrackUseCase(mockRepo);
      final notifier = TrackDownloadNotifier(useCase);

      await notifier.downloadTrack(tTrack);

      expect(notifier.state.error, tMessage);
    });

    test('transitions to AsyncError on CacheFailure', () async {
      final tTrack = _makeTrack();
      const tMessage = 'Storage full';

      when(() => mockRepo.downloadTrack(tTrack)).thenAnswer(
        (_) async => const Left(CacheFailure(tMessage)),
      );

      final useCase = DownloadTrackUseCase(mockRepo);
      final notifier = TrackDownloadNotifier(useCase);

      await notifier.downloadTrack(tTrack);

      expect(notifier.state.error, tMessage);
      expect(notifier.state, isA<AsyncError<String?>>());
    });

    test('resets state to AsyncLoading on every download call', () async {
      final tTrack = _makeTrack();
      when(() => mockRepo.downloadTrack(tTrack))
          .thenAnswer((_) async => const Right('/path/1.dat'));

      final useCase = DownloadTrackUseCase(mockRepo);
      final notifier = TrackDownloadNotifier(useCase);

      // First download success
      await notifier.downloadTrack(tTrack);
      expect(notifier.state.hasValue, true);

      // Second download starts
      final second = notifier.downloadTrack(tTrack);
      expect(notifier.state, isA<AsyncLoading<String?>>());
      await second;
      expect(notifier.state.hasValue, true);
    });

    test('multiple sequential downloads update state correctly', () async {
      final track1 = _makeTrack(id: 1);
      final track2 = _makeTrack(id: 2);

      when(() => mockRepo.downloadTrack(track1))
          .thenAnswer((_) async => const Right('/path/1.dat'));
      when(() => mockRepo.downloadTrack(track2))
          .thenAnswer((_) async => const Right('/path/2.dat'));

      final useCase = DownloadTrackUseCase(mockRepo);
      final notifier = TrackDownloadNotifier(useCase);

      await notifier.downloadTrack(track1);
      expect(notifier.state.value, '/path/1.dat');

      await notifier.downloadTrack(track2);
      expect(notifier.state.value, '/path/2.dat');
    });
  });
}
