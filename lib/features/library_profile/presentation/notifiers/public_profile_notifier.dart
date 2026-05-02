import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../engagement/presentation/providers/follow_state_provider.dart';
import '../../domain/entities/public_profile.dart';
import '../providers/block_provider.dart';

/// Fetches and manages the public profile data for a given userId.
///
/// This is a **family notifier** — each userId gets its own instance.
/// After a successful fetch, it initializes the corresponding
/// [FollowNotifier] with the server-provided `isFollowing` value so
/// the [FollowButton] immediately reflects the correct state.
class PublicProfileNotifier extends FamilyAsyncNotifier<PublicProfile, int> {
  /// Fetches the public profile for the user identified by `arg`.
  ///
  /// On success, seeds the follow state provider with the initial
  /// `isFollowing` value from the API response.
  @override
  FutureOr<PublicProfile> build(int arg) async {
    final repository = ref.read(followRepositoryProvider);
    final result = await repository.getPublicProfile(arg);

    return result.fold((failure) => throw failure, (profile) {
      if (profile.isBlocked) {
        ref.read(blockedUsersProvider.notifier).markBlockedLocally(profile.id);
      } else {
        ref.read(blockedUsersProvider.notifier).markUnblockedLocally(profile.id);
      }

      // Seed the follow state provider with the initial value from the profile.
      ref
          .read(followStateProvider(arg).notifier)
          .setInitialState(profile.isFollowing);
      return profile;
    });
  }

  /// Re-fetches the public profile data and updates state accordingly.
  ///
  /// Keeps the previous data visible during the refresh to avoid
  /// a loading flash. Only updates on success.
  Future<void> refreshProfile() async {
    final repository = ref.read(followRepositoryProvider);
    final result = await repository.getPublicProfile(arg);

    result.fold(
      (failure) {
        // Keep previous data if available; only set error on first load.
        if (state.valueOrNull == null) {
          state = AsyncError(failure, StackTrace.current);
        }
      },
      (profile) {
        if (profile.isBlocked) {
          ref.read(blockedUsersProvider.notifier).markBlockedLocally(profile.id);
        } else {
          ref.read(blockedUsersProvider.notifier).markUnblockedLocally(profile.id);
        }

        ref
            .read(followStateProvider(arg).notifier)
            .setInitialState(profile.isFollowing);
        state = AsyncData(profile);
      },
    );
  }
}
