import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/i_upload_repository.dart';
import '../../domain/entities/track_upload_metadata.dart';
import '../datasources/upload_remote_datasource.dart';
import '../models/track_metadata_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';

@LazySingleton(as: IUploadRepository)
class UploadRepository implements IUploadRepository {
  final UploadRemoteDatasource _remoteDatasource;
  const UploadRepository(this._remoteDatasource);

  @override
  Future<Either<Failure, Unit>> uploadTrack(TrackUploadMetadata metadata) async {
    try {
      if (metadata.audioFile == null){
        return const Left(ServerFailure('Audio file is required'));
      }

      final model = metadata.toModel();

      await _remoteDatasource.uploadTrack(
        metadata.audioFile!,
        metadata.coverImage,
        model,
        );

        return const Right(unit);
    }
    on ServerException catch(error){
      return Left(ServerFailure(error.message));
    }
    catch(error){
      return const Left(ServerFailure('An unexpected error occurred during upload the file'));
    }
  }
}