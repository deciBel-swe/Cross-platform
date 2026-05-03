import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/offline/domain/repositories/i_offline_repository.dart';
import 'package:decibel/features/offline/domain/usecases/get_offline_tracks_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOfflineRepository extends Mock implements IOfflineRepository {}

Track _makeTrack(int id) => Track(
      id: id,
      title: 'Track $id',
      artist: const Artist(id: 10, username: 'artist'),
      trackUrl: 'https://example.com/track$id.mp3',
      genre: 'Hip-hop',
      tags: const [],
      state: TrackStatus.finished,
      releaseDate: DateTime(2024),
      playCount: 10,
      likeCount: 2,
      repostCount: 0,
      isLiked: false,
      isReposted: false,
      createdAt: DateTime(2024),
      trackDurationSeconds: 220,
    );

void main() {
  late MockOfflineRepository mockRepository;
  late GetOfflineTracksUseCase useCase;

  setUp(() {
    mockRepository = MockOfflineRepository();
    useCase = GetOfflineTracksUseCase(mockRepository);
  });

  group('GetOfflineTracksUseCase', () {
    test('returns Right([]) when no tracks are downloaded', () async {
      when(() => mockRepository.getDownloadedTracks())
          .thenAnswer((_) async => const Right([]));

      final result = await useCase.execute();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isEmpty);
      verify(() => mockRepository.getDownloadedTracks()).called(1);
    });

    test('returns Right(tracks) when tracks exist', () async {
      final tTracks = [_makeTrack(1), _makeTrack(2), _makeTrack(3)];
      when(() => mockRepository.getDownloadedTracks())
          .thenAnswer((_) async => Right(tTracks));

      final result = await useCase.execute();

      expect(result.isRight(), true);
      final tracks = result.getOrElse(() => []);
      expect(tracks.length, 3);
      expect(tracks[0].id, 1);
      expect(tracks[2].id, 3);
    });

    test('propagates Left(CacheFailure) from repository', () async {
      when(() => mockRepository.getDownloadedTracks()).thenAnswer(
        (_) async => const Left(CacheFailure('read error')),
      );

      final result = await useCase.execute();

      expect(result.isLeft(), true);
      result.fold(
        (f) {
          expect(f, isA<CacheFailure>());
          expect(f.message, 'read error');
        },
        (_) => fail('Expected Left'),
      );
    });

    test('calls repository exactly once per invocation', () async {
      when(() => mockRepository.getDownloadedTracks())
          .thenAnswer((_) async => const Right([]));

      await useCase.execute();
      await useCase.execute();

      verify(() => mockRepository.getDownloadedTracks()).called(2);
    });
  });
}
