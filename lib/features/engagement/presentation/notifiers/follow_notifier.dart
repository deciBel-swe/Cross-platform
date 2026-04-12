import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/follow_repository.dart';
import '../providers/follow_state_provider.dart';

class FollowNotifier extends FamilyAsyncNotifier<bool, int> {
  bool _isSeeded = false;

  @override
  FutureOr<bool> build(int arg) {
    _isSeeded = false;
    return false;
  }

  void setInitialState(bool isFollowing) {
    if (_isSeeded) {
      return;
    }
    _isSeeded = true;
    state = AsyncData(isFollowing);
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