import '../models/blocked_user.dart';

abstract class IBlockedUserRepository {
  Future<({List<BlockedUser> users, bool isLast})> getBlockedUsers({
    required int page, 
    required int size,
  });
  
  Future<void> unblockUser(int userId);
}