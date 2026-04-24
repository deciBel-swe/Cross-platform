import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/track_upload_metadata.dart';
import '../entities/track_upload_status.dart';

abstract class IUploadRepository {
  Future<Either<Failure, Track>> uploadTrack(TrackUploadMetadata metadata);
  Stream<TrackUploadStatus> watchUploadStatus(String uploadId);
  void cancelUploadStatusSubscription(String uploadId);
}
