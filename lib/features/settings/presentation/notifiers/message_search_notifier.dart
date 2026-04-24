/// Notifier responsible for fetching users to message.
///
/// Logic:
/// - If query is empty: Fetches the current user's followers.
/// - If query has text: Filters the current user's followers locally.
///
/// NOTE:
/// This does not perform global user search because FollowRepository only gives followers.
/// To search all users, we need a real search-users endpoint/repository.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../engagement/domain/entities/paginated_engagers.dart';
import '../../../engagement/domain/repositories/follow_repository.dart';
import '../../domain/entities/message_user.dart';

/// Provider holding the current search input state
final newMessageQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// Notifier responsible for fetching users to message.
///
/// Logic:
/// - Loads friends, following, followers, and suggested users.
/// - Removes duplicates by user id.
/// - If query is empty: returns the combined list.
/// - If query has text: filters the combined list locally.
///
/// Note:
/// This is not true global search. True global search needs a backend search-users endpoint.
final newMessageSearchProvider =
    AutoDisposeAsyncNotifierProvider<
      NewMessageSearchNotifier,
      List<MessageUser>
    >(NewMessageSearchNotifier.new);

class NewMessageSearchNotifier
    extends AutoDisposeAsyncNotifier<List<MessageUser>> {
  @override
  FutureOr<List<MessageUser>> build() async {
    final rawQuery = ref.watch(newMessageQueryProvider);
    final query = rawQuery.trim().toLowerCase();

    final authState = ref.watch(authStateProvider).valueOrNull;
    if (authState is! AuthAuthenticated) return [];

    final currentUserId = authState.user.id;
    final followRepo = getIt<FollowRepository>();

    final results = await Future.wait([
      followRepo.getFriends(page: 0, size: 50),
      followRepo.getFollowing(userId: currentUserId, page: 0, size: 50),
      followRepo.getFollowers(userId: currentUserId, page: 0, size: 50),
      followRepo.getSuggestedUsers(page: 0, size: 50),
    ]);

    final usersById = <int, MessageUser>{};

    for (final result in results) {
      result.fold((_) {}, (PaginatedEngagers data) {
        for (final user in data.content) {
          if (user.id == currentUserId) continue;

          usersById[user.id] = MessageUser(
            id: user.id,
            username: user.username,
          );
        }
      });
    }

    final users = usersById.values.toList()
      ..sort(
        (a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()),
      );

    if (query.isEmpty) return users;

    return users.where((user) {
      return user.username.toLowerCase().contains(query);
    }).toList();
  }
}
