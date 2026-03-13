import 'package:dartz/dartz.dart';
import '../entities/track_upload_metadata.dart';
import '../../../../core/errors/failures.dart';

abstract class IUploadRepository {
  Future<Either<Failure, Unit>> uploadTrack(TrackUploadMetadata metadata);
}