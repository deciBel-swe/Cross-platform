import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/track_upload_metadata.dart';
import '../../../library/domain/entities/track.dart';

abstract class IUploadRepository {
  Future<Either<Failure, Track>> uploadTrack(TrackUploadMetadata metadata);
}
