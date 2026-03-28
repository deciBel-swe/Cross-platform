import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get_it/get_it.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/repositories/track_social_repository.dart';

/// Notifier to manage the paginated list of liked tracks.
class LikedTracksNotifier extends AsyncNotifier<List<Track>> {
  int _currentPage = 0;
  bool _isLastPage = false;
  bool _isLoadingMore = false;

  late final ITrackSocialRepository _repository;

  @override
  FutureOr<List<Track>> build() async {
    _repository = GetIt.I<ITrackSocialRepository>();
    return _fetchInitial();
  }

  Future<List<Track>> _fetchInitial() async {
    _currentPage = 0;
    _isLastPage = false;
    _isLoadingMore = false;
    
    final response = await _repository.getLikedTracks(page: 0, size: 20);
    _currentPage = response.pageNumber;
    _isLastPage = response.isLast;
    return response.content;
  }

  Future<void> refreshAll() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchInitial());
  }

  Future<void> loadMore() async {
    if (_isLastPage || _isLoadingMore || state.isLoading || state.hasError) {
      return; // Reached end or currently loading
    }
    
    _isLoadingMore = true;
    
    try {
      final nextPage = _currentPage + 1;
      final response = await _repository.getLikedTracks(page: nextPage, size: 20);
      
      _currentPage = response.pageNumber;
      _isLastPage = response.isLast;
      
      final currentTracks = state.valueOrNull ?? [];
      final Set<int> existingIds = currentTracks.map((e) => e.id).toSet();
      final newTracks = response.content.where((e) => !existingIds.contains(e.id)).toList();
      
      // If the backend returns the same page or no new items, consider it the end of the list
      // to prevent spamming identical requests.
      if (response.pageNumber == _currentPage && _currentPage != 0 || newTracks.isEmpty) {
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
final likedTracksProvider =
    AsyncNotifierProvider<LikedTracksNotifier, List<Track>>(
  LikedTracksNotifier.new,
);
