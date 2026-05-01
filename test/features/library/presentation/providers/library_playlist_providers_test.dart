import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/library/presentation/providers/add_to_playlist_provider.dart';
import 'package:decibel/features/library/presentation/providers/user_playlists_provider.dart'
    as library_feature;
import 'package:decibel/features/playlists/domain/entities/playlist.dart';
import 'package:decibel/features/playlists/domain/entities/playlist_metadata.dart';
import 'package:decibel/features/playlists/domain/repositories/i_playlist_repository.dart';
import 'package:decibel/features/playlists/presentation/providers/user_playlists_provider.dart'
    as playlists;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPlaylistRepository extends Mock implements IPlaylistRepository {}

void main() {
  late MockPlaylistRepository repository;

  setUpAll(() {
    registerFallbackValue(
      const PlaylistMetadata(title: 'title', description: '', isPrivate: false),
    );
  });

  setUp(() {
    repository = MockPlaylistRepository();
    when(
      () => repository.getUserPlaylists(page: 0, size: 20),
    ).thenAnswer((_) async => Right([_playlist(id: 1)]));
    when(
      () => repository.addTrackToPlaylist(any(), any()),
    ).thenAnswer((_) async => const Right(null));
  });

  ProviderContainer container() {
    final container = ProviderContainer(
      overrides: [
        playlists.playlistRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('library userPlaylistsProvider', () {
    test('loads playlists from playlist repository', () async {
      final c = container();

      final playlists = await c.read(
        library_feature.userPlaylistsProvider.future,
      );

      expect(playlists.single.id, 1);
    });

    test('returns empty list for network failures', () async {
      when(
        () => repository.getUserPlaylists(page: 0, size: 20),
      ).thenAnswer((_) async => const Left(NetworkFailure('offline')));
      final c = container();

      final playlists = await c.read(
        library_feature.userPlaylistsProvider.future,
      );

      expect(playlists, isEmpty);
    });

    test('throws non-network failures', () async {
      when(
        () => repository.getUserPlaylists(page: 0, size: 20),
      ).thenAnswer((_) async => const Left(ServerFailure('bad')));
      final c = container();

      await expectLater(
        c.read(library_feature.userPlaylistsProvider.future),
        throwsA(isA<ServerFailure>()),
      );
    });
  });

  group('addToPlaylistProvider', () {
    test('adds a track and updates playlist locally', () async {
      final c = container();
      await c.read(playlists.userPlaylistsProvider.future);

      final success = await c
          .read(addToPlaylistProvider.notifier)
          .addTrack(playlistId: 1, trackId: 7, track: _track(id: 7));

      expect(success, isTrue);
      final updated = c.read(playlists.userPlaylistsProvider).value!;
      expect(updated.single.tracks.map((track) => track.id), [7]);
    });

    test('returns false and stores error when add fails', () async {
      when(
        () => repository.addTrackToPlaylist(1, 7),
      ).thenAnswer((_) async => const Left(ServerFailure('bad')));
      final c = container();

      final success = await c
          .read(addToPlaylistProvider.notifier)
          .addTrack(playlistId: 1, trackId: 7);

      expect(success, isFalse);
      expect(c.read(addToPlaylistProvider).hasError, isTrue);
    });

    test('returns false while already loading', () async {
      final completer = Completer<Either<Failure, void>>();
      when(
        () => repository.addTrackToPlaylist(1, 7),
      ).thenAnswer((_) => completer.future);
      final c = container();

      final first = c
          .read(addToPlaylistProvider.notifier)
          .addTrack(playlistId: 1, trackId: 7);
      await Future<void>.delayed(Duration.zero);

      final second = await c
          .read(addToPlaylistProvider.notifier)
          .addTrack(playlistId: 1, trackId: 7);

      expect(second, isFalse);
      completer.complete(const Right(null));
      expect(await first, isTrue);
    });
  });
}

Playlist _playlist({required int id}) {
  return Playlist(
    id: id,
    title: 'Playlist $id',
    type: 'playlist',
    isPrivate: false,
    isLiked: false,
    tracks: const [],
    totalDurationSeconds: 0,
    trackCount: 0,
  );
}

Track _track({required int id}) {
  return Track(
    id: id,
    title: 'Track $id',
    artist: const Artist(id: 1, username: 'artist'),
    trackUrl: 'https://example.com/audio.mp3',
    genre: 'Pop',
    tags: const [],
    state: TrackStatus.finished,
    releaseDate: DateTime(2026, 1, 1),
    playCount: 0,
    likeCount: 0,
    repostCount: 0,
    isLiked: false,
    isReposted: false,
    createdAt: DateTime(2026, 1, 1),
  );
}
