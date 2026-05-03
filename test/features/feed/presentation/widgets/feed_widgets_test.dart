import 'dart:async';
import 'package:decibel/features/engagement/domain/models/track_action_data.dart';
import 'package:decibel/features/engagement/presentation/notifiers/track_action_notifier.dart';
import 'package:decibel/features/engagement/presentation/providers/track_social_provider.dart';
import 'package:decibel/features/feed/domain/entities/feed_item_type.dart';
import 'package:decibel/features/feed/domain/entities/feed_track.dart';
import 'package:decibel/features/feed/presentation/widgets/feed_item.dart';
import 'package:decibel/features/feed/presentation/widgets/mobile_discover_track_page.dart';
import 'package:decibel/features/feed/presentation/widgets/mobile_feed_track_card.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart' as lib_track;
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockTrackSocialNotifier extends FamilyAsyncNotifier<TrackSocialData, int>
    with Mock
    implements TrackSocialNotifier {
  MockTrackSocialNotifier(this.initialState);
  final TrackSocialData initialState;

  @override
  FutureOr<TrackSocialData> build(int arg) => initialState;
}

void main() {
  final tTrack = lib_track.Track(
    id: 1,
    title: 'Test Track',
    artist: const Artist(id: 1, username: 'testartist'),
    genre: 'Rock',
    tags: const [],
    state: TrackStatus.finished,
    releaseDate: DateTime.now(),
    playCount: 0,
    likeCount: 0,
    repostCount: 0,
    isLiked: false,
    isReposted: false,
    createdAt: DateTime.now(),
    trackDurationSeconds: 180,
  );

  group('MobileFeedTrackCard', () {
    testWidgets('renders all track information correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialProvider.overrideWith(
              () => MockTrackSocialNotifier(
                const TrackSocialData(
                  isLiked: false,
                  likeCount: 10,
                  isReposted: false,
                  repostCount: 5,
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MobileFeedTrackCard(
                trackId: 1,
                title: 'Summer Vibes',
                artist: 'Beach Boys',
                duration: '3:45',
                likeCount: 10,
                repostCount: 5,
                isLiked: false,
                isReposted: false,
                commentCount: 2,
                commentTrack: tTrack,
                gradientColors: const [Colors.blue, Colors.green],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Summer Vibes'), findsOneWidget);
      expect(find.text('Beach Boys'), findsOneWidget);
      expect(find.text('3:45'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('triggers onPlay when tapping play button', (tester) async {
      bool playTapped = false;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialProvider.overrideWith(
              () => MockTrackSocialNotifier(
                const TrackSocialData(
                  isLiked: false,
                  likeCount: 0,
                  isReposted: false,
                  repostCount: 0,
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MobileFeedTrackCard(
                trackId: 1,
                title: 'Track',
                artist: 'Artist',
                onPlay: () => playTapped = true,
                duration: '3:00',
                likeCount: 0,
                repostCount: 0,
                isLiked: false,
                isReposted: false,
                commentCount: 0,
                commentTrack: tTrack,
                gradientColors: const [Colors.red, Colors.orange],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      expect(playTapped, isTrue);
    });
  });

  group('FeedItem', () {
    testWidgets('renders track posted feed item correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialProvider.overrideWith(
              () => MockTrackSocialNotifier(
                const TrackSocialData(
                  isLiked: false,
                  likeCount: 0,
                  isReposted: false,
                  repostCount: 0,
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FeedItem(
                trackId: 1,
                userName: 'User1',
                action: 'posted a track',
                trackTitle: 'New Sound',
                trackArtist: 'DJ Test',
                timeAgo: '2h',
                genre: 'Electronic',
                likeCount: 100,
                repostCount: 20,
                isLiked: false,
                isReposted: false,
                plays: '1K',
                commentCount: 10,
                duration: '4:20',
                waveformPeaks: const [0.1, 0.5, 0.2],
                commentTrack: tTrack,
                feedItemType: FeedItemType.trackPosted,
              ),
            ),
          ),
        ),
      );

      expect(find.textContaining('User1 posted a track'), findsOneWidget);
      expect(find.text('New Sound'), findsOneWidget);
      expect(find.text('DJ Test'), findsOneWidget);
    });

    testWidgets('renders desktop layout correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialProvider.overrideWith(
              () => MockTrackSocialNotifier(
                const TrackSocialData(
                  isLiked: false,
                  likeCount: 0,
                  isReposted: false,
                  repostCount: 0,
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MediaQuery(
                data: const MediaQueryData(
                  size: Size(1600, 1200),
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                  viewInsets: EdgeInsets.zero,
                  devicePixelRatio: 1.0,
                ),
                child: FeedItem(
                  trackId: 1,
                  userName: 'User1',
                  action: 'posted a track',
                  trackTitle: 'New Sound',
                  trackArtist: 'DJ Test',
                  timeAgo: '2h',
                  genre: 'Electronic',
                  likeCount: 100,
                  repostCount: 20,
                  isLiked: false,
                  isReposted: false,
                  plays: '1K',
                  commentCount: 10,
                  duration: '4:20',
                  waveformPeaks: const [0.1, 0.5, 0.2],
                  commentTrack: tTrack,
                  feedItemType: FeedItemType.trackPosted,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('#Electronic'), findsOneWidget); // Genre chip on desktop
      expect(find.text('1K'), findsOneWidget); // Plays on desktop
    });

    testWidgets('renders playlist posted feed item correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialProvider.overrideWith(
              () => MockTrackSocialNotifier(
                const TrackSocialData(
                  isLiked: false,
                  likeCount: 0,
                  isReposted: false,
                  repostCount: 0,
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: FeedItem(
                trackId: 0,
                userName: 'User2',
                action: 'created a playlist',
                trackTitle: '',
                trackArtist: '',
                timeAgo: '1d',
                genre: '',
                likeCount: 0,
                repostCount: 0,
                isLiked: false,
                isReposted: false,
                plays: '',
                commentCount: 0,
                duration: '',
                waveformPeaks: const [],
                commentTrack: tTrack,
                feedItemType: FeedItemType.playlistPosted,
                playlistData: const {
                  'title': 'My Favorites',
                  'trackCount': 15,
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('My Favorites'), findsOneWidget);
      expect(find.text('15 tracks'), findsOneWidget);
    });
  });

  group('MobileDiscoverTrackPage', () {
    final tFeedTrack = FeedTrack(
      id: 1,
      title: 'Deep House 101',
      artistId: 1,
      artistUsername: 'djtest',
      genre: 'Electronic',
      access: 'PLAYABLE',
      isReposted: false,
      isLiked: false,
      tags: [],
      releaseDate: DateTime.now(),
      playCount: 100,
      likeCount: 10,
      repostCount: 2,
      commentCount: 5,
      isPrivate: false,
      uploadDate: DateTime.now(),
      trackDurationSeconds: 300,
    );

    testWidgets('renders track information correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialProvider.overrideWith(
              () => MockTrackSocialNotifier(
                const TrackSocialData(
                  isLiked: false,
                  likeCount: 10,
                  isReposted: false,
                  repostCount: 2,
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MobileDiscoverTrackPage(
                track: tFeedTrack,
                playableTrack: tTrack,
                playableQueue: [tTrack],
                gradientColors: const [Colors.purple, Colors.blue],
                onPlayTrack: (t, q) async {},
                onAddToPlaylist: (t) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('@djtest'), findsOneWidget);
      expect(find.text('Deep House 101'), findsOneWidget);
      expect(find.text('Electronic'), findsOneWidget);
    });

    testWidgets('calls onPlayTrack when play button is pressed', (tester) async {
      bool onPlayCalled = false;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trackSocialProvider.overrideWith(
              () => MockTrackSocialNotifier(
                const TrackSocialData(
                  isLiked: false,
                  likeCount: 0,
                  isReposted: false,
                  repostCount: 0,
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MobileDiscoverTrackPage(
                track: tFeedTrack,
                playableTrack: tTrack,
                playableQueue: [tTrack],
                gradientColors: const [Colors.purple, Colors.blue],
                onPlayTrack: (t, q) async {
                  onPlayCalled = true;
                },
                onAddToPlaylist: (t) {},
              ),
            ),
          ),
        ),
      );

      // Tap the play button
      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      expect(onPlayCalled, isTrue);
    });
  });
}
