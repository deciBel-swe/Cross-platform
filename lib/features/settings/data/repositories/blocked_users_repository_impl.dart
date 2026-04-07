import 'package:injectable/injectable.dart';

import '../../domain/entities/paginated_blocked_users.dart';
import '../../domain/repositories/blocked_users_repository.dart';
import '../datasources/blocked_users_remote_datasource.dart';
import '../models/paginated_blocked_users_model.dart';

@LazySingleton(as: BlockedUsersRepository)
class BlockedUsersRepositoryImpl implements BlockedUsersRepository {
  BlockedUsersRepositoryImpl(this._remoteDatasource);

  final BlockedUsersRemoteDatasource _remoteDatasource;

  @override
  Future<PaginatedBlockedUsers> getBlockedUsers({
    int page = 0,
    int size = 20,
  }) async {
    final result = await _remoteDatasource.getBlockedUsers(
      page: page,
      size: size,
    );

    return result.toEntity();
  }

  @override
  Future<void> unblockUser({
    required int userId,
  }) async {
    await _remoteDatasource.unblockUser(userId: userId);
  }
}