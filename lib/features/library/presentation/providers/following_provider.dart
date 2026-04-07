import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/social_graph_mock_repository.dart';
import '../../domain/entities/following_user.dart';
import '../../domain/repositories/social_graph_repository.dart';

final socialGraphRepositoryProvider = Provider<SocialGraphRepository>((ref) {
  final useMock = dotenv.env['USE_MOCK_SERVICES']?.toLowerCase() == 'true';

  if (useMock) {
    return SocialGraphMockRepository();
  }

  return getIt<SocialGraphRepository>();
});

class FollowingState {
  const FollowingState({
    this.users = const <FollowingUser>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage,
    this.currentPage = 0,
    this.hasReachedEnd = false,
  });

  final List<FollowingUser> users;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedEnd;

  FollowingState copyWith({
    List<FollowingUser>? users,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedEnd,
  }) {
    return FollowingState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class FollowingNotifier extends Notifier<FollowingState> {
  static const int _pageSize = 20;

  late final SocialGraphRepository _repository;

  @override
  FollowingState build() {
    _repository = ref.read(socialGraphRepositoryProvider);
    Future.microtask(loadInitial);
    return const FollowingState();
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
      users: <FollowingUser>[],
    );

    try {
      final authState = await ref.read(authStateProvider.future);
      final userId = _extractAuthenticatedUserId(authState);

      final result = await _repository.getFollowingUsers(
        userId: userId,
        page: 0,
        size: _pageSize,
      );

      state = state.copyWith(
        users: result.content,
        isLoading: false,
        currentPage: result.pageNumber,
        hasReachedEnd: result.isLast,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load following users.',
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
      final authState = await ref.read(authStateProvider.future);
      final userId = _extractAuthenticatedUserId(authState);

      final nextPage = state.currentPage + 1;

      final result = await _repository.getFollowingUsers(
        userId: userId,
        page: nextPage,
        size: _pageSize,
      );

      state = state.copyWith(
        users: <FollowingUser>[...state.users, ...result.content],
        isLoadingMore: false,
        currentPage: result.pageNumber,
        hasReachedEnd: result.isLast,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: 'Failed to load more following users.',
      );
    }
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  int _extractAuthenticatedUserId(AuthState authState) {
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }

    throw Exception('User is not authenticated');
  }
}

final followingProvider = NotifierProvider<FollowingNotifier, FollowingState>(
  FollowingNotifier.new,
);
