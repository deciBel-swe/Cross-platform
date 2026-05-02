import '../../../discovery/domain/entities/discovery_track.dart';

enum StationPlaylistKind { likes, artist, genre }

class StationPlaylist {
  const StationPlaylist({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.tracks,
  });

  factory StationPlaylist.fromTracks({
    required StationPlaylistKind kind,
    required Iterable<DiscoveryTrack> tracks,
  }) {
    final uniqueTracks = <int, DiscoveryTrack>{};
    for (final track in tracks) {
      uniqueTracks.putIfAbsent(track.id, () => track);
    }

    return StationPlaylist(
      kind: kind,
      title: kind.title,
      subtitle: kind.subtitle,
      tracks: uniqueTracks.values.toList(growable: false),
    );
  }

  final StationPlaylistKind kind;
  final String title;
  final String subtitle;
  final List<DiscoveryTrack> tracks;

  int get trackCount => tracks.length;

  List<String> get coverUrls => tracks
      .map((track) => track.coverUrl?.trim())
      .whereType<String>()
      .where((url) => url.isNotEmpty)
      .take(4)
      .toList(growable: false);
}

extension StationPlaylistKindX on StationPlaylistKind {
  String get title {
    switch (this) {
      case StationPlaylistKind.likes:
        return 'Your Likes Radio';
      case StationPlaylistKind.artist:
        return 'Artist Radio';
      case StationPlaylistKind.genre:
        return 'Genre Radio';
    }
  }

  String get subtitle {
    switch (this) {
      case StationPlaylistKind.likes:
        return 'A station shaped by tracks you liked';
      case StationPlaylistKind.artist:
        return 'A station shaped by similar artists';
      case StationPlaylistKind.genre:
        return 'A station shaped by genre similarities';
    }
  }
}
