import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/track.dart';
import '../repositories/i_offline_repository.dart';

@lazySingleton
class GetOfflineTracksUseCase {
  GetOfflineTracksUseCase(this.repository);

  final IOfflineRepository repository;

  Future<Either<Failure, List<Track>>> execute() {
    return repository.getDownloadedTracks();
  }
}
