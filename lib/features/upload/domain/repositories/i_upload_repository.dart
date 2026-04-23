import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/track_upload_metadata.dart';

abstract class IUploadRepository {
  Future<Either<Failure, Track>> uploadTrack(TrackUploadMetadata metadata);
  Stream<double> watchUploadProgress(String correlationId);
  void cancelProgressSubscription(String uploadId);
}
