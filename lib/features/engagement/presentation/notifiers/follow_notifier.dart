import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/follow_repository.dart';
import '../providers/follow_state_provider.dart';

class FollowNotifier extends FamilyAsyncNotifier<bool, int> {
  bool _isSeeded = false;

  @override
  FutureOr<bool> build(int arg) async {
    _isSeeded = false;

    // Use Future.microtask to allow providers that fetch this (like PublicProfileProvider)
    // to still call setInitialState if they finish first.
    // However, the cleanest way is just to fetch if build is triggered.
    final repository = ref.read(followRepositoryProvider);
    final result = await repository.getPublicProfile(arg);

    return result.fold(
      (failure) => false,
      (profile) {
        _isSeeded = true;
        return profile.isFollowing;
      },
    );
  }

  void setInitialState(bool isFollowing) {
    if (_isSeeded) return;
    state = AsyncData(isFollowing);
    _isSeeded = true;
  }

  void forceState(bool isFollowing) {
    _isSeeded = true;
    state = AsyncData(isFollowing);
  }

  Future<void> toggleFollow() async {
    final current = state.valueOrNull ?? false;
    final desired = !current;

    state = AsyncData(desired);

    final FollowRepository repository = ref.read(followRepositoryProvider);
    final result = desired
        ? await repository.followUser(arg)
        : await repository.unfollowUser(arg);

    result.fold(
      (failure) {
        state = AsyncData(current);
        _isSeeded = true;
      },
      (isFollowing) {
        state = AsyncData(isFollowing);
        _isSeeded = true;

        ref.read(followRefreshTickProvider.notifier).state++;
      },
    );
  }
}