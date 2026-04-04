import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../library/domain/entities/paginated_tracks.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/repositories/track_social_repository.dart';

enum TrackCollectionType { liked, reposted }

/// Notifier to manage paginated user track collections (likes/reposts).
class TrackCollectionNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Track>, TrackCollectionType> {
  int _currentPage = 0;
  bool _isLastPage = false;
  bool _isLoadingMore = false;

  late final ITrackSocialRepository _repository;
  late final TrackCollectionType _collectionType;

  @override
  FutureOr<List<Track>> build(TrackCollectionType collectionType) async {
    _repository = GetIt.I<ITrackSocialRepository>();
    _collectionType = collectionType;
    return _fetchInitial();
  }

  Future<List<Track>> _fetchInitial() async {
    _currentPage = 0;
    _isLastPage = false;
    _isLoadingMore = false;

    final response = await _fetchPage(page: 0, size: 20);
    _currentPage = response.pageNumber;
    _isLastPage = response.isLast;
    return response.content;
  }

  Future<PaginatedTracks> _fetchPage({required int page, required int size}) {
    if (_collectionType == TrackCollectionType.reposted) {
      return _repository.getRepostedTracks(page: page, size: size);
    }
    return _repository.getLikedTracks(page: page, size: size);
  }

  Future<void> refreshAll() async {
    // Note: Do not emit AsyncValue.loading() here to prevent the UI from Unmounting
    // the AnimatedList and throwing exceptions while RefreshIndicator is spinning.
    state = await AsyncValue.guard(() => _fetchInitial());
  }

  Future<void> loadMore() async {
    if (_isLastPage || _isLoadingMore || state.isLoading || state.hasError) {
      return; // Reached end or currently loading
    }

    _isLoadingMore = true;

    try {
      final nextPage = _currentPage + 1;
      final response = await _fetchPage(page: nextPage, size: 20);

      final currentTracks = state.valueOrNull ?? [];
      final Set<int> existingIds = currentTracks.map((e) => e.id).toSet();
      final newTracks = response.content
          .where((track) => !existingIds.contains(track.id))
          .toList();

      // If the backend returns the same page or no new items, consider it the end of the list
      // to prevent spamming identical requests.
      if ((response.pageNumber == _currentPage && _currentPage != 0) ||
          newTracks.isEmpty) {
        _isLastPage = true;
      } else {
        _currentPage = response.pageNumber;
        _isLastPage = response.isLast;
      }

      state = AsyncValue.data([...currentTracks, ...newTracks]);
    } catch (e, st) {
      // Could set an error state, but since it's appending, we might just re-throw or silently fail.
      // Setting state to error will completely replace the list with an error screen depending on `when`.
      // Let's just catch and ignore for infinite scroll, or maybe store it in a separate state.
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Removes a track from the list locally (optimistic update after unlike).
  void removeTrackLocal(int trackId) {
    if (state.hasValue) {
      final updatedList = state.value!.where((t) => t.id != trackId).toList();
      state = AsyncValue.data(updatedList);
    }
  }
}

/// The provider for `ITrackSocialRepository`.
/// Assumes it is registered with get_it / injectable or a Riverpod provider.
/// Since the repository uses injectable, we might need a standard get_it accessor.
final trackCollectionProvider = AsyncNotifierProvider.autoDispose
    .family<TrackCollectionNotifier, List<Track>, TrackCollectionType>(
      TrackCollectionNotifier.new,
    );

final likedTracksProvider = trackCollectionProvider(TrackCollectionType.liked);
final repostedTracksProvider = trackCollectionProvider(
  TrackCollectionType.reposted,
);
