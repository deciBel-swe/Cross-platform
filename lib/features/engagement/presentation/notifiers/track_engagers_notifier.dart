import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/paginated_engagers.dart';
import '../../domain/entities/track_engager.dart';
import '../providers/track_social_provider.dart';

typedef EngagerParams = ({int trackId, EngagerType type});

class TrackEngagersNotifier
    extends FamilyAsyncNotifier<PaginatedEngagers, EngagerParams> {
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _isLast = false;
  final List<TrackEngager> _items = [];

  @override
  FutureOr<PaginatedEngagers> build(EngagerParams arg) async {
    _currentPage = 0;
    _items.clear();
    return _fetchPage();
  }

  Future<void> loadMore() async {
    if (state.isLoading || _isLast) return;

    state = const AsyncLoading<PaginatedEngagers>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      _currentPage++;
      final nextData = await _fetchPage();
      return nextData;
    });
  }

  Future<PaginatedEngagers> _fetchPage() async {
    final repository = ref.read(trackSocialRepositoryProvider);
    final result = arg.type == EngagerType.likers
        ? await repository.fetchTrackLikers(
            trackId: arg.trackId,
            page: _currentPage,
            size: _pageSize,
          )
        : await repository.fetchTrackReposters(
            trackId: arg.trackId,
            page: _currentPage,
            size: _pageSize,
          );

    return result.fold((failure) => throw failure.message, (paginated) {
      _isLast = paginated.isLast;
      _items.addAll(paginated.content);
      return PaginatedEngagers(
        content: List.from(_items),
        pageNumber: paginated.pageNumber,
        pageSize: paginated.pageSize,
        totalElements: paginated.totalElements,
        totalPages: paginated.totalPages,
        isLast: paginated.isLast,
      );
    });
  }
}

final trackEngagersProvider =
    AsyncNotifierProvider.family<
      TrackEngagersNotifier,
      PaginatedEngagers,
      EngagerParams
    >(TrackEngagersNotifier.new);
