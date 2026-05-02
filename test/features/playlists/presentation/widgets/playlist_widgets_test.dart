import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/core/router/route_paths.dart';
import 'package:decibel/core/storage/shared_prefs_service.dart';
import 'package:decibel/core/widgets/decibel_cached_image.dart';
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/domain/entities/auth_user.dart';
import 'package:decibel/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/engagement/domain/repositories/playlist_social_repository.dart';
import 'package:decibel/features/engagement/domain/repositories/track_social_repository.dart';
import 'package:decibel/features/engagement/presentation/providers/playlist_social_provider.dart';
import 'package:decibel/features/engagement/presentation/providers/track_social_provider.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/library_profile/domain/repositories/track_repository.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_repository_provider.dart';
import 'package:decibel/features/playlists/domain/entities/playlist.dart';
import 'package:decibel/features/playlists/domain/entities/playlist_metadata.dart';
import 'package:decibel/features/playlists/domain/repositories/i_playlist_repository.dart';
import 'package:decibel/features/playlists/presentation/providers/user_playlists_provider.dart';
import 'package:decibel/features/playlists/presentation/notifiers/playlist_form_notifier.dart';
import 'package:decibel/features/playlists/presentation/widgets/create_playlist_bottom_sheet.dart';
import 'package:decibel/features/playlists/presentation/widgets/delete_playlist_dialog.dart';
import 'package:decibel/features/playlists/presentation/widgets/playlist_action_buttons.dart';
import 'package:decibel/features/playlists/presentation/widgets/playlist_details_tab.dart';
import 'package:decibel/features/playlists/presentation/widgets/playlist_options_bottom_sheet.dart';
import 'package:decibel/features/playlists/presentation/widgets/playlist_square_card.dart';
import 'package:decibel/features/playlists/presentation/widgets/playlist_tile.dart';
import 'package:decibel/features/playlists/presentation/widgets/playlist_tracks_tab.dart';
import 'package:decibel/features/playlists/presentation/widgets/share_options_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockPlaylistRepository extends Mock implements IPlaylistRepository {}

class MockTrackRepository extends Mock implements TrackRepository {}

class MockTrackSocialRepository extends Mock
    implements ITrackSocialRepository {}

class MockPlaylistSocialRepository extends Mock
  implements IPlaylistSocialRepository {}

class MockSharedPrefsService extends Mock implements SharedPrefsService {}

class FakeUnauthenticatedAuthNotifier extends AuthNotifier {
  @override
  FutureOr<AuthState> build() async {
    return const AuthUnauthenticated();
  }
}

class FakeAuthenticatedAuthNotifier extends AuthNotifier {
  FakeAuthenticatedAuthNotifier(this.user);

  final AuthUser user;

  @override
  FutureOr<AuthState> build() async {
    return AuthAuthenticated(user: user);
  }
}

