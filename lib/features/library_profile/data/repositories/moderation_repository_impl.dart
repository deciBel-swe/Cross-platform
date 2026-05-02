import 'package:injectable/injectable.dart';

import '../../domain/repositories/moderation_repository.dart';
import '../datasources/moderation_remote_data_source.dart';

@LazySingleton(as: ModerationRepository)
class ModerationRepositoryImpl implements ModerationRepository {
  ModerationRepositoryImpl(this._remoteDataSource);

  final IModerationRemoteDataSource _remoteDataSource;

  @override
  Future<void> blockUser(int userId) {
    return _remoteDataSource.blockUser(userId);
  }

  @override
  Future<void> unblockUser(int userId) {
    return _remoteDataSource.unblockUser(userId);
  }
}