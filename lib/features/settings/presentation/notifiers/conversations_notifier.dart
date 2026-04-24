import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/messaging_providers.dart';
import '../state/conversations_state.dart';

/// Manages the state and business logic of the direct messaging inbox.
///
/// Features:
/// - Fetches initial conversation threads on initialization.
/// - Handles infinite scrolling pagination safely to prevent duplicate requests.
class ConversationsNotifier extends AsyncNotifier<ConversationsState> {
  static const int _pageSize = 20;

  @override
  FutureOr<ConversationsState> build() async {
    return _fetchPage(0);
  }

  Future<ConversationsState> _fetchPage(int page) async {
    final repository = ref.read(messagingRepositoryProvider);
    final response = await repository.getConversations(
      page: page,
      size: _pageSize,
    );

    return ConversationsState(
      conversations: response.content,
      page: response.pageNumber,
      isLast: response.isLast,
    );
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isLast || state.isLoading) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(messagingRepositoryProvider);
      final response = await repository.getConversations(
        page: currentState.page + 1,
        size: _pageSize,
      );

      return currentState.copyWith(
        conversations: [...currentState.conversations, ...response.content],
        page: response.pageNumber,
        isLast: response.isLast,
      );
    });
  }
}