void main() {
  late MockPlaylistRepository playlistRepository;
  late MockTrackRepository trackRepository;
  late MockTrackSocialRepository trackSocialRepository;
  late MockPlaylistSocialRepository playlistSocialRepository;
  late MockSharedPrefsService sharedPrefsService;

  setUpAll(() {
    registerFallbackValue(
      const PlaylistMetadata(title: 'fallback', description: ''),
    );
  });

  setUp(() {
    playlistRepository = MockPlaylistRepository();
    trackRepository = MockTrackRepository();
    trackSocialRepository = MockTrackSocialRepository();
    playlistSocialRepository = MockPlaylistSocialRepository();
    sharedPrefsService = MockSharedPrefsService();

    when(
      () => playlistRepository.getUserPlaylists(page: 0, size: 20),
    ).thenAnswer((_) async => Right([_playlist(id: 1, title: 'Focus')]));
    when(
      () => playlistRepository.getPlaylistDetails(any()),
    ).thenAnswer((invocation) async {
      final playlistId = invocation.positionalArguments.first as int;
      return Right(_playlist(id: playlistId, title: 'Focus'));
    });
    when(
      () => playlistRepository.getPlaylistSecretLink(any()),
    ).thenAnswer((_) async => const Right('token-123'));
    when(
      () => playlistRepository.createPlaylist(any()),
    ).thenAnswer((invocation) async {
      final metadata = invocation.positionalArguments.first as PlaylistMetadata;
      return Right(
        _playlist(
          id: 99,
          title: metadata.title,
          isPrivate: metadata.isPrivate,
          description: metadata.description,
        ),
      );
    });
    when(
      () => playlistRepository.updatePlaylist(any(), any()),
    ).thenAnswer((invocation) async {
      final playlistId = invocation.positionalArguments.first as int;
      final metadata = invocation.positionalArguments[1] as PlaylistMetadata;
      return Right(
        _playlist(
          id: playlistId,
          title: metadata.title,
          isPrivate: metadata.isPrivate,
          description: metadata.description,
        ),
      );
    });
    when(
      () => playlistRepository.deletePlaylist(any()),
    ).thenAnswer((_) async => const Right(null));

    when(
      () => playlistSocialRepository.toggleRepost(any(), any()),
    ).thenAnswer((_) async => const Right(true));

    when(
      () => trackRepository.fetchTrackById(any()),
    ).thenAnswer((invocation) async {
      final trackId = invocation.positionalArguments.first as int;
      return Right(_track(id: trackId, title: 'Track $trackId'));
    });

    when(
      () => sharedPrefsService.getLastPrivacySettings(),
    ).thenAnswer((_) async => false);
    when(
      () => sharedPrefsService.saveLastPrivacySettings(any()),
    ).thenAnswer((_) async {});
  });

  Widget buildApp(
    Widget child, {
    List<Override> overrides = const [],
    bool useUnauthenticatedAuth = true,
    bool includeEditRoute = false,
  }) {
    return ProviderScope(
      overrides: [
        playlistRepositoryProvider.overrideWithValue(playlistRepository),
        trackRepositoryProvider.overrideWithValue(trackRepository),
        trackSocialRepositoryProvider.overrideWithValue(trackSocialRepository),
        playlistSocialRepositoryProvider.overrideWithValue(
          playlistSocialRepository,
        ),
        sharedPrefsServiceProvider.overrideWithValue(sharedPrefsService),
        if (useUnauthenticatedAuth)
          authStateProvider.overrideWith(() => FakeUnauthenticatedAuthNotifier()),
        ...overrides,
      ],
      child: MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(body: child),
            ),
            if (includeEditRoute)
              GoRoute(
                path: RoutePaths.editPlaylist,
                builder: (context, state) {
                  return const Scaffold(
                    body: Center(child: Text('Edit playlist screen')),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  testWidgets('PlaylistTile renders playlist summary and opens the sheet', (
    tester,
  ) async {
    final playlist = _playlist(
      id: 1,
      title: 'Focus Mix',
      isPrivate: true,
      trackCount: 0,
      tracks: [_track(id: 1), _track(id: 2)],
    );

    await tester.pumpWidget(buildApp(PlaylistTile(playlist: playlist)));

    expect(find.text('Focus Mix'), findsOneWidget);
    expect(find.text('Aya'), findsOneWidget);
    expect(find.text('Playlist - 2 Tracks'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    expect(find.text('SHARE'), findsOneWidget);
    expect(find.text('Copy Link'), findsOneWidget);
  });

  
  testWidgets('PlaylistTile renders remote cover art', (tester) async {
    await tester.pumpWidget(
      buildApp(
        PlaylistTile(
          playlist: _playlist(
            id: 12,
            title: 'Remote cover',
            coverArt: 'https://example.com/cover.jpg',
          ),
        ),
      ),
    );

    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('PlaylistSquareCard invokes tap and more callbacks', (
    tester,
  ) async {
    var tapped = false;
    var moreTapped = false;

    await tester.pumpWidget(
      buildApp(
        Center(
          child: PlaylistSquareCard(
            playlist: _playlist(
              id: 2,
              title: 'Square Card',
              trackCount: 1,
              tracks: [_track(id: 2, title: 'Track 2')],
            ),
            size: 180,
            onTap: () => tapped = true,
            onMore: () => moreTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Square Card'), findsOneWidget);
    expect(find.text('1 track'), findsOneWidget);

    await tester.tap(find.byType(PlaylistSquareCard));
    await tester.pump();

    await tester.tap(find.byTooltip('More playlist options'));
    await tester.pump();

    expect(tapped, isTrue);
    expect(moreTapped, isTrue);
  });

  testWidgets('PlaylistSquareCard uses a single cover image and default action', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        Center(
          child: PlaylistSquareCard(
            playlist: _playlist(
              id: 20,
              title: 'Single cover',
              tracks: [_track(id: 201, title: 'Track 201', coverUrl: 'https://example.com/cover-201.jpg')],
            ),
            onTap: () {},
            onMore: null,
          ),
        ),
      ),
    );

    expect(find.byType(DecibelCachedImage), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(IconButton),
        matching: find.byIcon(Icons.playlist_play_rounded),
      ),
      findsOneWidget,
    );
  });

  testWidgets('PlaylistSquareCard builds a grid when multiple track covers exist', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        Center(
          child: PlaylistSquareCard(
            playlist: _playlist(
              id: 21,
              title: 'Grid cover',
              tracks: [
                _track(id: 211, title: 'Track 211', coverUrl: 'https://example.com/211.jpg'),
                _track(id: 212, title: 'Track 212', coverUrl: 'https://example.com/212.jpg'),
              ],
            ),
            onTap: () {},
            onMore: () {},
          ),
        ),
      ),
    );

    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('PlaylistActionButtons opens create sheet and saves a playlist', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const PlaylistActionButtons(),
        includeEditRoute: true,
      ),
    );

    await tester.tap(find.text('Create new'));
    await tester.pumpAndSettle();

    expect(find.text('Create playlist'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'New playlist');
    await tester.pump();

    await tester.tap(find.byType(Switch));
    await tester.pump();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    verify(() => sharedPrefsService.saveLastPrivacySettings(true)).called(1);
    verify(() => playlistRepository.createPlaylist(any())).called(1);
    expect(find.text('Create playlist'), findsNothing);
  });

  testWidgets('CreatePlaylistBottomSheet submits from the keyboard', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const PlaylistActionButtons(),
      ),
    );

    await tester.tap(find.text('Create new'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Keyboard submit');
    await tester.pump();

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    verify(() => playlistRepository.createPlaylist(any())).called(1);
    expect(find.text('Create playlist'), findsNothing);
  });

  testWidgets('CreatePlaylistBottomSheet shows an error when create fails', (
    tester,
  ) async {
    when(() => playlistRepository.createPlaylist(any())).thenAnswer(
      (_) async => const Left(ServerFailure('create failed')),
    );

    await tester.pumpWidget(buildApp(const PlaylistActionButtons()));

    await tester.tap(find.text('Create new'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Broken playlist');
    await tester.pump();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('create failed'), findsOneWidget);
  });

  testWidgets('PlaylistDetailsTab updates the seeded form state', (
    tester,
  ) async {
    final playlist = _playlist(
      id: 3,
      title: 'Draft playlist',
      description: 'Initial description',
      isPrivate: true,
    );

    await tester.pumpWidget(buildApp(PlaylistDetailsTab(playlist: playlist)));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.camera_alt), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Updated title');
    await tester.enterText(find.byType(TextFormField).at(1), 'Updated body');
    await tester.pump();

    await tester.tap(find.byType(Switch));
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(PlaylistDetailsTab)),
    );
    final state = container.read(playlistFormProvider(playlist)).value!;

    expect(state.title, 'Updated title');
    expect(state.description, 'Updated body');
    expect(state.isPrivate, false);
  });

  

  testWidgets('PlaylistTracksTab shows an empty state when there are no tracks', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(PlaylistTracksTab(playlist: _playlist(id: 4, title: 'Empty'))),
    );

    expect(find.text('No tracks yet. Add some!'), findsOneWidget);
  });

  testWidgets('PlaylistTracksTab removes a track after dismissal', (
    tester,
  ) async {
    final playlist = _playlist(
      id: 5,
      title: 'Tracks',
      tracks: [
        _track(id: 51, title: 'Track 51'),
        _track(id: 52, title: 'Track 52'),
      ],
    );

    await tester.pumpWidget(buildApp(PlaylistTracksTab(playlist: playlist)));
    await tester.pumpAndSettle();

    expect(find.text('Artist - Track 51'), findsOneWidget);

    await tester.drag(find.text('Artist - Track 51'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Artist - Track 51'), findsNothing);
    expect(find.text('Artist - Track 52'), findsOneWidget);
  });

  testWidgets('ShareOptionsRow copies a link to the clipboard', (tester) async {
    var copied = false;

    await tester.pumpWidget(
      buildApp(
        ShareOptionsRow(
          onCopyLinkTap: () async {
            copied = true;
            return const Right('https://example.com/link');
          },
        ),
      ),
    );

    await tester.tap(find.text('Copy Link'));
    await tester.pumpAndSettle();

    expect(copied, isTrue);
  });

  testWidgets('ShareOptionsRow shows an error when link lookup fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        ShareOptionsRow(
          onCopyLinkTap: () async => const Left(ServerFailure('link failed')),
        ),
      ),
    );

    await tester.tap(find.text('Copy Link'));
    await tester.pumpAndSettle();

    expect(find.text('link failed'), findsOneWidget);
  });

  testWidgets('DeletePlaylistDialog deletes the playlist and closes', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () => DeletePlaylistDialog.show(
                  context,
                  _playlist(id: 6, title: 'Delete me'),
                ),
                child: const Text('Open dialog'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Delete playlist'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    verify(() => playlistRepository.deletePlaylist(6)).called(1);
    expect(find.text('Delete playlist'), findsNothing);
    expect(find.text('Playlist deleted successfully'), findsOneWidget);
  });

  testWidgets('DeletePlaylistDialog shows an error when deletion fails', (
    tester,
  ) async {
    when(() => playlistRepository.deletePlaylist(6)).thenAnswer(
      (_) async => const Left(ServerFailure('delete failed')),
    );

    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () => DeletePlaylistDialog.show(
                  context,
                  _playlist(id: 6, title: 'Delete me'),
                ),
                child: const Text('Open dialog'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('delete failed'), findsOneWidget);
  });

  testWidgets('PlaylistOptionsBottomSheet toggles privacy for the owner', (
    tester,
  ) async {
    final playlist = _playlist(
      id: 7,
      title: 'Owner playlist',
      isPrivate: true,
      owner: const PlaylistOwner(id: 77, username: 'owner'),
    );

    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () => PlaylistOptionsBottomSheet.show(
                  context,
                  playlist,
                ),
                child: const Text('Open options'),
              ),
            );
          },
        ),
        useUnauthenticatedAuth: false,
        overrides: [
          authStateProvider.overrideWith(
            () => FakeAuthenticatedAuthNotifier(
              const AuthUser(
                id: 77,
                username: 'owner',
                tier: UserTier.free,
              ),
            ),
          ),
        ],
      ),
    );

    when(() => playlistRepository.getPlaylistDetails(7)).thenAnswer(
      (_) async => Right(playlist),
    );

    await tester.tap(find.text('Open options'));
    await tester.pumpAndSettle();

    final sheetList = find.byWidgetPredicate(
      (widget) => widget is ListView && widget.scrollDirection == Axis.vertical,
    );

    await tester.drag(sheetList, const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('Edit playlist'), findsOneWidget);
    expect(find.text('Make public'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Make public'));
    await tester.pumpAndSettle();

    verify(() => playlistRepository.updatePlaylist(7, any())).called(1);
    expect(find.text('Playlist is now public'), findsOneWidget);

    await tester.tap(find.text('Open options'));
    await tester.pumpAndSettle();

    await tester.drag(sheetList, const Offset(0, -400));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete playlist'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });

  testWidgets('PlaylistOptionsBottomSheet reposts a playlist for non-owners', (
    tester,
  ) async {
    final playlist = _playlist(
      id: 8,
      title: 'Shared playlist',
      owner: const PlaylistOwner(id: 88, username: 'other-user'),
    );

    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () => PlaylistOptionsBottomSheet.show(
                  context,
                  playlist,
                ),
                child: const Text('Open options 2'),
              ),
            );
          },
        ),
        useUnauthenticatedAuth: false,
        overrides: [
          authStateProvider.overrideWith(
            () => FakeAuthenticatedAuthNotifier(
              const AuthUser(
                id: 1,
                username: 'listener',
                tier: UserTier.free,
              ),
            ),
          ),
        ],
      ),
    );

    when(() => playlistRepository.getPlaylistDetails(8)).thenAnswer(
      (_) async => Right(playlist),
    );
    when(() => playlistSocialRepository.toggleRepost(8, false)).thenAnswer(
      (_) async => const Right(true),
    );

    await tester.tap(find.text('Open options 2'));
    await tester.pumpAndSettle();

    final sheetList = find.byWidgetPredicate(
      (widget) => widget is ListView && widget.scrollDirection == Axis.vertical,
    );

    await tester.drag(sheetList, const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('Repost playlist'), findsOneWidget);
    expect(find.text('Edit playlist'), findsNothing);
    expect(find.text('Delete'), findsNothing);

    await tester.tap(find.text('Repost playlist'));
    await tester.pumpAndSettle();

    verify(() => playlistSocialRepository.toggleRepost(8, false)).called(1);
    expect(find.text('Playlist reposted'), findsOneWidget);
  });
}

