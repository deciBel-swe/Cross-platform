import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/track.dart';

abstract class IOfflineRepository {
  /// Downloads a track using its [Track.trackUrl] and saves it
  /// locally as data, returning the path to the stored file.
  Future<Either<Failure, String>> downloadTrack(Track track);

  /// Retrieves all offline downloaded tracks.
  Future<Either<Failure, List<Track>>> getDownloadedTracks();
}
