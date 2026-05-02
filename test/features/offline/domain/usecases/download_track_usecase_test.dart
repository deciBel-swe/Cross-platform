import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/offline/domain/repositories/i_offline_repository.dart';
import 'package:decibel/features/offline/domain/usecases/download_track_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOfflineRepository extends Mock implements IOfflineRepository {}

class FakeTrack extends Fake implements Track {}

Track _makeTrack({int id = 1}) => Track(
      id: id,
      title: 'Track $id',
      artist: const Artist(id: 10, username: 'artist'),
      trackUrl: 'https://example.com/track$id.mp3',
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

void main() {
  late MockOfflineRepository mockRepository;
  late DownloadTrackUseCase useCase;

  setUpAll(() {
    registerFallbackValue(FakeTrack());
  });

  setUp(() {
    mockRepository = MockOfflineRepository();
    useCase = DownloadTrackUseCase(mockRepository);
  });

  group('DownloadTrackUseCase', () {
    final tTrack = _makeTrack();
    const tPath = '/docs/tracks/track_1.dat';

    test('delegates to repository.downloadTrack and returns Right(path)', () async {
      when(() => mockRepository.downloadTrack(tTrack))
          .thenAnswer((_) async => const Right(tPath));

      final result = await useCase.execute(tTrack);

      expect(result, const Right<Failure, String>(tPath));
      verify(() => mockRepository.downloadTrack(tTrack)).called(1);
    });

    test('propagates Left(NetworkFailure) from repository', () async {
      when(() => mockRepository.downloadTrack(tTrack)).thenAnswer(
        (_) async => const Left(NetworkFailure('No connection')),
      );

      final result = await useCase.execute(tTrack);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('propagates Left(ServerFailure) from repository', () async {
      when(() => mockRepository.downloadTrack(tTrack)).thenAnswer(
        (_) async => const Left(ServerFailure('Server error')),
      );

      final result = await useCase.execute(tTrack);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('calls repository exactly once per execution', () async {
      when(() => mockRepository.downloadTrack(tTrack))
          .thenAnswer((_) async => const Right(tPath));

      await useCase.execute(tTrack);
      await useCase.execute(tTrack);

      verify(() => mockRepository.downloadTrack(tTrack)).called(2);
    });
  });
}
