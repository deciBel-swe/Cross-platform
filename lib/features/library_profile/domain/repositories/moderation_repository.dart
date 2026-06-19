abstract class ModerationRepository {
  Future<void> blockUser(int userId);
  Future<void> unblockUser(int userId);
}
