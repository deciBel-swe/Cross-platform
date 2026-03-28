import '../../../library/domain/entities/paginated_tracks.dart';

abstract class ITrackSocialRepository {
  Future<PaginatedTracks> getLikedTracks({int page = 0, int size = 20});
  Future<void> likeTrack(String trackId);
  Future<void> unlikeTrack(String trackId);
  Future<void> repostTrack(String trackId);
  Future<void> unrepostTrack(String trackId);
}
