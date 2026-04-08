import '../../domain/entities/following_user.dart';
import '../../domain/entities/paginated_following_users.dart';
import '../../domain/repositories/social_graph_repository.dart';

class SocialGraphMockRepository implements SocialGraphRepository {
  static const int _totalPages = 3;

  @override
  Future<PaginatedFollowingUsers> getFollowingUsers({
    required int userId,
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final bool isLast = page >= _totalPages - 1;

    final List<FollowingUser> users = List<FollowingUser>.generate(
      size,
      (int index) {
        final int id = (page * size) + index + 1;

        final bool isPro = id % 3 == 0;
        final String username = switch (id % 6) {
          0 => 'Taylor Swift',
          1 => 'SUNDER',
          2 => 'Mahta',
          3 => 'Fattiglas',
          4 => 'Alis',
          _ => 'Creator $id',
        };

        return FollowingUser(
          id: id,
          username: username,
          avatarUrl: null,
          tier: isPro ? 'PRO' : 'FREE',
          isFollowing: true,
        );
      },
    );

    return PaginatedFollowingUsers(
      content: users,
      pageNumber: page,
      pageSize: size,
      totalElements: size * _totalPages,
      totalPages: _totalPages,
      isLast: isLast,
    );
  }
}