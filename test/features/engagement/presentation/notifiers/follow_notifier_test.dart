import 'package:dartz/dartz.dart' as dartz_either;
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/engagement/domain/repositories/follow_repository.dart';
import 'package:decibel/features/engagement/presentation/providers/follow_state_provider.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockFollowRepository extends Mock implements FollowRepository {}

class ServerFailure extends Mock implements Failure {
  ServerFailure(this.message);
  @override
  final String message;
}

void main() {
  late MockFollowRepository mockRepository;
  const userId = 123;

  const publicStats = PublicStats(
    followersCount: 10,
    followingCount: 5,
    trackCount: 2,
  );

  setUp(() async {
    mockRepository = MockFollowRepository();
    await GetIt.I.reset();
    GetIt.I.registerSingleton<FollowRepository>(mockRepository);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  group('FollowNotifier', () {
    test('build fetches isFollowing status from repository', () async {
      const profile = PublicProfile(
        id: userId,
        username: 'testuser',
        tier: 'FREE',
        isFollowing: true,
        stats: publicStats,
        isFollowedBy: false,
        isBlocked: false,
      );

      when(() => mockRepository.getPublicProfile(userId.toString()))
          .thenAnswer((_) async => const dartz_either.Right(profile));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(followStateProvider(userId).future);

      expect(result, true);
      verify(() => mockRepository.getPublicProfile(userId.toString())).called(1);
    });

    test('setInitialState updates state if not seeded', () async {
      const profile = PublicProfile(
        id: userId,
        username: 'testuser',
        tier: 'FREE',
        isFollowing: false,
        stats: publicStats,
        isFollowedBy: false,
        isBlocked: false,
      );

      when(() => mockRepository.getPublicProfile(userId.toString()))
          .thenAnswer((_) async => const dartz_either.Right(profile));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(followStateProvider(userId).notifier);
      notifier.setInitialState(true);

      final state = container.read(followStateProvider(userId));
      expect(state.value, true);
    });

    test('toggleFollow toggles state and calls repository follow', () async {
      const profile = PublicProfile(
        id: userId,
        username: 'testuser',
        tier: 'FREE',
        isFollowing: false,
        stats: publicStats,
        isFollowedBy: false,
        isBlocked: false,
      );

      when(() => mockRepository.getPublicProfile(userId.toString()))
          .thenAnswer((_) async => const dartz_either.Right(profile));
      when(() => mockRepository.followUser(userId))
          .thenAnswer((_) async => const dartz_either.Right(true));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(followStateProvider(userId).future);
      
      await container.read(followStateProvider(userId).notifier).toggleFollow();

      expect(container.read(followStateProvider(userId)).value, true);
      expect(container.read(followRefreshTickProvider), 1);
      verify(() => mockRepository.followUser(userId)).called(1);
    });

    test('toggleFollow reverts state on failure', () async {
      const profile = PublicProfile(
        id: userId,
        username: 'testuser',
        tier: 'FREE',
        isFollowing: false,
        stats: publicStats,
        isFollowedBy: false,
        isBlocked: false,
      );

      when(() => mockRepository.getPublicProfile(userId.toString()))
          .thenAnswer((_) async => const dartz_either.Right(profile));
      when(() => mockRepository.followUser(userId))
          .thenAnswer((_) async => dartz_either.Left(ServerFailure('error')));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(followStateProvider(userId).future);
      
      await container.read(followStateProvider(userId).notifier).toggleFollow();

      // Should be back to false
      expect(container.read(followStateProvider(userId)).value, false);
      verify(() => mockRepository.followUser(userId)).called(1);
    });
  });
}
