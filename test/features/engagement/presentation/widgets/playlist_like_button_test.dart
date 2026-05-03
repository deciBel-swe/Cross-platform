import 'dart:async';
import 'package:decibel/features/engagement/domain/models/playlist_social_data.dart';
import 'package:decibel/features/engagement/presentation/notifiers/playlist_social_notifier.dart';
import 'package:decibel/features/engagement/presentation/providers/playlist_social_provider.dart';
import 'package:decibel/features/engagement/presentation/widgets/playlist_like_button.dart';
import 'package:decibel/features/engagement/presentation/widgets/social_action_button.dart';
import 'package:decibel/features/playlists/domain/entities/playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPlaylistSocialNotifier
    extends FamilyAsyncNotifier<PlaylistSocialData, int>
    with Mock
    implements PlaylistSocialNotifier {
  MockPlaylistSocialNotifier({this.data});
  final PlaylistSocialData? data;

  @override
  FutureOr<PlaylistSocialData> build(int arg) {
    return data ?? const PlaylistSocialData(isLiked: false, isReposted: false);
  }

  @override
  Future<void> toggleLike() async {}
}

void main() {
  const playlistId = 1;
  const playlist = Playlist(
    id: playlistId,
    title: 'Test Playlist',
    type: 'public',
    isPrivate: false,
    isLiked: false,
    tracks:  [],
    totalDurationSeconds: 0,
    trackCount: 0,
  );

  group('PlaylistLikeButton', () {
    testWidgets('reacts to tap', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            playlistSocialProvider.overrideWith(
              () => MockPlaylistSocialNotifier(
                data: const PlaylistSocialData(
                  isLiked: false,
                  isReposted: false,
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: PlaylistLikeButton(playlist: playlist)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(SocialActionButton));
      await tester.pump();
    });

    testWidgets('shows active state when isLiked is true', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            playlistSocialProvider.overrideWith(
              () => MockPlaylistSocialNotifier(
                data: const PlaylistSocialData(
                  isLiked: true,
                  isReposted: false,
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: PlaylistLikeButton(playlist: playlist)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.favorite);
    });
  });
}
