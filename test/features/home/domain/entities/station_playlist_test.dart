import 'package:decibel/features/discovery/domain/entities/discovery_track.dart';
import 'package:decibel/features/discovery/domain/entities/discovery_user.dart';
import 'package:decibel/features/home/domain/entities/station_playlist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('StationPlaylist deduplicates tracks and exposes cover urls', () {
    const artist = DiscoveryUser(id: 1, username: 'artist');
    const first = DiscoveryTrack(
      id: 10,
      title: 'First',
      artist: artist,
      coverUrl: 'https://example.com/first.jpg',
    );
    const duplicate = DiscoveryTrack(
      id: 10,
      title: 'Duplicate',
      artist: artist,
      coverUrl: 'https://example.com/duplicate.jpg',
    );
    const second = DiscoveryTrack(
      id: 11,
      title: 'Second',
      artist: artist,
      coverUrl: 'https://example.com/second.jpg',
    );

    final playlist = StationPlaylist.fromTracks(
      kind: StationPlaylistKind.likes,
      tracks: const [first, duplicate, second],
    );

    expect(playlist.tracks, hasLength(2));
    expect(playlist.coverUrls, <String>[
      'https://example.com/first.jpg',
      'https://example.com/second.jpg',
    ]);
  });
}
