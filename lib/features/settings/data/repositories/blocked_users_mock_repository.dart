import '../../domain/entities/blocked_user.dart';
import '../../domain/entities/paginated_blocked_users.dart';
import '../../domain/repositories/blocked_users_repository.dart';

class BlockedUsersMockRepository implements BlockedUsersRepository {
  final List<BlockedUser> _allUsers = <BlockedUser>[
    const BlockedUser(
      id: 101,
      username: 'Mahta',
      avatarUrl: null,
      tier: 'FREE',
      isFollowing: false,
    ),
    const BlockedUser(
      id: 102,
      username: 'Fattiglas',
      avatarUrl: null,
      tier: 'PRO',
      isFollowing: false,
    ),
    const BlockedUser(
      id: 103,
      username: 'Blocked Creator',
      avatarUrl: null,
      tier: 'FREE',
      isFollowing: false,
    ),
  ];

  @override
  Future<PaginatedBlockedUsers> getBlockedUsers({
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final int start = page * size;
    if (start >= _allUsers.length) {
      return PaginatedBlockedUsers(
        content: const <BlockedUser>[],
        pageNumber: page,
        pageSize: size,
        totalElements: _allUsers.length,
        totalPages: (_allUsers.length / size).ceil(),
        isLast: true,
      );
    }

    final int end = (start + size).clamp(0, _allUsers.length);
    final List<BlockedUser> pageItems = _allUsers.sublist(start, end);

    return PaginatedBlockedUsers(
      content: pageItems,
      pageNumber: page,
      pageSize: size,
      totalElements: _allUsers.length,
      totalPages: (_allUsers.length / size).ceil(),
      isLast: end >= _allUsers.length,
    );
  }

  @override
  Future<void> unblockUser({required int userId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _allUsers.removeWhere((user) => user.id == userId);
  }
}
