import 'package:injectable/injectable.dart';

import '../../domain/entities/paginated_following_users.dart';
import '../../domain/repositories/social_graph_repository.dart';
import '../datasources/social_graph_remote_datasource.dart';
import '../models/paginated_following_users_model.dart';

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
      final result = await _remoteDatasource.getFollowingUsers(
        userId: userId,
        page: page,
        size: size,
      );

      return result.toEntity();
    } catch (e) {
      throw Exception('Failed to fetch following users');
    }
  }
}