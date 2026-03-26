import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/blocked_user_repository.dart';
import '../states/blocked_users_state.dart';



class BlockedUsersNotifier extends Notifier<BlockedUsersState> {
  late final IBlockedUserRepository _repository;

 @override
  BlockedUsersState build() {
    _repository = getIt<IBlockedUserRepository>(); 


    return const BlockedUsersState();
  }
  Future<void> fetchBlockedUsers() async {
    // Prevent fetching if already loading or no more data
    if (state.isLoading || state.hasReachedMax) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _repository.getBlockedUsers(
        page: state.currentPage,
        size: 10, 
      );

      state = state.copyWith(
        users: [...state.users, ...result.users],
        isLoading: false,
        currentPage: state.currentPage + 1,
        hasReachedMax: result.isLast, 
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        errorMessage: "Failed to load users.",
      );
    }
  }

  Future<void> unblockUser(int userId) async {
    final previousUsers = [...state.users];
    final userIdString = userId.toString();

    // Optimistic Update
    state = state.copyWith(
      users: state.users.where((u) => u.id != userId).toList(),
      unblockingIds: {...state.unblockingIds, userIdString},
    );

    try {
      await _repository.unblockUser(userId);
      state = state.copyWith(
        unblockingIds: state.unblockingIds.where((id) => id != userIdString).toSet(),
      );
    } catch (e) {
      // Rollback
      state = state.copyWith(
        users: previousUsers,
        unblockingIds: state.unblockingIds.where((id) => id != userIdString).toSet(),
        errorMessage: "Could not unblock user.",
      );
    }
  }
}
