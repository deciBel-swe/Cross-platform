import 'package:dartz/dartz.dart';
import 'package:decibel/core/di/injection.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/domain/entities/auth_user.dart';
import 'package:decibel/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/discovery/domain/entities/discovery_search_response.dart';
import 'package:decibel/features/discovery/domain/entities/discovery_search_type.dart';
import 'package:decibel/features/discovery/domain/entities/discovery_user.dart';
import 'package:decibel/features/discovery/domain/entities/paginated_discovery_tracks.dart';
import 'package:decibel/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:decibel/features/discovery/presentation/providers/discovery_provider.dart';
import 'package:decibel/features/engagement/domain/entities/paginated_engagers.dart';
import 'package:decibel/features/engagement/domain/entities/track_engager.dart';
import 'package:decibel/features/engagement/domain/repositories/follow_repository.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile.dart';
import 'package:decibel/features/settings/presentation/notifiers/message_search_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('NewMessageSearchNotifier', () {
    test(
      'returns an empty list when no authenticated user is available',
      () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final subscription = container.listen(
          newMessageSearchProvider,
          (_, _) {},
          fireImmediately: true,
        );
        addTearDown(subscription.close);

        final users = await container.read(newMessageSearchProvider.future);

        expect(users, isEmpty);
      },
    );

    test(
      'query provider trims back to its default value in a fresh container',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        expect(container.read(newMessageQueryProvider), '');
      },
    );

    test(
      'empty query loads and deduplicates default relationship users',
      () async {
        getIt.registerSingleton<FollowRepository>(
          const _FakeFollowRepository([
            TrackEngager(
              id: 2,
              username: 'zoe',
              tier: 'FREE',
              isFollowing: true,
            ),
            TrackEngager(
              id: 3,
              username: 'anna',
              tier: 'FREE',
              isFollowing: true,
            ),
            TrackEngager(
              id: 1,
              username: 'current-user',
              tier: 'FREE',
              isFollowing: false,
            ),
          ]),
        );
        final container = ProviderContainer(
          overrides: [authStateProvider.overrideWith(_AuthenticatedAuth.new)],
        );
        addTearDown(container.dispose);
        final subscription = container.listen(
          newMessageSearchProvider,
          (_, _) {},
          fireImmediately: true,
        );
        addTearDown(subscription.close);

        final users = await container.read(newMessageSearchProvider.future);

        expect(users.map((user) => user.username), ['anna', 'zoe']);
      },
    );

    test('two-character query searches discovery users globally', () async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(_AuthenticatedAuth.new),
          discoveryRepositoryProvider.overrideWithValue(
            const _FakeDiscoveryRepository(
              DiscoverySearchResponse(
                users: [
                  DiscoveryUser(id: 2, username: 'alpha'),
                  DiscoveryUser(id: 1, username: 'current'),
                  DiscoveryUser(id: 4, username: 'beta', displayName: 'Beta'),
                ],
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.read(newMessageQueryProvider.notifier).state = 'be';
      final subscription = container.listen(
        newMessageSearchProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      final users = await container.read(newMessageSearchProvider.future);

      expect(users.map((user) => user.username), ['alpha', 'Beta']);
    });
  });
}

class _AuthenticatedAuth extends AuthNotifier {
  @override
  AuthState build() {
    return const AuthAuthenticated(
      user: AuthUser(id: 1, username: 'current', tier: UserTier.free),
    );
  }
}

class _FakeFollowRepository implements FollowRepository {
  const _FakeFollowRepository(this.users);

  final List<TrackEngager> users;

  PaginatedEngagers _page() {
    return PaginatedEngagers(
      content: users,
      pageNumber: 0,
      pageSize: 50,
      totalElements: users.length,
      totalPages: 1,
      isLast: true,
    );
  }

  @override
  Future<Either<Failure, PaginatedEngagers>> getFollowers({
    required int userId,
    int page = 0,
    int size = 20,
  }) async => Right(_page());

  @override
  Future<Either<Failure, PaginatedEngagers>> getFollowing({
    required int userId,
    int page = 0,
    int size = 20,
  }) async => Right(_page());

  @override
  Future<Either<Failure, PaginatedEngagers>> getFriends({
    int page = 0,
    int size = 20,
  }) async => Right(_page());

  @override
  Future<Either<Failure, PaginatedEngagers>> getSuggestedUsers({
    int page = 0,
    int size = 20,
  }) async => Right(_page());

  @override
  Future<Either<Failure, bool>> followUser(int userId) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PublicProfile>> getPublicProfile(
    String userIdentifier,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> unfollowUser(int userId) async {
    throw UnimplementedError();
  }
}

class _FakeDiscoveryRepository implements DiscoveryRepository {
  const _FakeDiscoveryRepository(this.response);

  final DiscoverySearchResponse response;

  @override
  Future<Either<Failure, DiscoverySearchResponse>> search({
    required String query,
    required DiscoverySearchType type,
    required int page,
    required int size,
  }) async => Right(response);

  @override
  Future<Either<Failure, PaginatedDiscoveryTracks>> getArtistStation({
    required int page,
    required int size,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PaginatedDiscoveryTracks>> getGenreStation({
    required int page,
    required int size,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PaginatedDiscoveryTracks>> getLikesStation() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PaginatedDiscoveryTracks>> getTrendingTracks({
    required int page,
    required int size,
  }) async {
    throw UnimplementedError();
  }
}
