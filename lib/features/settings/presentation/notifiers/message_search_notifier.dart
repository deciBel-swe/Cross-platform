import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../discovery/domain/entities/discovery_search_type.dart';
import '../../../discovery/presentation/providers/discovery_provider.dart';
import '../../../engagement/domain/entities/paginated_engagers.dart';
import '../../../engagement/domain/repositories/follow_repository.dart';
import '../../domain/entities/message_user.dart';

/// Provider holding the current search input state.
final newMessageQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// Fetches users for starting a new DM.
///
/// - Empty query: friends/following/followers/suggested users.
/// - Non-empty query: real global search using Discovery `/search` with USER type.
final newMessageSearchProvider =
    AutoDisposeAsyncNotifierProvider<
      NewMessageSearchNotifier,
      List<MessageUser>
    >(NewMessageSearchNotifier.new);

class NewMessageSearchNotifier
    extends AutoDisposeAsyncNotifier<List<MessageUser>> {
  @override
  FutureOr<List<MessageUser>> build() async {
    final query = ref.watch(newMessageQueryProvider).trim();

    final authState = ref.watch(authStateProvider).valueOrNull;
    if (authState is! AuthAuthenticated) return const [];

    final currentUserId = authState.user.id;

    if (query.isEmpty) {
      return _loadDefaultUsers(currentUserId);
    }

    if (query.length < 2) {
      return const [];
    }

    return _searchUsersGlobally(query: query, currentUserId: currentUserId);
  }

  Future<List<MessageUser>> _loadDefaultUsers(int currentUserId) async {
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

    return users;
  }

  Future<List<MessageUser>> _searchUsersGlobally({
    required String query,
    required int currentUserId,
  }) async {
    final response = await ref.watch(
      searchResultsProvider((
        query: query,
        type: DiscoverySearchType.users,
        page: 0,
        size: 20,
      )).future,
    );

    final usersById = <int, MessageUser>{};

    for (final user in response.users) {
      if (user.id == currentUserId) continue;

      final displayName = user.displayName?.trim();
      final username = user.username.trim();

      final bestName = displayName != null && displayName.isNotEmpty
          ? displayName
          : username;

      if (bestName.isEmpty) continue;

      usersById[user.id] = MessageUser(id: user.id, username: bestName);
    }

    final users = usersById.values.toList()
      ..sort(
        (a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()),
      );

    return users;
  }
}
