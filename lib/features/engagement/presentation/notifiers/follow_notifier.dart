import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/follow_repository.dart';
import '../providers/follow_state_provider.dart';

/// Manages the follow state for a single user, identified by `arg` (userId).
///
/// This is a **family notifier** — each unique userId gets its own instance,
/// meaning follow state is consistent across all widgets that watch the same
/// userId. This is what enables global follow-state sync as required by the
/// acceptance criteria.
///
/// Implements **optimistic updates with rollback**: the UI immediately reflects
/// the toggled state, and reverts if the API call fails.
class FollowNotifier extends FamilyAsyncNotifier<bool, int> {
  /// Builds the initial state for this userId.
  ///
  /// Defaults to `false` (not following). The actual state is set later
  /// via [setInitialState] once the public profile data is fetched.
  @override
  FutureOr<bool> build(int arg) => false;

  /// Sets the initial follow state from the public profile response.
  ///
  /// Called by [PublicProfileNotifier] after fetching the public profile
  /// to synchronize the follow button with the server-known state.
  void setInitialState(bool isFollowing) {
    state = AsyncData(isFollowing);
  }

  /// Toggles the follow state with optimistic update and rollback.
  ///
  /// 1. Immediately flips the state (optimistic).
  /// 2. Makes the API call (follow or unfollow).
  /// 3. On success: updates to server-confirmed state.
  /// 4. On failure: rolls back to the previous state.
  Future<void> toggleFollow() async {
    final current = state.valueOrNull ?? false;
    final desired = !current;

    // Step 1: Optimistic update — user sees the change instantly.
    state = AsyncData(desired);

    // Step 2: Call the API.
    final FollowRepository repository = ref.read(followRepositoryProvider);
    final result = desired
        ? await repository.followUser(arg)
        : await repository.unfollowUser(arg);

    // Step 3/4: Confirm or rollback.
    result.fold(
      (failure) {
        // Rollback to previous state on failure.
        state = AsyncData(current);
      },
      (isFollowing) {
        // Update to server-confirmed state.
        state = AsyncData(isFollowing);
      },
    );
  }
}
