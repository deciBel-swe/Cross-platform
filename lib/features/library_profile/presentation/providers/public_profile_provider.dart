import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/public_profile.dart';
import '../notifiers/public_profile_notifier.dart';

/// Family provider that fetches and caches a public profile by userId.
///
/// Triggers the initial fetch on first watch, and seeds the
/// [followStateProvider] with the correct `isFollowing` value.
///
/// Usage:
/// ```dart
/// final profileAsync = ref.watch(publicProfileProvider(userId));
/// ```
final publicProfileProvider =
    AsyncNotifierProvider.family<PublicProfileNotifier, PublicProfile, int>(
  PublicProfileNotifier.new,
);
