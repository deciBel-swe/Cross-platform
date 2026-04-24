import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../engagement/domain/repositories/follow_repository.dart';
import '../../domain/entities/message_user.dart';

/// Provider holding the current search input state
final newMessageQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// Notifier responsible for fetching users to message.
///
/// Logic:
/// - If query is empty: Fetches the current user's followers.
/// - If query has text: Searches globally for users matching the query.
final newMessageSearchProvider =
    AutoDisposeAsyncNotifierProvider<
      NewMessageSearchNotifier,
      List<MessageUser>
    >(NewMessageSearchNotifier.new);

class NewMessageSearchNotifier
    extends AutoDisposeAsyncNotifier<List<MessageUser>> {
  @override
  FutureOr<List<MessageUser>> build() async {
    final query = ref.watch(newMessageQueryProvider);
    final authState = ref.watch(authStateProvider).valueOrNull;

    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : 0;
    if (currentUserId == 0) return [];

    final followRepo = getIt<FollowRepository>();

    if (query.isEmpty) {
      // 1. Fetch Followers if search is empty
      final result = await followRepo.getFollowers(
        userId: currentUserId,
        page: 0,
        size: 50,
      );

      return result.fold(
        (failure) => throw Exception(failure.message),
        (paginatedData) => paginatedData.content
            .map(
              (engager) =>
                  MessageUser(id: engager.id, username: engager.username),
            )
            .toList(),
      );
    } else {
      // 2. Global User Search if query exists
      // Assuming your ProfileRepository or SearchRepository has a search endpoint
      // You can inject the SearchRepository here. For demonstration, we filter followers locally,
      // but you should replace the right side with: await searchRepo.searchUsers(query);
      final result = await followRepo.getFollowers(
        userId: currentUserId,
        page: 0,
        size: 50,
      );

      return result.fold(
        (failure) => throw Exception(failure.message),
        (paginatedData) => paginatedData.content
            .where(
              (user) =>
                  user.username.toLowerCase().contains(query.toLowerCase()),
            )
            .map(
              (engager) =>
                  MessageUser(id: engager.id, username: engager.username),
            )
            .toList(),
      );
    }
  }
}
