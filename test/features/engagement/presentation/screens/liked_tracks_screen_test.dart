import 'dart:async';
import 'package:decibel/features/engagement/domain/models/track_action_data.dart';
import 'package:decibel/features/engagement/domain/models/playlist_social_data.dart';
import 'package:decibel/features/engagement/presentation/notifiers/liked_tracks_notifier.dart';
import 'package:decibel/features/engagement/presentation/notifiers/playlist_social_notifier.dart';
import 'package:decibel/features/engagement/presentation/notifiers/track_action_notifier.dart';
import 'package:decibel/features/engagement/presentation/notifiers/user_liked_playlist_notifier.dart';
import 'package:decibel/features/engagement/presentation/providers/playlist_social_provider.dart';
import 'package:decibel/features/engagement/presentation/providers/track_social_provider.dart';
import 'package:decibel/features/engagement/presentation/screens/liked_tracks_screen.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/library/presentation/notifiers/track_audio_notifier.dart';
import 'package:decibel/features/library/presentation/state/track_audio_state.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_audio_provider.dart';
import 'package:decibel/features/playlists/domain/entities/playlist.dart';
import 'package:decibel/features/playlists/presentation/providers/user_playlists_provider.dart'
    as playlist_providers;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackCollectionNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Track>, TrackCollectionType>
    with Mock
    implements TrackCollectionNotifier {
  final List<Track>? initialData;
  MockTrackCollectionNotifier([this.initialData]);

  @override
  FutureOr<List<Track>> build(TrackCollectionType arg) => initialData ?? [];
}

class MockUserLikedPlaylistsNotifier
    extends AutoDisposeAsyncNotifier<List<Playlist>>
    with Mock
    implements UserLikedPlaylistsNotifier {
  final List<Playlist>? initialData;
  MockUserLikedPlaylistsNotifier([this.initialData]);

  @override
  FutureOr<List<Playlist>> build() => initialData ?? [];
}

class MockTrackSocialNotifier extends FamilyAsyncNotifier<TrackSocialData, int>
    with Mock
    implements TrackSocialNotifier {
  @override
  FutureOr<TrackSocialData> build(int arg) => const TrackSocialData(
    isLiked: true,
    likeCount: 1,
    isReposted: false,
    repostCount: 0,
  );
}

class MockPlaylistSocialNotifier
    extends FamilyAsyncNotifier<PlaylistSocialData, int>
    with Mock
    implements PlaylistSocialNotifier {
  @override
  FutureOr<PlaylistSocialData> build(int arg) =>
      const PlaylistSocialData(isLiked: true, isReposted: true);
}

class MockTrackAudioNotifier extends Notifier<TrackAudioState>
    with Mock
    implements TrackAudioNotifier {
  @override
  TrackAudioState build() => const TrackAudioState();
}

void main() {
  final testArtist = Artist(
    id: 1,
    username: 'testartist',
    displayName: 'Test Artist',
  );
  final testTrack = Track(
    id: 1,
    title: 'Test Track',
    artist: testArtist,
    trackDurationSeconds: 180,
    isLiked: true,
    likeCount: 10,
    repostCount: 5,
    isReposted: false,
    genre: 'Rock',
    tags: const [],
    state: TrackStatus.finished,
    releaseDate: DateTime.now(),
    playCount: 100,
    createdAt: DateTime.now(),
  );

  final testPlaylist = Playlist(
    id: 101,
    title: 'Test Playlist',
    type: 'public',
    isPrivate: false,
    isLiked: true,
    tracks: const [],
    totalDurationSeconds: 0,
    trackCount: 0,
  );

  setUpAll(() {
    registerFallbackValue(TrackCollectionType.liked);
  });

  testWidgets('LikedTracksScreen displays tracks and playlists', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          trackCollectionProvider.overrideWith(
            () => MockTrackCollectionNotifier([testTrack]),
          ),
          playlist_providers.userLikedPlaylistsProvider.overrideWith(
            () => MockUserLikedPlaylistsNotifier([testPlaylist]),
          ),
          trackAudioProvider.overrideWith(() => MockTrackAudioNotifier()),
          trackSocialProvider.overrideWith(() => MockTrackSocialNotifier()),
          playlistSocialProvider.overrideWith(
            () => MockPlaylistSocialNotifier(),
          ),
        ],
        child: const MaterialApp(home: LikedTracksScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Your Likes'), findsOneWidget);
    expect(find.textContaining('Test Track'), findsOneWidget);
    expect(find.text('Test Playlist'), findsOneWidget);
  });

  testWidgets('LikedTracksScreen shows empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          trackCollectionProvider.overrideWith(
            () => MockTrackCollectionNotifier([]),
          ),
          playlist_providers.userLikedPlaylistsProvider.overrideWith(
            () => MockUserLikedPlaylistsNotifier([]),
          ),
          trackAudioProvider.overrideWith(() => MockTrackAudioNotifier()),
        ],
        child: const MaterialApp(home: LikedTracksScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('Tracks and playlists you like will appear here.'),
      findsOneWidget,
    );
  });
}
