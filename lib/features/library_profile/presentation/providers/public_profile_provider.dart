import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../engagement/presentation/providers/follow_state_provider.dart';
import '../../../engagement/presentation/providers/track_social_provider.dart';
import '../../../library/domain/entities/track.dart';
import '../../../playlists/domain/entities/playlist.dart';
import '../../../playlists/presentation/providers/user_playlists_provider.dart';
import '../../domain/entities/public_profile.dart';
import '../notifiers/public_profile_notifier.dart';

/// Family provider that fetches and caches a public profile by user identifier.
///
/// Triggers the initial fetch on first watch, and seeds the
/// [followStateProvider] with the correct `isFollowing` value.
///
/// Usage:
/// ```dart
/// final profileAsync = ref.watch(publicProfileProvider(userIdentifier));
/// ```
final publicProfileProvider =
    AsyncNotifierProvider.family<PublicProfileNotifier, PublicProfile, String>(
      PublicProfileNotifier.new,
    );

/// Refetches only public-profile snapshot data when follow/unfollow succeeds.
///
/// Used for lightweight count updates in the header without refreshing
/// the whole page state.
final publicProfileSnapshotProvider = FutureProvider.autoDispose
    .family<PublicProfile, String>((ref, userIdentifier) async {
      ref.watch(followRefreshTickProvider);

      final repository = ref.read(followRepositoryProvider);
      final result = await repository.getPublicProfile(userIdentifier);

      return result.fold((failure) => throw failure, (profile) => profile);
    });

final publicLikedTracksProvider = FutureProvider.autoDispose
    .family<List<Track>, String>((ref, username) async {
      final repository = ref.read(trackSocialRepositoryProvider);
      try {
        final page = await repository.getLikedTracks(
          page: 0,
          size: 100,
          username: username,
        );
        return page.content;
      } on NetworkException {
        return const <Track>[];
      }
    });

final publicRepostedTracksProvider = FutureProvider.autoDispose
    .family<List<Track>, String>((ref, username) async {
      final repository = ref.read(trackSocialRepositoryProvider);
      try {
        final page = await repository.getRepostedTracks(
          page: 0,
          size: 100,
          username: username,
        );
        return page.content;
      } on NetworkException {
        return const <Track>[];
      }
    });

final publicPlaylistsProvider = FutureProvider.autoDispose
    .family<List<Playlist>, String>((ref, username) async {
      final repository = ref.read(playlistRepositoryProvider);
      final result = await repository.getUserPlaylists(
        page: 0,
        size: 100,
        username: username,
      );

      return result.fold(
        (failure) => const <Playlist>[],
        (playlists) => playlists.where((p) => !p.isPrivate).toList(),
      );
    });
