import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/blocked_user.dart';

part 'blocked_users_state.freezed.dart';

@freezed
class BlockedUsersState with _$BlockedUsersState {
  const factory BlockedUsersState({
    @Default([]) List<BlockedUser> users,
    @Default(false) bool isLoading,
    @Default(0) int currentPage,
    @Default(false) bool hasReachedMax,
    @Default({}) Set<String> unblockingIds, 
    String? errorMessage,
  }) = _BlockedUsersState;
}