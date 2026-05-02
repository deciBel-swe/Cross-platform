import '../entities/paginated_blocked_users.dart';

abstract class BlockedUsersRepository {
  Future<PaginatedBlockedUsers> getBlockedUsers({
    int page = 0,
    int size = 20,
  });

  Future<void> unblockUser({
    required int userId,
  });
}