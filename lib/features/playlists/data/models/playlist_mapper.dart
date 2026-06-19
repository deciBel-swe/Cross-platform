import '../../../library/data/models/track_model.dart';
import '../../domain/entities/playlist.dart';
import 'owner_model.dart';
import 'playlist_model.dart';

extension PlaylistModelX on PlaylistModel {
  Playlist toEntity() => Playlist(
    id: id,
    title: title,
    description: description,
    type: type,
    isPrivate: isPrivate,
    isLiked: isLiked,
    isReposted: isReposted,
    coverArt: coverArt,
    owner:
        owner?.toEntity() ??
        const PlaylistOwner(id: 0, username: 'Unknown User'),
    tracks: tracks.map((track) => track.toEntity()).toList(),
    totalDurationSeconds: totalDurationSeconds,
    trackCount: trackCount,
    playlistSlug: playlistSlug,
    firstTrackWaveformUrl: firstTrackWaveformUrl,
    secretToken: secretToken,
    access: access,
    createdAt: createdAt,
  );
}
