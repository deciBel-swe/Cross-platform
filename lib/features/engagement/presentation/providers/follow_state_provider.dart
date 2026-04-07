import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repositories/follow_repository.dart';
import '../notifiers/follow_notifier.dart';

/// Bridges [FollowRepository] from GetIt into Riverpod.
///
/// Allows notifiers and widgets to access the repository via `ref.read()`
/// without calling `getIt<>()` directly, following the project convention.
final followRepositoryProvider = Provider<FollowRepository>(
  (_) => getIt<FollowRepository>(),
);

/// Monotonic tick used to refresh follow-related views globally.
///
/// Incremented after successful follow/unfollow operations.
final followRefreshTickProvider = StateProvider<int>((_) => 0);

/// Family provider that manages follow state for each userId globally.
///
/// Any widget that watches `followStateProvider(userId)` will see the same
/// state, ensuring consistent follow status across the entire app (e.g.,
/// profile screens, search results, follower lists).
///
/// Usage:
/// ```dart
/// final isFollowing = ref.watch(followStateProvider(userId));
/// ```
final followStateProvider =
    AsyncNotifierProvider.family<FollowNotifier, bool, int>(FollowNotifier.new);

/// Local fallback hint that a user follows the current user.
///
/// Used to preserve "Follow Back" UX when navigation context already
/// proves follower relationship (e.g., opened from Followers list),
/// even if a profile response omits `isFollowedBy`.
final followBackHintProvider = StateProvider.family<bool, int>(
  (_, userId) => false,
);
