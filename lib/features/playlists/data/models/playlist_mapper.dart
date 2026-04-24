import '../../../library/data/models/track_model.dart';
import '../../domain/entities/playlist.dart';
import 'owner_model.dart';
import 'playlist_model.dart';

<<<<<<< HEAD
=======
extension OwnerModelX on OwnerModel {
  PlaylistOwner toEntity() => PlaylistOwner(
    id: id,
    username: username,
    displayName: displayName,
    avatarUrl: avatarUrl,
  );
}

>>>>>>> 8fc3cbbf6c0f521c9da4edbfbafda511f23d642a
extension PlaylistModelX on PlaylistModel {
  Playlist toEntity() => Playlist(
    id: id,
    title: title,
    description: description,
    type: type,
    isPrivate: isPrivate,
    isLiked: isLiked,
    coverArt: coverArt,
<<<<<<< HEAD
    owner: owner?.toEntity(),
=======
    owner:
        owner?.toEntity() ??
        const PlaylistOwner(id: 0, username: 'Unknown User'),
>>>>>>> 8fc3cbbf6c0f521c9da4edbfbafda511f23d642a
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
