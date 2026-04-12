import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../library_profile/presentation/providers/user_profile_provider.dart';
import '../../domain/models/track_action_data.dart';
import '../../domain/repositories/track_social_repository.dart';
import '../notifiers/liked_tracks_notifier.dart';
import '../providers/track_social_provider.dart';
import '../states/track_social_state.dart';

class TrackSocialNotifier extends Notifier<TrackSocialState> {
  late final ITrackSocialRepository _repository;

  @override
  TrackSocialState build() {
    _repository = ref.read(trackSocialRepositoryProvider);
    return const TrackSocialState();
  }

  void mergeTrack(
    int trackId, {
    bool? isLiked,
    int? likeCount,
    bool? isReposted,
    int? repostCount,
  }) {
    final trackKey = trackId.toString();
    final newTrackStates = Map<String, TrackSocialData>.from(state.trackStates);
    final existing = newTrackStates[trackKey];

    if (existing == null) {
      newTrackStates[trackKey] = TrackSocialData(
        isLiked: isLiked ?? false,
        likeCount: likeCount ?? 0,
        isReposted: isReposted ?? false,
        repostCount: repostCount ?? 0,
      );
    } else {
      newTrackStates[trackKey] = existing.copyWith(
        isLiked: isLiked ?? existing.isLiked,
        likeCount: likeCount ?? existing.likeCount,
        isReposted: isReposted ?? existing.isReposted,
        repostCount: repostCount ?? existing.repostCount,
      );
    }

    state = state.copyWith(trackStates: newTrackStates);
  }

  Future<void> toggleAction(
    int trackId,
    SocialActionType actionType, {
    int? initialLikeCount,
    int? initialRepostCount,
    bool? initialIsLiked,
    bool? initialIsReposted,
  }) async {
    final trackKey = trackId.toString();
    var trackData = state.trackStates[trackKey];

    if (trackData == null) {
      if (actionType == SocialActionType.like &&
          (initialLikeCount == null || initialIsLiked == null)) {
        return;
      }
      if (actionType == SocialActionType.repost &&
          (initialRepostCount == null || initialIsReposted == null)) {
        return;
      }

      trackData = TrackSocialData(
        isLiked: initialIsLiked ?? false,
        likeCount: initialLikeCount ?? 0,
        isReposted: initialIsReposted ?? false,
        repostCount: initialRepostCount ?? 0,
      );
      state = state.copyWith(
        trackStates: {...state.trackStates, trackKey: trackData},
      );
    }

    final bool wasActive = actionType == SocialActionType.like
        ? trackData.isLiked
        : trackData.isReposted;
    final int previousCount = actionType == SocialActionType.like
        ? trackData.likeCount
        : trackData.repostCount;

    final String loadingKey = '${actionType.name}_$trackId';

    _applyStateMutation(
      trackKey,
      actionType,
      isActive: !wasActive,
      count: wasActive ? previousCount - 1 : previousCount + 1,
    );

    state = state.copyWith(loadingKeys: {...state.loadingKeys, loadingKey});

    try {
      if (actionType == SocialActionType.like) {
        wasActive
            ? await _repository.unlikeTrack(trackId)
            : await _repository.likeTrack(trackId);
      } else {
        wasActive
            ? await _repository.unrepostTrack(trackId)
            : await _repository.repostTrack(trackId);
      }

      // ── Cross-provider sync after successful API call ──
      _syncCollections(trackId, actionType, wasActive: wasActive);
    } on AppException {
      _applyStateMutation(
        trackKey,
        actionType,
        isActive: wasActive,
        count: previousCount,
      );
    } finally {
      final newLoading = Set<String>.from(state.loadingKeys)
        ..remove(loadingKey);
      state = state.copyWith(loadingKeys: newLoading);
    }
  }

  void _applyStateMutation(
    String trackKey,
    SocialActionType actionType, {
    required bool isActive,
    required int count,
  }) {
    final trackData = state.trackStates[trackKey]!;
    final newTrackStates = Map<String, TrackSocialData>.from(state.trackStates);

    newTrackStates[trackKey] = actionType == SocialActionType.like
        ? trackData.copyWith(isLiked: isActive, likeCount: count)
        : trackData.copyWith(isReposted: isActive, repostCount: count);

    state = state.copyWith(trackStates: newTrackStates);
  }

  /// Synchronizes liked/reposted track collections and profile stats
  /// after a successful engagement API call.
  void _syncCollections(
    int trackId,
    SocialActionType actionType, {
    required bool wasActive,
  }) {
    final isLikeAction = actionType == SocialActionType.like;
    final collectionProvider =
        isLikeAction ? likedTracksProvider : repostedTracksProvider;

    if (wasActive) {
      // Un-liked / un-reposted → remove from the collection immediately.
      if (ref.exists(collectionProvider)) {
        ref.read(collectionProvider.notifier).removeTrackLocal(trackId);
      }
    } else {
      // Liked / reposted → refresh the collection so the new track appears.
      if (ref.exists(collectionProvider)) {
        ref.read(collectionProvider.notifier).refreshAll();
      }
    }

    // Refresh user profile stats in the background (fire-and-forget)
    // so counts like "Total Tracks", "Followers" etc. stay current.
    if (ref.exists(userProfileProvider)) {
      ref.read(userProfileProvider.notifier).refreshProfile();
    }
  }
}
