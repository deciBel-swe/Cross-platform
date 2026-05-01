import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/paginated_tracks.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_edit_request.dart';
import 'package:decibel/features/library/domain/entities/track_peaks.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/library_profile/domain/repositories/track_repository.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_preview_provider.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('trackPreviewProvider returns track and peaks', () async {
    final repository = FakeTrackRepository(
      trackResult: Right(_track(id: 1)),
      peaksResult: const Right(
        TrackPeaks(trackId: 1, duration: 120, peaks: [1, 2, 3]),
      ),
    );
    final container = _container(repository);

    final data = await container.read(trackPreviewProvider(1).future);

    expect(data.track.id, 1);
    expect(data.trackPeaks?.peaks, [1, 2, 3]);
  });

  test('trackPreviewProvider returns null peaks when peaks fail', () async {
    final repository = FakeTrackRepository(
      trackResult: Right(_track(id: 1)),
      peaksResult: const Left(ServerFailure('no peaks')),
    );
    final container = _container(repository);

    final data = await container.read(trackPreviewProvider(1).future);

    expect(data.track.id, 1);
    expect(data.trackPeaks, isNull);
  });

  test('trackPreviewProvider throws when track load fails', () async {
    final repository = FakeTrackRepository(
      trackResult: const Left(ServerFailure('no track')),
    );
    final container = _container(repository);

    await expectLater(
      container.read(trackPreviewProvider(1).future),
      throwsA(isA<Exception>()),
    );
  });
}

ProviderContainer _container(TrackRepository repository) {
  final container = ProviderContainer(
    overrides: [trackRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}

class FakeTrackRepository implements TrackRepository {
  FakeTrackRepository({
    required this.trackResult,
    this.peaksResult = const Left(ServerFailure('no peaks')),
  });

  final Either<Failure, Track> trackResult;
  final Either<Failure, TrackPeaks> peaksResult;

  @override
  Future<Either<Failure, Track>> fetchTrackById(int id) async => trackResult;

  @override
  Future<Either<Failure, TrackPeaks>> fetchTrackPeaksById(int id) async =>
      peaksResult;

  @override
  Future<Either<Failure, bool>> deleteTrack(int trackId) async =>
      const Right(true);

  @override
  Future<Either<Failure, bool>> deleteTrackCover(int trackId) async =>
      const Right(true);

  @override
  Future<Either<Failure, PaginatedTracks>> fetchMyTracks({
    required int page,
    required int size,
  }) async {
    return const Right(
      PaginatedTracks(
        content: [],
        pageNumber: 0,
        pageSize: 0,
        totalElements: 0,
        totalPages: 0,
        isLast: true,
      ),
    );
  }

  @override
  Future<Either<Failure, PaginatedTracks>> fetchTracks({
    required int userId,
    required int page,
    required int size,
  }) async {
    return const Right(
      PaginatedTracks(
        content: [],
        pageNumber: 0,
        pageSize: 0,
        totalElements: 0,
        totalPages: 0,
        isLast: true,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> fetchTrackStatusById(int id) async =>
      const Right('FINISHED');

  @override
  Future<Either<Failure, int>> resolveTrackIdentifier(
    String trackIdentifier,
  ) async {
    return const Right(1);
  }

  @override
  Future<Either<Failure, Track>> updateTrackMetadata({
    required int trackId,
    required TrackEditRequest request,
  }) async {
    return trackResult;
  }
}

Track _track({required int id}) {
  return Track(
    id: id,
    title: 'Track $id',
    artist: const Artist(id: 1, username: 'artist'),
    trackUrl: 'https://example.com/audio.mp3',
    genre: 'Pop',
    tags: const ['one'],
    state: TrackStatus.finished,
    releaseDate: DateTime(2026, 1, 1),
    playCount: 0,
    likeCount: 0,
    repostCount: 0,
    isLiked: false,
    isReposted: false,
    createdAt: DateTime(2026, 1, 1),
    trackDurationSeconds: 0,
  );
}
