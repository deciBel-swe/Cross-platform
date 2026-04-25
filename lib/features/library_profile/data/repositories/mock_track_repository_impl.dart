import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/data/datasources/library_mock_datasource.dart';
import '../../../library/data/models/paginated_tracks_model.dart';
import '../../../library/data/models/track_model.dart';
import '../../../library/data/models/track_peaks_model.dart';
import '../../../library/domain/entities/paginated_tracks.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_edit_request.dart';
import '../../../library/domain/entities/track_peaks.dart';
import '../../domain/repositories/track_repository.dart';

@Environment('mock')
@LazySingleton(as: TrackRepository)
class MockTrackRepository implements TrackRepository {
  @override
  Future<Either<Failure, PaginatedTracks>> fetchMyTracks({
    required int page,
    required int size,
  }) async {
    final paginatedModel = await const LibraryMockDatasource().fetchTracks(
      size: size,
      page: page,
    );
    return Right(paginatedModel.toEntity());
  }

  @override
  Future<Either<Failure, Track>> fetchTrackById(int id) async {
    final trackModel = await const LibraryMockDatasource().fetchTrackById(id);

    return Right(trackModel.toEntity());
  }

  @override
  Future<Either<Failure, int>> resolveTrackIdentifier(
    String trackIdentifier,
  ) async {
    final parsed = int.tryParse(trackIdentifier);
    if (parsed != null) {
      return Right(parsed);
    }

    return Left(
      ServerFailure('Mock resolver could not resolve track: $trackIdentifier'),
    );
  }

  @override
  Future<Either<Failure, String>> fetchTrackStatusById(int id) async {
    // Simulate backend status from current mock track state.
    final trackResult = await fetchTrackById(id);
    return trackResult.fold(
      (failure) => Left(failure),
      (track) =>
          Right(track.state.name == 'finished' ? 'FINISHED' : 'PROCESSING'),
    );
  }

  @override
  Future<Either<Failure, TrackPeaks>> fetchTrackPeaksById(int id) async {
    final peaksModel = await const LibraryMockDatasource().fetchTrackPeaks(id);

    return Right(peaksModel.toEntity());
  }

  @override
  Future<Either<Failure, PaginatedTracks>> fetchTracks({
    required int userId,
    required int page,
    required int size,
  }) async {
    final paginatedModel = await const LibraryMockDatasource().fetchTracks(
      size: size,
      page: page,
    );
    return Right(paginatedModel.toEntity());
  }

  @override
  Future<Either<Failure, Track>> updateTrackMetadata({
    required int trackId,
    required TrackEditRequest request,
  }) async {
    try {
      final trackModel = await const LibraryMockDatasource()
          .updateTrackMetadata(
            trackId: trackId,
            title: request.title,
            genre: request.genre,
            description: request.description,
            tags: request.tags,
            releaseDate: request.releaseDate,
            isPrivate: request.isPrivate,
            coverImage: request.coverImage,
          );
      return Right(trackModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTrack(int trackId) async {
    try {
      await const LibraryMockDatasource().deleteTrack(trackId);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTrackCover(int trackId) async {
    try {
      await const LibraryMockDatasource().deleteTrackCover(trackId);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
