import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/track_upload_metadata.dart';
import '../../domain/repositories/i_upload_repository.dart';
import '../datasources/upload_remote_datasource.dart';
import '../models/track_metadata_model.dart';

@LazySingleton(as: IUploadRepository)
class UploadRepository implements IUploadRepository {
  const UploadRepository(this._remoteDatasource);
  final UploadRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, Unit>> uploadTrack(
    TrackUploadMetadata metadata,
  ) async {
    try {
      if (metadata.audioFile == null) {
        return const Left(ServerFailure('Audio file is required'));
      }

      final model = metadata.toModel();

      await _remoteDatasource.uploadTrack(
        metadata.audioFile!,
        metadata.coverImage,
        model,
      );

      return const Right(unit);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (error) {
      return const Left(
        ServerFailure('An unexpected error occurred during file upload'),
      );
    }
  }
}
