import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/feed/domain/entities/feed_track.dart';
import 'package:decibel/features/feed/domain/entities/paginated_feed.dart';
import 'package:decibel/features/feed/domain/repositories/i_feed_repository.dart';
import 'package:decibel/features/feed/presentation/notifiers/discover_feed_notifier.dart';
import 'package:decibel/features/feed/presentation/notifiers/feed_notifier.dart';
import 'package:decibel/features/feed/presentation/providers/feed_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFeedRepository extends Mock implements IFeedRepository {}

void main() {
  late MockFeedRepository mockRepository;

  setUp(() {
    mockRepository = MockFeedRepository();
  });

  const tPaginatedFeed = PaginatedFeed(
    content: [],
    pageNumber: 0,
    pageSize: 20,
    totalElements: 0,
    totalPages: 0,
    isLast: true,
  );

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        feedRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  FeedTrack createFeedTrack(int id) {
    return FeedTrack(
      id: id,
      title: 'Track $id',
      artistId: 1,
      artistUsername: 'artist',
      genre: 'Rock',
      access: 'PLAYABLE',
      isReposted: false,
      isLiked: false,
      tags: [],
      releaseDate: DateTime.now(),
      playCount: 0,
      likeCount: 0,
      repostCount: 0,
      commentCount: 0,
      isPrivate: false,
      uploadDate: DateTime.now(),
      trackDurationSeconds: 180,
    );
  }

  group('DiscoverFeedNotifier', () {
    test('initial state should be AsyncData on success', () async {
      when(() => mockRepository.getDiscoverFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => const Right(tPaginatedFeed));

      final container = createContainer();
      await container.read(discoverFeedProvider.future);

      expect(container.read(discoverFeedProvider).value?.tracks, isEmpty);
      verify(() => mockRepository.getDiscoverFeed(page: 0, size: 20)).called(1);
    });

    test('loadMore should call getDiscoverFeed and append results', () async {
      final tFeed1 = PaginatedFeed(
        content: [createFeedTrack(1)],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 2,
        totalPages: 2,
        isLast: false,
      );
      final tFeed2 = PaginatedFeed(
        content: [createFeedTrack(2)],
        pageNumber: 1,
        pageSize: 20,
        totalElements: 2,
        totalPages: 2,
        isLast: true,
      );

      when(() => mockRepository.getDiscoverFeed(page: 0, size: 20))
          .thenAnswer((_) async => Right(tFeed1));
      when(() => mockRepository.getDiscoverFeed(page: 1, size: 20))
          .thenAnswer((_) async => Right(tFeed2));

      final container = createContainer();
      await container.read(discoverFeedProvider.future);
      await container.read(discoverFeedProvider.notifier).loadMore();

      final state = container.read(discoverFeedProvider).value;
      expect(state?.tracks.length, 2);
      expect(state?.tracks[0].id, 1);
      expect(state?.tracks[1].id, 2);
      expect(state?.currentPage, 1);
    });

    test('should handle Failure by throwing exception in AsyncNotifier', () async {
      when(() => mockRepository.getDiscoverFeed(page: 0, size: 20))
          .thenAnswer((_) async => const Left(ServerFailure('Error')));

      final container = createContainer();
      
      expect(
        () => container.read(discoverFeedProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });
}
