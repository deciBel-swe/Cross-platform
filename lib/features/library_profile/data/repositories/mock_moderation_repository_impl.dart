import '../../domain/repositories/moderation_repository.dart';

class MockModerationRepository implements ModerationRepository {
  final Set<int> _blockedUserIds = <int>{};

  @override
  Future<void> blockUser(int userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _blockedUserIds.add(userId);
  }

  @override
  Future<void> unblockUser(int userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _blockedUserIds.remove(userId);
  }
}
