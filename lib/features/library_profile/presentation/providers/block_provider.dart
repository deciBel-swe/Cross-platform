import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../engagement/presentation/providers/follow_state_provider.dart';
import '../../../settings/presentation/providers/blocked_users_provider.dart';
import '../../domain/entities/blocked_user_summary.dart';
import 'moderation_provider.dart';

final blockedUsersProvider =
    StateNotifierProvider<BlockedUsersNotifier, Set<int>>(
  (ref) => BlockedUsersNotifier(ref),
);

final blockedUserProfilesProvider =
    StateNotifierProvider<BlockedUserProfilesNotifier, List<BlockedUserSummary>>(
  (ref) => BlockedUserProfilesNotifier(),
);

class BlockedUsersNotifier extends StateNotifier<Set<int>> {
  BlockedUsersNotifier(this.ref) : super(<int>{});

  final Ref ref;

  bool isBlocked(int userId) => state.contains(userId);

  void syncFromBackend(List<BlockedUserSummary> users) {
    state = users.map((user) => user.id).toSet();
    ref.read(blockedUserProfilesProvider.notifier).setAll(users);
  }

  Future<void> block(
    int userId, {
    required String username,
    String? avatarUrl,
  }) async {
    final repository = ref.read(moderationRepositoryProvider);
    await repository.blockUser(userId);

    try {
      ref.read(followStateProvider(userId).notifier).forceState(false);
      await ref.read(followRepositoryProvider).unfollowUser(userId);
    } catch (_) {
      // Ignore if not following or unfollow fails
    }

    state = {...state, userId};

    ref.read(blockedUserProfilesProvider.notifier).upsert(
          BlockedUserSummary(
            id: userId,
            username: username,
            avatarUrl: avatarUrl,
          ),
        );

    ref.invalidate(blockedUsersListProvider);
  }

  Future<void> unblock(int userId) async {
    final repository = ref.read(moderationRepositoryProvider);
    await repository.unblockUser(userId);

    final newState = {...state};
    newState.remove(userId);
    state = newState;

    ref.read(blockedUserProfilesProvider.notifier).remove(userId);

    ref.invalidate(blockedUsersListProvider);
  }

  void markUnblockedLocally(int userId) {
    final newState = {...state};
    newState.remove(userId);
    state = newState;

    ref.read(blockedUserProfilesProvider.notifier).remove(userId);
  }

  void markBlockedLocally(int userId) {
    state = {...state, userId};
  }
}

class BlockedUserProfilesNotifier
    extends StateNotifier<List<BlockedUserSummary>> {
  BlockedUserProfilesNotifier() : super(const []);

  void upsert(BlockedUserSummary user) {
    final index = state.indexWhere((item) => item.id == user.id);

    if (index == -1) {
      state = [...state, user];
      return;
    }

    final updated = [...state];
    updated[index] = user;
    state = updated;
  }

  void remove(int userId) {
    state = state.where((user) => user.id != userId).toList();
  }

  void setAll(List<BlockedUserSummary> users) {
    state = users;
  }

  void clear() {
    state = const [];
  }
}