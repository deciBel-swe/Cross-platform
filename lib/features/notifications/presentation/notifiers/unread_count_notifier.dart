import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/notification_providers.dart';

final unreadCountProvider = AsyncNotifierProvider<UnreadCountNotifier, int>(
  UnreadCountNotifier.new,
);

class UnreadCountNotifier extends AsyncNotifier<int> {
  @override
  FutureOr<int> build() async {
    final repository = ref.watch(notificationRepositoryProvider);
    final (failure, count) = await repository.getUnreadCount();

    if (failure != null) {
      // Throwing allows AsyncValue to naturally transition into the .error() state
      throw Exception(failure.message);
    }
    return count ?? 0;
  }

  /// Optimistically clears the badge to 0 without an extra network call.
  void clearBadge() {
    state = const AsyncData(0);
  }
}
