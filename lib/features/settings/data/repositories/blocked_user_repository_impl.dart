import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/models/blocked_user.dart';
import '../../domain/repositories/blocked_user_repository.dart';
import '../datasources/blocked_user_datasource.dart';


@LazySingleton(as: IBlockedUserRepository)
class BlockedUserRepositoryImpl implements IBlockedUserRepository {
  BlockedUserRepositoryImpl(this._remoteDataSource);

  final BlockedUserRemoteDataSource _remoteDataSource;

  @override
  Future<({List<BlockedUser> users, bool isLast})> getBlockedUsers({
    required int page,
    required int size,
  }) async {
    try {
      final response = await _remoteDataSource.fetchBlockedUsers(page, size);
      
      return (
        users: response.content,
        isLast: response.isLast,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException( "An unexpected error occurred while fetching blocked users.");
    }
  }

  @override
  Future<void> unblockUser(int userId) async {
    try {
      await _remoteDataSource.unblockUser(userId.toString());
    } on AuthException {
      rethrow;
    } catch (e) {
      throw const ServerException("Failed to unblock user. Please try again.");
    }
  }
}