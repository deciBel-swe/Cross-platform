import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../engagement/presentation/providers/track_social_provider.dart';
import '../../../engagement/presentation/providers/follow_state_provider.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/public_profile.dart';
import '../notifiers/public_profile_notifier.dart';

/// Family provider that fetches and caches a public profile by userId.
///
/// Triggers the initial fetch on first watch, and seeds the
/// [followStateProvider] with the correct `isFollowing` value.
///
/// Usage:
/// ```dart
/// final profileAsync = ref.watch(publicProfileProvider(userId));
/// ```
final publicProfileProvider =
    AsyncNotifierProvider.family<PublicProfileNotifier, PublicProfile, int>(
      PublicProfileNotifier.new,
    );

/// Refetches only public-profile snapshot data when follow/unfollow succeeds.
///
/// Used for lightweight count updates in the header without refreshing
/// the whole page state.
final publicProfileSnapshotProvider = FutureProvider.autoDispose
    .family<PublicProfile, int>((ref, userId) async {
      ref.watch(followRefreshTickProvider);

      final repository = ref.read(followRepositoryProvider);
      final result = await repository.getPublicProfile(userId);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (profile) => profile,
      );
    });

final publicLikedTracksProvider = FutureProvider.autoDispose
    .family<List<Track>, int>((ref, userId) async {
      final repository = ref.read(trackSocialRepositoryProvider);
      final page = await repository.getLikedTracks(
        page: 0,
        size: 3,
        userId: userId,
      );
      return page.content;
    });

final publicRepostedTracksProvider = FutureProvider.autoDispose
    .family<List<Track>, int>((ref, userId) async {
      final repository = ref.read(trackSocialRepositoryProvider);
      final page = await repository.getRepostedTracks(
        page: 0,
        size: 3,
        userId: userId,
      );
      return page.content;
    });
