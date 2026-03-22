import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/paginated_tracks.dart';
import '../entities/track.dart';
import '../entities/track_peaks.dart';

abstract class TrackRepository {
  Future<Either<Failure, PaginatedTracks>> fetchTracks({
    required int userId,
    required int page,
    required int size,
  });

  Future<Either<Failure, Track>> fetchTrackById(int id);

  Future<Either<Failure, TrackPeaks>> fetchTrackPeaksById(int id);
}
