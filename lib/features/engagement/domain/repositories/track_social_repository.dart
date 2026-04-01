abstract class ITrackSocialRepository {
  Future<void> likeTrack(int trackId);
  Future<void> unlikeTrack(int trackId);
  Future<void> repostTrack(int trackId);
  Future<void> unrepostTrack(int trackId);
}