Playlist _playlist({
  required int id,
  required String title,
  bool isPrivate = false,
  String? description,
  PlaylistOwner? owner,
  String? coverArt,
  List<Track>? tracks,
  int trackCount = 0,
}) {
  return Playlist(
    id: id,
    title: title,
    description: description,
    type: 'PLAYLIST',
    isPrivate: isPrivate,
    isLiked: false,
    coverArt: coverArt,
    owner: owner ??
        const PlaylistOwner(id: 11, username: 'aya', displayName: 'Aya'),
    tracks: tracks ?? const [],
    totalDurationSeconds: 0,
    trackCount: trackCount,
    createdAt: DateTime(2026, 1, 1),
  );
}

Track _track({
  required int id,
  String title = 'Track',
    String? coverUrl,
}) {
  return Track(
    id: id,
    title: title,
    artist: const Artist(id: 1, username: 'artist', displayName: 'Artist'),
    trackUrl: 'https://example.com/$id.mp3',
    coverUrl: coverUrl,
    genre: 'Pop',
    tags: const [],
    state: TrackStatus.finished,
    releaseDate: DateTime(2026, 1, 1),
    playCount: 1234,
    likeCount: 12,
    repostCount: 3,
    isLiked: false,
    isReposted: false,
    createdAt: DateTime(2026, 1, 1),
    trackDurationSeconds: 120,
  );
}

Future<File> _temporaryPngFile() async {
  final file = File(
    '${Directory.systemTemp.path}/decibel_playlist_cover_${DateTime.now().microsecondsSinceEpoch}.png',
  );

  return file.writeAsBytes(
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO2r8XkAAAAASUVORK5CYII=',
    ),
  );
}