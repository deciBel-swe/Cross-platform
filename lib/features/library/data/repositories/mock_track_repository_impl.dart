import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/paginated_tracks.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/track_peaks.dart';
import '../../domain/repositories/track_repository.dart';
import '../datasources/library_mock_datasource.dart';
import '../models/paginated_tracks_model.dart';
import '../models/track_model.dart';
import '../models/track_peaks_model.dart';

@Environment('mock')
@LazySingleton(as: TrackRepository)
class MockTrackRepository implements TrackRepository {
  @override
  Future<Either<Failure, Track>> fetchTrackById(int id) async {
    final trackModel = await const LibraryMockDatasource().fetchTrackById(id);

    return Right(trackModel.toEntity());
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
