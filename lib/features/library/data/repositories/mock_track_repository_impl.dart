import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/data/datasources/library_mock_datasource.dart';
import 'package:decibel/features/library/data/models/paginated_tracks_model.dart';
import 'package:decibel/features/library/data/models/track_model.dart';
import 'package:decibel/features/library/data/models/track_peaks_model.dart';
import 'package:decibel/features/library/domain/entities/paginated_tracks.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_peaks.dart';
import 'package:decibel/features/library/domain/repositories/track_repository.dart';
import 'package:injectable/injectable.dart';

@Environment('mock')
@LazySingleton(as: TrackRepository)
class MockTrackRepository implements TrackRepository {
  @override
  Future<Either<Failure, Track>> fetchTrackById(int id) async {
    final trackModel = await LibraryMockDatasource().fetchTrackById(id);

    return Right(trackModel.toEntity());
  }

  @override
  Future<Either<Failure, TrackPeaks>> fetchTrackPeaksById(int id) async {
    final peaksModel = await LibraryMockDatasource().fetchTrackPeaks(id);

    return Right(peaksModel.toEntity());
  }

  @override
  Future<Either<Failure, PaginatedTracks>> fetchTracks({
    required int userId,
    required int page,
    required int size,
  }) async {
    final paginatedModel = await LibraryMockDatasource().fetchTracks();
    return Right(paginatedModel.toEntity());
  }
}
