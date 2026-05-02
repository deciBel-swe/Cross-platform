import 'package:dartz/dartz.dart';
import 'package:decibel/core/di/injection.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/engagement/domain/entities/paginated_engagers.dart';
import 'package:decibel/features/engagement/domain/entities/repost_history.dart';
import 'package:decibel/features/engagement/domain/repositories/track_social_repository.dart';
import 'package:decibel/features/library/domain/entities/paginated_tracks.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/playlists/domain/entities/playlist.dart';
import 'package:decibel/features/playlists/domain/entities/playlist_metadata.dart';
import 'package:decibel/features/playlists/domain/repositories/i_playlist_repository.dart';
import 'package:decibel/features/settings/domain/entities/message_resource_preview.dart'
    as domain_resource;
import 'package:decibel/features/settings/presentation/widgets/message_resource_items.dart';
import 'package:decibel/features/settings/presentation/widgets/message_resource_marker.dart'
    as widget_marker;
import 'package:decibel/features/settings/presentation/widgets/message_resource_picker_sheet.dart';
import 'package:decibel/features/settings/presentation/widgets/message_resource_states.dart';
import 'package:decibel/features/settings/presentation/widgets/message_resource_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../settings_test_helpers.dart';

void main() {
  setUp(() async {
    await getIt.reset();
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget app(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(body: child),
      ),
    );
  }

  group('resource marker helpers', () {
    test('domain resource content round-trips through the parser', () {
      final content = domain_resource.buildResourceMessageContent(
        resourceType: 'PLAYLIST',
        resourceId: 42,
        title: 'Playlist',
        subtitle: 'Owner',
        imageUrl: 'https://example.com/image.jpg',
        text: 'check this',
      );

      final parsed = domain_resource.parseMessageResourceContent(content);

      expect(parsed.cleanText, 'check this');
      expect(parsed.resourceType, 'PLAYLIST');
      expect(parsed.resourceId, 42);
      expect(parsed.displayTitle, 'Playlist');
      expect(parsed.inboxPreviewText, 'Playlist');
    });

    test('widget marker parser supports full and legacy marker formats', () {
      final content = widget_marker.buildResourceMessageContent(
        resourceType: 'TRACK',
        resourceId: 9,
        title: 'Track',
        subtitle: 'Artist',
        text: 'listen',
      );

      final full = widget_marker.parseMessageResourceContent(content);
      final legacy = widget_marker.parseMessageResourceContent(
        'old [[DECIBEL_RESOURCE:PLAYLIST:5]]',
      );

      expect(full.cleanText, 'listen');
      expect(full.resourceType, 'TRACK');
      expect(full.resourceId, 9);
      expect(legacy.cleanText, 'old');
      expect(legacy.resourceType, 'PLAYLIST');
      expect(legacy.resourceId, 5);
    });

    test('invalid marker content falls back to plain text', () {
      final parsed = widget_marker.parseMessageResourceContent(
        'broken [[DECIBEL_RESOURCE_FULL:not-valid]]',
      );

      expect(parsed.cleanText, contains('broken'));
      expect(parsed.hasResource, isFalse);
    });
  });

  group('resource picker item widgets', () {
    testWidgets(
      'MessageTrackResourceTile renders track details and selection',
      (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          app(
            MessageTrackResourceTile(
              track: track(title: 'A song', artistName: 'A singer'),
              selected: true,
              onTap: () => tapped = true,
            ),
          ),
        );

        expect(find.text('A song'), findsOneWidget);
        expect(find.text('A singer'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsOneWidget);

        await tester.tap(find.text('A song'));
        expect(tapped, isTrue);
      },
    );

    testWidgets('MessagePlaylistResourceTile renders playlist details', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          MessagePlaylistResourceTile(
            playlist: playlist(title: 'A playlist', trackCount: 1),
            selected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('A playlist'), findsOneWidget);
      expect(find.text('1 track'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('MessageResourceTitleSubtitle ellipsizes title and subtitle', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const MessageResourceTitleSubtitle(
            title: 'Title',
            subtitle: 'Subtitle',
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
    });

    testWidgets('resource empty and error states render centered text', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const Column(
            children: [
              Expanded(child: MessageResourceEmptyState(text: 'Nothing here')),
              Expanded(child: MessageResourceErrorState(text: 'Load failed')),
            ],
          ),
        ),
      );

      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Load failed'), findsOneWidget);
    });

    testWidgets('MessageLikedTracksTab selects a liked track', (tester) async {
      getIt.registerSingleton<ITrackSocialRepository>(
        _FakeTrackSocialRepository([track(title: 'Liked song')]),
      );

      MessageResourceSelection? selected;
      await tester.pumpWidget(
        app(
          MessageLikedTracksTab(
            isSelected: (type, id) => false,
            onSelect: (selection) => selected = selection,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Liked song'));

      expect(selected?.resourceType, 'TRACK');
      expect(selected?.title, 'Liked song');
    });

    testWidgets('MessageResourcePickerSheet returns the selected liked track', (
      tester,
    ) async {
      getIt.registerSingleton<ITrackSocialRepository>(
        _FakeTrackSocialRepository([track(title: 'Picker song')]),
      );
      getIt.registerSingleton<IPlaylistRepository>(
        _FakePlaylistRepository([playlist(title: 'Picker playlist')]),
      );

      MessageResourceSelection? result;
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await MessageResourcePickerSheet.show(context);
                },
                child: const Text('open picker'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('open picker'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Picker song'));
      await tester.pump();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(result?.resourceType, 'TRACK');
      expect(result?.title, 'Picker song');
    });
  });
}

class _FakeTrackSocialRepository implements ITrackSocialRepository {
  const _FakeTrackSocialRepository(this.tracks);

  final List<Track> tracks;

  @override
  Future<PaginatedTracks> getLikedTracks({
    int page = 0,
    int size = 20,
    int? userId,
    String? username,
  }) async {
    return PaginatedTracks(
      content: tracks.cast(),
      pageNumber: page,
      pageSize: size,
      totalElements: tracks.length,
      totalPages: 1,
      isLast: true,
    );
  }

  @override
  Future<PaginatedTracks> getRepostedTracks({
    int page = 0,
    int size = 20,
    int? userId,
    String? username,
  }) async {
    return PaginatedTracks(
      content: const [],
      pageNumber: page,
      pageSize: size,
      totalElements: 0,
      totalPages: 1,
      isLast: true,
    );
  }

  @override
  Future<void> likeTrack(int trackId) async {}

  @override
  Future<void> reportTrack({
    required int trackId,
    required String reason,
    String? description,
  }) async {}

  @override
  Future<void> repostTrack(int trackId) async {}

  @override
  Future<void> unlikeTrack(int trackId) async {}

  @override
  Future<void> unrepostTrack(int trackId) async {}

  @override
  Future<Either<Failure, PaginatedEngagers>> fetchTrackLikers({
    required int trackId,
    required int page,
    required int size,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> fetchTrackReposters({
    required int trackId,
    required int page,
    required int size,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<PaginatedRepostHistory> getRepostHistory(
    String username, {
    int page = 0,
    int size = 20,
  }) async {
    throw UnimplementedError();
  }
}

class _FakePlaylistRepository implements IPlaylistRepository {
  const _FakePlaylistRepository(this.playlists);

  final List<Playlist> playlists;

  @override
  Future<Either<Failure, List<Playlist>>> getUserPlaylists({
    required int page,
    required int size,
    int? userId,
    String? username,
  }) async {
    return Right(playlists);
  }

  @override
  Future<Either<Failure, void>> addTrackToPlaylist(
    int playlistId,
    int trackId,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Playlist>> createPlaylist(
    PlaylistMetadata metadata,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deletePlaylist(int playlistId) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Playlist>> getPlaylistDetails(int playlistId) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getPlaylistSecretLink(int playlistId) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removeTrackFromPlaylist(
    int playlistId,
    int trackId,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Playlist>> reorderTracks(
    int playlistId,
    List<int> trackIds,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Playlist>> updatePlaylist(
    int playlistId,
    PlaylistMetadata metadata,
  ) async {
    throw UnimplementedError();
  }
}
