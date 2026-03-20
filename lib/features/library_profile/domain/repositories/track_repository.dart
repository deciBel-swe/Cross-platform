import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/track.dart';

abstract class TrackRepository {
  Future<Either<Failure, List<Track>>> getUserTracks(int userId);
}