import '../entities/paginated_following_users.dart';

abstract class SocialGraphRepository {
  Future<PaginatedFollowingUsers> getFollowingUsers({
    required int userId,
    int page = 0,
    int size = 20,
  });
}