import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/paginated_tracks.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_edit_request.dart';
import '../../../library/domain/entities/track_peaks.dart';

abstract class TrackRepository {
  Future<Either<Failure, PaginatedTracks>> fetchMyTracks({
    required int page,
    required int size,
  });

  Future<Either<Failure, PaginatedTracks>> fetchTracks({
    required int userId,
    required int page,
    required int size,
  });

  Future<Either<Failure, Track>> fetchTrackById(int id);

  Future<Either<Failure, int>> resolveTrackIdentifier(String trackIdentifier);

  /// Fetches backend processing status (UPLOADING/PROCESSING/FINISHED/FAILED)
  /// used by uploads polling to reflect server-side waveform lifecycle.
  Future<Either<Failure, String>> fetchTrackStatusById(int id);

  Future<Either<Failure, TrackPeaks>> fetchTrackPeaksById(int id);

  Future<Either<Failure, Track>> updateTrackMetadata({
    required int trackId,
    required TrackEditRequest request,
  });

  Future<Either<Failure, bool>> deleteTrack(int trackId);

  Future<Either<Failure, bool>> deleteTrackCover(int trackId);
}
