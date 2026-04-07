import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../data/repositories/blocked_users_mock_repository.dart';
import '../../domain/entities/blocked_user.dart';
import '../../domain/repositories/blocked_users_repository.dart';

final blockedUsersRepositoryProvider = Provider<BlockedUsersRepository>((ref) {
  final useMock = dotenv.env['USE_MOCK_SERVICES']?.toLowerCase() == 'true';

  if (useMock) {
    return BlockedUsersMockRepository();
  }

  return getIt<BlockedUsersRepository>();
});

class BlockedUsersState {
  const BlockedUsersState({
    this.users = const <BlockedUser>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isProcessing = false,
    this.hasError = false,
    this.errorMessage,
    this.currentPage = 0,
    this.hasReachedEnd = false,
  });

  final List<BlockedUser> users;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isProcessing;
  final bool hasError;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedEnd;

  BlockedUsersState copyWith({
    List<BlockedUser>? users,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isProcessing,
    bool? hasError,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedEnd,
  }) {
    return BlockedUsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isProcessing: isProcessing ?? this.isProcessing,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class BlockedUsersListNotifier extends Notifier<BlockedUsersState> {
  static const int _pageSize = 20;

  BlockedUsersRepository get _repository =>
      ref.read(blockedUsersRepositoryProvider);

  @override
  BlockedUsersState build() {
    return const BlockedUsersState();
  }

  Future<void> loadInitial() async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
      currentPage: 0,
      hasReachedEnd: false,
      users: <BlockedUser>[],
    );

    try {
      final result = await _repository.getBlockedUsers(
        page: 0,
        size: _pageSize,
      );

      state = state.copyWith(
        users: result.content,
        isLoading: false,
        currentPage: result.pageNumber,
        hasReachedEnd: result.isLast,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load blocked users.',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading ||
        state.isLoadingMore ||
        state.hasReachedEnd ||
        state.hasError) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;

      final result = await _repository.getBlockedUsers(
        page: nextPage,
        size: _pageSize,
      );

      state = state.copyWith(
        users: <BlockedUser>[
          ...state.users,
          ...result.content,
        ],
        isLoadingMore: false,
        currentPage: result.pageNumber,
        hasReachedEnd: result.isLast,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: 'Failed to load more blocked users.',
      );
    }
  }

  Future<bool> unblockUser({
    required int userId,
  }) async {
    if (state.isProcessing) {
      return false;
    }

    state = state.copyWith(isProcessing: true);

    try {
      await _repository.unblockUser(userId: userId);

      state = state.copyWith(
        isProcessing: false,
        users: state.users.where((user) => user.id != userId).toList(),
      );

      return true;
    } catch (_) {
      state = state.copyWith(
        isProcessing: false,
        hasError: true,
        errorMessage: 'Failed to unblock user.',
      );

      return false;
    }
  }

  Future<void> refresh() async {
    await loadInitial();
  }
}

final blockedUsersListProvider =
    NotifierProvider<BlockedUsersListNotifier, BlockedUsersState>(
  BlockedUsersListNotifier.new,
);