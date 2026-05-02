import '../../../library/data/models/track_model.dart';
import '../../domain/entities/playlist.dart';
import 'playlist_model.dart';

extension OwnerModelX on OwnerModel {
  PlaylistOwner toEntity() => PlaylistOwner(id: id, username: username);
}

extension PlaylistModelX on PlaylistModel {
  Playlist toEntity() => Playlist(
    id: id,
    title: title,
    description: description,
    type: type,
    isPrivate: isPrivate,
    isLiked: isLiked,
    coverArt: coverArt,
    owner: owner?.toEntity() ?? const PlaylistOwner(id: 0, username: 'Unknown User'),
    tracks: tracks.map((track) => track.toEntity()).toList(),
  );
}
