import 'package:injectable/injectable.dart';

import '../../../library/data/models/paginated_tracks_model.dart';
import '../../../library/domain/entities/paginated_tracks.dart';
import '../../domain/repositories/track_social_repository.dart';
import '../datasources/track_social_remote_datasource.dart';

@LazySingleton(as: ITrackSocialRepository)
class TrackSocialRepositoryImpl implements ITrackSocialRepository {
  const TrackSocialRepositoryImpl(this._datasource);
  final TrackSocialRemoteDatasource _datasource;

  @override
  Future<PaginatedTracks> getLikedTracks({int page = 0, int size = 20}) async {
    final model = await _datasource.getLikedTracks(page: page, size: size);
    return model.toEntity();
  }

  @override
  Future<void> likeTrack(String trackId) => _datasource.likeTrack(trackId);

  @override
  Future<void> unlikeTrack(String trackId) => _datasource.unlikeTrack(trackId);

  @override
  Future<void> repostTrack(String trackId) => _datasource.repostTrack(trackId);

  @override
  Future<void> unrepostTrack(String trackId) =>
      _datasource.unrepostTrack(trackId);
}
