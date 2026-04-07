import 'package:flutter_riverpod/flutter_riverpod.dart';

final blockedUsersProvider =
    StateNotifierProvider<BlockedUsersNotifier, Set<int>>(
  (ref) => BlockedUsersNotifier(),
);

class BlockedUsersNotifier extends StateNotifier<Set<int>> {
  BlockedUsersNotifier() : super({});

  bool isBlocked(int userId) => state.contains(userId);

  void block(int userId) {
    state = {...state, userId};
  }

  void unblock(int userId) {
    final newState = {...state};
    newState.remove(userId);
    state = newState;
  }
}