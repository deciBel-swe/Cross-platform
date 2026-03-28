import '../../../library/domain/entities/track.dart';

/// Represents the user who created the playlist.
class PlaylistOwner {
  const PlaylistOwner({required this.id, required this.username});

  final int id;
  final String username;
}

/// The core entity representing a saved Playlist.
class Playlist {
  const Playlist({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.isPrivate,
    this.coverArt,
    required this.owner,
    required this.tracks,
  });

  final int id;
  final String title;
  final String? description;
  final String type;
  final bool isPrivate;
  final String? coverArt;
  final PlaylistOwner owner;
  final List<Track> tracks;
}
