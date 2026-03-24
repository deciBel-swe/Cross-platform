import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/paginated_tracks.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_peaks.dart';

abstract class TrackRepository {
  Future<Either<Failure, PaginatedTracks>> fetchTracks({
    required int userId,
    required int page,
    required int size,
  });

  Future<Either<Failure, Track>> fetchTrackById(int id);

  /// Fetches backend processing status (UPLOADING/PROCESSING/FINISHED/FAILED)
  /// used by uploads polling to reflect server-side waveform lifecycle.
  Future<Either<Failure, String>> fetchTrackStatusById(int id);

  Future<Either<Failure, TrackPeaks>> fetchTrackPeaksById(int id);
}
