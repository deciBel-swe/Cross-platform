import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/track_upload_metadata.dart';

abstract class IUploadRepository {
  Future<Either<Failure, Unit>> uploadTrack(TrackUploadMetadata metadata);
}
