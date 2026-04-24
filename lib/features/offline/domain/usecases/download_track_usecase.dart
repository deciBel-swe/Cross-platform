import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/track.dart';
import '../repositories/i_offline_repository.dart';

@lazySingleton
class DownloadTrackUseCase {
  DownloadTrackUseCase(this.repository);

  final IOfflineRepository repository;

  Future<Either<Failure, String>> execute(Track track) {
    return repository.downloadTrack(track);
  }
}
