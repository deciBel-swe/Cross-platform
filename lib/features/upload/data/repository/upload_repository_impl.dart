import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../library/data/models/track_model.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/track_upload_metadata.dart';
import '../../domain/repositories/i_upload_repository.dart';
import '../datasources/upload_remote_datasource.dart';
import '../models/track_metadata_model.dart';

@LazySingleton(as: IUploadRepository, env: [Environment.prod])
class UploadRepository implements IUploadRepository {
  const UploadRepository(this._remoteDatasource);
  final UploadRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, Track>> uploadTrack(
    TrackUploadMetadata metadata, {
    void Function(int count, int total)? onSendProgress,
  }) async {
    try {
      if (metadata.audioFile == null) {
        return const Left(ServerFailure('Audio file is required'));
      }

      final model = metadata.toModel();

      final trackModel = await _remoteDatasource.uploadTrack(
        metadata.audioFile!,
        metadata.coverImage,
        model,
        onSendProgress: onSendProgress,
      );

      return Right(trackModel.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return const Left(
        ServerFailure('An unexpected error occurred during file upload'),
      );
    }
  }
}
