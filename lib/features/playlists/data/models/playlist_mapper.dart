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
    coverArt: coverArt,
    owner: owner.toEntity(),
    tracks: tracks.map((track) => track.toEntity()).toList(),
  );
}
