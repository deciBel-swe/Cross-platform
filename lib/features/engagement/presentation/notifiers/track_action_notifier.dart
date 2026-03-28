import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../domain/models/track_action_data.dart';
import '../../domain/repositories/track_social_repository.dart';
import '../states/track_social_state.dart';

class TrackSocialNotifier extends Notifier<TrackSocialState> {
  late final ITrackSocialRepository _repository;

  @override
  TrackSocialState build() {
    _repository = GetIt.I<ITrackSocialRepository>();
    return const TrackSocialState();
  }

  void initializeTrack(String trackId, TrackSocialData initialData) {
    if (state.trackStates.containsKey(trackId)) return;

    final newTrackStates = Map<String, TrackSocialData>.from(state.trackStates);
    newTrackStates[trackId] = initialData;
    state = state.copyWith(trackStates: newTrackStates);
  }

  void mergeTrack(
    String trackId, {
    bool? isLiked,
    int? likeCount,
    bool? isReposted,
    int? repostCount,
  }) {
    final newTrackStates = Map<String, TrackSocialData>.from(state.trackStates);
    final existing = newTrackStates[trackId];

    if (existing == null) {
      newTrackStates[trackId] = TrackSocialData(
        isLiked: isLiked ?? false,
        likeCount: likeCount ?? 0,
        isReposted: isReposted ?? false,
        repostCount: repostCount ?? 0,
      );
    } else {
      newTrackStates[trackId] = existing.copyWith(
        isLiked: isLiked ?? existing.isLiked,
        likeCount: likeCount ?? existing.likeCount,
        isReposted: isReposted ?? existing.isReposted,
        repostCount: repostCount ?? existing.repostCount,
      );
    }

    state = state.copyWith(trackStates: newTrackStates);
  }

  Future<void> toggleAction(String trackId, SocialActionType actionType) async {
    final trackData = state.trackStates[trackId];
    if (trackData == null) return;

    final bool wasActive = actionType == SocialActionType.like
        ? trackData.isLiked
        : trackData.isReposted;
    final int previousCount = actionType == SocialActionType.like
        ? trackData.likeCount
        : trackData.repostCount;

    final String loadingKey = '${actionType.name}_$trackId';

    _applyStateMutation(
      trackId,
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
    } catch (e) {
      _applyStateMutation(
        trackId,
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
    String trackId,
    SocialActionType actionType, {
    required bool isActive,
    required int count,
  }) {
    final trackData = state.trackStates[trackId]!;
    final newTrackStates = Map<String, TrackSocialData>.from(state.trackStates);

    newTrackStates[trackId] = actionType == SocialActionType.like
        ? trackData.copyWith(isLiked: isActive, likeCount: count)
        : trackData.copyWith(isReposted: isActive, repostCount: count);

    state = state.copyWith(trackStates: newTrackStates);
  }
}

final trackSocialProvider =
    NotifierProvider<TrackSocialNotifier, TrackSocialState>(
      () => TrackSocialNotifier(),
    );
