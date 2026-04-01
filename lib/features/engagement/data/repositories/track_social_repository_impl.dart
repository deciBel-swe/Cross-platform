import 'package:injectable/injectable.dart';

import '../../domain/repositories/track_social_repository.dart';
import '../datasources/track_social_remote_datasource.dart';

@LazySingleton(as: ITrackSocialRepository, env: [Environment.prod])
class TrackSocialRepositoryImpl implements ITrackSocialRepository {
  const TrackSocialRepositoryImpl(this._datasource);
  final TrackSocialRemoteDatasource _datasource;

  @override
  Future<void> likeTrack(int trackId) => _datasource.likeTrack(trackId);

  @override
  Future<void> unlikeTrack(int trackId) => _datasource.unlikeTrack(trackId);

  @override
  Future<void> repostTrack(int trackId) => _datasource.repostTrack(trackId);

  @override
  Future<void> unrepostTrack(int trackId) => _datasource.unrepostTrack(trackId);
}
