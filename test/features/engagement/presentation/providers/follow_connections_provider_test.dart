import 'package:dartz/dartz.dart';
import 'package:decibel/features/engagement/domain/entities/paginated_engagers.dart';
import 'package:decibel/features/engagement/domain/repositories/follow_repository.dart';
import 'package:decibel/features/engagement/presentation/providers/follow_connections_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockFollowRepository extends Mock implements FollowRepository {}

void main() {
  late MockFollowRepository mockRepository;

  setUp(() async {
    mockRepository = MockFollowRepository();
    await GetIt.I.reset();
    GetIt.I.registerSingleton<FollowRepository>(mockRepository);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  group('followConnectionsProvider', () {
    const userId = 1;
    const paginatedEngagers = PaginatedEngagers(
      content: [],
      pageNumber: 0,
      pageSize: 20,
      totalElements: 0,
      totalPages: 0,
      isLast: true,
    );

    test('fetches followers when type is followers', () async {
      when(() => mockRepository.getFollowers(userId: userId))
          .thenAnswer((_) async => const Right(paginatedEngagers));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(
        followConnectionsProvider((userId: userId, type: FollowConnectionsType.followers)).future,
      );

      expect(result, paginatedEngagers);
      verify(() => mockRepository.getFollowers(userId: userId)).called(1);
    });

    test('fetches following when type is following', () async {
      when(() => mockRepository.getFollowing(userId: userId))
          .thenAnswer((_) async => const Right(paginatedEngagers));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(
        followConnectionsProvider((userId: userId, type: FollowConnectionsType.following)).future,
      );

      expect(result, paginatedEngagers);
      verify(() => mockRepository.getFollowing(userId: userId)).called(1);
    });
  });

  group('suggestedUsersProvider', () {
    test('fetches suggested users', () async {
      const paginatedEngagers = PaginatedEngagers(
        content: [],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 0,
        totalPages: 0,
        isLast: true,
      );
      when(() => mockRepository.getSuggestedUsers())
          .thenAnswer((_) async => const Right(paginatedEngagers));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(suggestedUsersProvider.future);

      expect(result, paginatedEngagers);
      verify(() => mockRepository.getSuggestedUsers()).called(1);
    });
  });

  group('friendsProvider', () {
    test('fetches friends', () async {
      const paginatedEngagers = PaginatedEngagers(
        content: [],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 0,
        totalPages: 0,
        isLast: true,
      );
      when(() => mockRepository.getFriends())
          .thenAnswer((_) async => const Right(paginatedEngagers));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(friendsProvider.future);

      expect(result, paginatedEngagers);
      verify(() => mockRepository.getFriends()).called(1);
    });
  });
}
