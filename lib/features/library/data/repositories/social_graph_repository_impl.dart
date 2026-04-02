import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/following_user.dart';
import '../../domain/entities/paginated_following_users.dart';
import '../../domain/repositories/social_graph_repository.dart';
import '../datasources/social_graph_remote_datasource.dart';

@LazySingleton(as: SocialGraphRepository)
class SocialGraphRepositoryImpl implements SocialGraphRepository {
  SocialGraphRepositoryImpl(this._remoteDatasource);

  final SocialGraphRemoteDatasource _remoteDatasource;

  @override
  Future<PaginatedFollowingUsers> getFollowingUsers({
    required int userId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final model = await _remoteDatasource.getFollowingUsers(
        userId: userId,
        page: page,
        size: size,
      );

      // manual mapping (clean architecture)
      return PaginatedFollowingUsers(
        content: model.content
            .map(
              (userModel) => FollowingUser(
                id: userModel.id,
                username: userModel.username,
                avatarUrl: userModel.avatarUrl,
                tier: userModel.tier,
                isFollowing: userModel.isFollowing,
              ),
            )
            .toList(),
        pageNumber: model.pageNumber,
        pageSize: model.pageSize,
        totalElements: model.totalElements,
        totalPages: model.totalPages,
        isLast: model.isLast,
      );
    } on AppException {
      rethrow;
    } catch (_) {
      throw const ServerException('Failed to fetch following users');
    }
  }
}