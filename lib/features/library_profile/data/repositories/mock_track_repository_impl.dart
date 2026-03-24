import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/data/datasources/library_mock_datasource.dart';
import '../../../library/data/models/paginated_tracks_model.dart';
import '../../../library/data/models/track_model.dart';
import '../../../library/data/models/track_peaks_model.dart';
import '../../../library/domain/entities/paginated_tracks.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_peaks.dart';
import '../../domain/repositories/track_repository.dart';

@Environment('mock')
@LazySingleton(as: TrackRepository)
class MockTrackRepository implements TrackRepository {
  @override
  Future<Either<Failure, Track>> fetchTrackById(int id) async {
    final trackModel = await const LibraryMockDatasource().fetchTrackById(id);

    return Right(trackModel.toEntity());
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
}
