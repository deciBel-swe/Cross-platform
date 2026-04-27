import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/paginated_engagers.dart';
import '../../domain/entities/track_engager.dart';
import 'follow_state_provider.dart';

enum FollowConnectionsType { followers, following }

typedef FollowConnectionsParams = ({int userId, FollowConnectionsType type});

const _emptyPaginatedEngagers = PaginatedEngagers(
  content: <TrackEngager>[],
  pageNumber: 0,
  pageSize: 0,
  totalElements: 0,
  totalPages: 0,
  isLast: true,
);

final followConnectionsProvider = FutureProvider.autoDispose
    .family<PaginatedEngagers, FollowConnectionsParams>((ref, params) async {
      final repository = ref.read(followRepositoryProvider);

      final result = params.type == FollowConnectionsType.followers
          ? await repository.getFollowers(userId: params.userId)
          : await repository.getFollowing(userId: params.userId);

      return result.fold((failure) {
        if (failure is NetworkFailure) {
          return _emptyPaginatedEngagers;
        }
        throw failure;
      }, (data) => data);
    });

final suggestedUsersProvider = FutureProvider.autoDispose<PaginatedEngagers>((
  ref,
) async {
  final repository = ref.read(followRepositoryProvider);
  final result = await repository.getSuggestedUsers();

  return result.fold((failure) {
    if (failure is NetworkFailure) {
      return _emptyPaginatedEngagers;
    }
    throw failure;
  }, (data) => data);
});

final friendsProvider = FutureProvider.autoDispose<PaginatedEngagers>((
  ref,
) async {
  final repository = ref.read(followRepositoryProvider);
  final result = await repository.getFriends();

  return result.fold((failure) {
    if (failure is NetworkFailure) {
      return _emptyPaginatedEngagers;
    }
    throw failure;
  }, (data) => data);
});
