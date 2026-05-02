import '../../../discovery/domain/entities/discovery_track.dart';
import '../../../library/domain/entities/artist.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_status.dart';

Track discoveryTrackToLibraryTrack(DiscoveryTrack track) {
  final now = DateTime.now();

  return Track(
    id: track.id,
    title: track.title,
    artist: Artist(
      id: track.artist.id,
      username: track.artist.username,
      displayName: track.artist.displayName,
      avatarUrl: track.artist.avatarUrl,
    ),
    trackUrl: track.trackUrl ?? track.trackPreviewUrl,
    coverUrl: track.coverUrl,
    waveformUrl: track.waveformUrl,
    genre: track.genre ?? '',
    tags: track.tags,
    state: TrackStatus.finished,
    releaseDate: track.releaseDate ?? track.createdAt ?? now,
    playCount: track.playCount,
    likeCount: track.likeCount,
    repostCount: track.repostCount,
    isLiked: track.isLiked,
    isReposted: track.isReposted,
    createdAt: track.createdAt ?? track.releaseDate ?? now,
    trackDurationSeconds: track.durationSeconds ?? 0,
  );
}

List<Track> discoveryTracksToLibraryTracks(Iterable<DiscoveryTrack> tracks) {
  return tracks.map(discoveryTrackToLibraryTrack).toList(growable: false);
}
