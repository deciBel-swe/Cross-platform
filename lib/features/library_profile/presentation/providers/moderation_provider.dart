import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../data/repositories/mock_moderation_repository_impl.dart';
import '../../domain/repositories/moderation_repository.dart';

final moderationRepositoryProvider = Provider<ModerationRepository>((ref) {
  final useMock =
      dotenv.isInitialized &&
      dotenv.env['USE_MOCK_SERVICES']?.toLowerCase() == 'true';

  if (useMock) {
    return MockModerationRepository();
  }

  return getIt<ModerationRepository>();
});

final moderationProvider = AsyncNotifierProvider<ModerationNotifier, Set<int>>(
  ModerationNotifier.new,
);

class ModerationNotifier extends AsyncNotifier<Set<int>> {
  @override
  Future<Set<int>> build() async {
    return <int>{};
  }

  bool isBlocked(int userId) {
    return state.value?.contains(userId) ?? false;
  }

  Future<void> blockUser(int userId) async {
    final repo = ref.read(moderationRepositoryProvider);
    await repo.blockUser(userId);

    final current = state.value ?? <int>{};
    state = AsyncData(<int>{...current, userId});
  }

  Future<void> unblockUser(int userId) async {
    final repo = ref.read(moderationRepositoryProvider);
    await repo.unblockUser(userId);

    final current = <int>{...(state.value ?? <int>{})};
    current.remove(userId);
    state = AsyncData(current);
  }
}
