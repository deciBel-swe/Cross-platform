import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../engagement/presentation/providers/follow_state_provider.dart';
import '../../domain/entities/public_profile.dart';
import '../providers/block_provider.dart';

/// Fetches and manages the public profile data for a given user identifier.
///
/// This is a family notifier, so each numeric id or username gets its own
/// instance. After a successful fetch, it seeds the corresponding follow state
/// with the server-provided `isFollowing` value so the UI reflects the current
/// relationship immediately.
class PublicProfileNotifier extends FamilyAsyncNotifier<PublicProfile, String> {
  /// Fetches the public profile for the user identified by [arg].
  ///
  /// On success, seeds the follow state provider with the initial
  /// `isFollowing` value from the API response.
  @override
  FutureOr<PublicProfile> build(String arg) async {
    final repository = ref.read(followRepositoryProvider);
    final result = await repository.getPublicProfile(arg);

    return result.fold((failure) => throw failure, (profile) {
      if (profile.isBlocked) {
        ref.read(blockedUsersProvider.notifier).markBlockedLocally(profile.id);
      } else {
        ref
            .read(blockedUsersProvider.notifier)
            .markUnblockedLocally(profile.id);
      }

      // Seed the follow state provider with the initial value from the profile.
      ref
          .read(followStateProvider(profile.id).notifier)
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
          ref
              .read(blockedUsersProvider.notifier)
              .markBlockedLocally(profile.id);
        } else {
          ref
              .read(blockedUsersProvider.notifier)
              .markUnblockedLocally(profile.id);
        }

        ref
            .read(followStateProvider(profile.id).notifier)
            .setInitialState(profile.isFollowing);
        state = AsyncData(profile);
      },
    );
  }
}
