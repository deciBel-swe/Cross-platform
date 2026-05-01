import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library_profile/domain/repositories/track_repository.dart';
import '../../../library_profile/presentation/providers/track_repository_provider.dart';
import '../../../library_profile/presentation/providers/user_profile_provider.dart';
import '../../domain/models/track_action_data.dart';
import '../../domain/repositories/track_social_repository.dart';
import '../notifiers/liked_tracks_notifier.dart';
import '../providers/track_social_provider.dart';

class TrackSocialNotifier extends FamilyAsyncNotifier<TrackSocialData, int> {
  late final ITrackSocialRepository _socialRepository;
  late final TrackRepository _trackRepository;

  @override
  FutureOr<TrackSocialData> build(int arg) async {
    _socialRepository = ref.read(trackSocialRepositoryProvider);
    _trackRepository = ref.read(trackRepositoryProvider);

    final data = await _fetchTrackSocialData(arg);
    return data ??
        const TrackSocialData(
          isLiked: false,
          likeCount: 0,
          isReposted: false,
          repostCount: 0,
        );
  }

  /// Toggle Like/Repost with optimistic UI update.
  Future<void> toggleAction(SocialActionType actionType) async {
    // If we haven't fetched yet, we can't reliably toggle
    final currentData = state.valueOrNull;
    if (currentData == null) return;

    final bool wasActive = actionType == SocialActionType.like
        ? currentData.isLiked
        : currentData.isReposted;
    // 1. Optimistic Update
    final optimisticData = actionType == SocialActionType.like
        ? currentData.copyWith(isLiked: !wasActive)
        : currentData.copyWith(isReposted: !wasActive);

    state = AsyncData(optimisticData);

    try {
      // 2. Call Repository
      if (actionType == SocialActionType.like) {
        wasActive
            ? await _socialRepository.unlikeTrack(arg)
            : await _socialRepository.likeTrack(arg);
      } else {
        wasActive
            ? await _socialRepository.unrepostTrack(arg)
            : await _socialRepository.repostTrack(arg);
      }

      // 3. Sync Collections & Profile stats
      _syncCollections(actionType, wasActive: wasActive);

      final refreshed = await _fetchTrackSocialData(arg);
      if (refreshed != null) {
        state = AsyncData(refreshed);
      }
    } on AppException {
      // Revert on error
      state = AsyncData(currentData);
    }
  }

  TrackSocialData _mapTrackToSocialData(Track track) {
    return TrackSocialData(
      isLiked: track.isLiked,
      likeCount: track.likeCount,
      isReposted: track.isReposted,
      repostCount: track.repostCount,
    );
  }

  Future<TrackSocialData?> _fetchTrackSocialData(int trackId) async {
    final result = await _trackRepository.fetchTrackById(trackId);
    return result.fold((_) => null, _mapTrackToSocialData);
  }

  void _syncCollections(
    SocialActionType actionType, {
    required bool wasActive,
  }) {
    final isLikeAction = actionType == SocialActionType.like;
    final collectionProvider = isLikeAction
        ? likedTracksProvider
        : repostedTracksProvider;

    if (wasActive) {
      if (ref.exists(collectionProvider)) {
        ref.read(collectionProvider.notifier).removeTrackLocal(arg);
      }
    } else {
      if (ref.exists(collectionProvider)) {
        ref.read(collectionProvider.notifier).refreshAll();
      }
    }

    if (ref.exists(userProfileProvider)) {
      ref.read(userProfileProvider.notifier).refreshProfile();
    }
  }
}
