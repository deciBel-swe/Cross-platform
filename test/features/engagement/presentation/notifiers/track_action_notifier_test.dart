import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/features/engagement/domain/models/track_action_data.dart';
import 'package:decibel/features/engagement/domain/repositories/track_social_repository.dart';
import 'package:decibel/features/engagement/presentation/providers/track_social_provider.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library_profile/domain/repositories/track_repository.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackSocialRepository extends Mock
    implements ITrackSocialRepository {}

class MockTrackRepository extends Mock implements TrackRepository {}

class MockTrack extends Mock implements Track {}

void main() {
  late MockTrackSocialRepository mockSocialRepo;
  late MockTrackRepository mockTrackRepo;

  setUp(() {
    mockSocialRepo = MockTrackSocialRepository();
    mockTrackRepo = MockTrackRepository();

    when(() => mockSocialRepo.likeTrack(any())).thenAnswer((_) async {});
    when(() => mockSocialRepo.unlikeTrack(any())).thenAnswer((_) async {});
    when(() => mockSocialRepo.repostTrack(any())).thenAnswer((_) async {});
    when(() => mockSocialRepo.unrepostTrack(any())).thenAnswer((_) async {});

    // Default fetch behavior
    final mockTrack = MockTrack();
    when(() => mockTrack.isLiked).thenReturn(false);
    when(() => mockTrack.likeCount).thenReturn(0);
    when(() => mockTrack.isReposted).thenReturn(false);
    when(() => mockTrack.repostCount).thenReturn(0);

    when(
      () => mockTrackRepo.fetchTrackById(any()),
    ).thenAnswer((_) async => Right(mockTrack));
  });

  test('build() fetches and verifies state from repository', () async {
    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockSocialRepo),
        trackRepositoryProvider.overrideWithValue(mockTrackRepo),
      ],
    );
    addTearDown(container.dispose);

    // 1. Initially it should be loading
    expect(container.read(trackSocialProvider(7)).isLoading, isTrue);

    // 2. Wait for fetch to complete
    final data = await container.read(trackSocialProvider(7).future);

    // 3. Verify data (mock returns all false/0 by default)
    expect(data.isLiked, isFalse);
    expect(data.likeCount, 0);
    verify(() => mockTrackRepo.fetchTrackById(7)).called(1);
  });

  test('toggleAction(like) updates state and calls repository', () async {
    // Configure mock to return specific track status
    final initialTrack = MockTrack();
    when(() => initialTrack.isLiked).thenReturn(false);
    when(() => initialTrack.likeCount).thenReturn(4);
    when(() => initialTrack.isReposted).thenReturn(false);
    when(() => initialTrack.repostCount).thenReturn(0);
    final syncedTrack = MockTrack();
    when(() => syncedTrack.isLiked).thenReturn(true);
    when(() => syncedTrack.likeCount).thenReturn(12);
    when(() => syncedTrack.isReposted).thenReturn(false);
    when(() => syncedTrack.repostCount).thenReturn(0);

    var fetchCount = 0;
    when(() => mockTrackRepo.fetchTrackById(10)).thenAnswer((_) async {
      fetchCount += 1;
      return Right(fetchCount == 1 ? initialTrack : syncedTrack);
    });

    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockSocialRepo),
        trackRepositoryProvider.overrideWithValue(mockTrackRepo),
      ],
    );
    addTearDown(container.dispose);

    // Wait for initial fetch
    await container.read(trackSocialProvider(10).future);

    // Toggle to "Liked"
    await container
        .read(trackSocialProvider(10).notifier)
        .toggleAction(SocialActionType.like);

    final state = container.read(trackSocialProvider(10));
    expect(state.value?.isLiked, isTrue);
    expect(state.value?.likeCount, 12);
    verify(() => mockSocialRepo.likeTrack(10)).called(1);
    verify(() => mockTrackRepo.fetchTrackById(10)).called(2);
  });

  test('toggleAction applies optimistic counts before refresh', () async {
    final initialTrack = MockTrack();
    when(() => initialTrack.isLiked).thenReturn(false);
    when(() => initialTrack.likeCount).thenReturn(0);
    when(() => initialTrack.isReposted).thenReturn(false);
    when(() => initialTrack.repostCount).thenReturn(0);

    final syncedTrack = MockTrack();
    when(() => syncedTrack.isLiked).thenReturn(true);
    when(() => syncedTrack.likeCount).thenReturn(5);
    when(() => syncedTrack.isReposted).thenReturn(false);
    when(() => syncedTrack.repostCount).thenReturn(0);

    var fetchCount = 0;
    when(() => mockTrackRepo.fetchTrackById(20)).thenAnswer((_) async {
      fetchCount += 1;
      return Right(fetchCount == 1 ? initialTrack : syncedTrack);
    });

    final completer = Completer<void>();
    when(
      () => mockSocialRepo.likeTrack(20),
    ).thenAnswer((_) => completer.future);

    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockSocialRepo),
        trackRepositoryProvider.overrideWithValue(mockTrackRepo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(trackSocialProvider(20).future);

    final toggleFuture = container
        .read(trackSocialProvider(20).notifier)
        .toggleAction(SocialActionType.like);

    final optimisticState = container.read(trackSocialProvider(20));
    expect(optimisticState.value?.isLiked, isTrue);
    expect(optimisticState.value?.likeCount, 1);

    completer.complete();
    await toggleFuture;

    final refreshedState = container.read(trackSocialProvider(20));
    expect(refreshedState.value?.likeCount, 5);
  });

  test('toggleAction queues rapid toggles in order', () async {
    final initialTrack = MockTrack();
    when(() => initialTrack.isLiked).thenReturn(false);
    when(() => initialTrack.likeCount).thenReturn(0);
    when(() => initialTrack.isReposted).thenReturn(false);
    when(() => initialTrack.repostCount).thenReturn(0);

    final unlikedTrack = MockTrack();
    when(() => unlikedTrack.isLiked).thenReturn(false);
    when(() => unlikedTrack.likeCount).thenReturn(0);
    when(() => unlikedTrack.isReposted).thenReturn(false);
    when(() => unlikedTrack.repostCount).thenReturn(0);

    final likedTrack = MockTrack();
    when(() => likedTrack.isLiked).thenReturn(true);
    when(() => likedTrack.likeCount).thenReturn(1);
    when(() => likedTrack.isReposted).thenReturn(false);
    when(() => likedTrack.repostCount).thenReturn(0);

    var fetchCount = 0;
    when(() => mockTrackRepo.fetchTrackById(30)).thenAnswer((_) async {
      fetchCount += 1;
      if (fetchCount == 1) {
        return Right(initialTrack);
      }
      return Right(fetchCount == 2 ? unlikedTrack : likedTrack);
    });

    final likeCompleter = Completer<void>();
    final unlikeCompleter = Completer<void>();
    when(
      () => mockSocialRepo.likeTrack(30),
    ).thenAnswer((_) => likeCompleter.future);
    when(
      () => mockSocialRepo.unlikeTrack(30),
    ).thenAnswer((_) => unlikeCompleter.future);

    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockSocialRepo),
        trackRepositoryProvider.overrideWithValue(mockTrackRepo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(trackSocialProvider(30).future);

    final notifier = container.read(trackSocialProvider(30).notifier);
    final firstToggle = notifier.toggleAction(SocialActionType.like);
    final secondToggle = notifier.toggleAction(SocialActionType.like);

    await Future<void>.delayed(Duration.zero);
    verify(() => mockSocialRepo.likeTrack(30)).called(1);
    verifyNever(() => mockSocialRepo.unlikeTrack(30));

    likeCompleter.complete();
    await Future<void>.delayed(Duration.zero);
    verify(() => mockSocialRepo.unlikeTrack(30)).called(1);

    unlikeCompleter.complete();
    await secondToggle;

    await firstToggle;

    final state = container.read(trackSocialProvider(30));
    expect(state.value?.isLiked, isFalse);
    expect(state.value?.likeCount, 0);
  });

  test('toggleAction keeps repost false after rapid toggles', () async {
    final initialTrack = MockTrack();
    when(() => initialTrack.isLiked).thenReturn(false);
    when(() => initialTrack.likeCount).thenReturn(0);
    when(() => initialTrack.isReposted).thenReturn(false);
    when(() => initialTrack.repostCount).thenReturn(0);

    final repostedTrack = MockTrack();
    when(() => repostedTrack.isLiked).thenReturn(false);
    when(() => repostedTrack.likeCount).thenReturn(0);
    when(() => repostedTrack.isReposted).thenReturn(true);
    when(() => repostedTrack.repostCount).thenReturn(1);

    final unrepostedTrack = MockTrack();
    when(() => unrepostedTrack.isLiked).thenReturn(false);
    when(() => unrepostedTrack.likeCount).thenReturn(0);
    when(() => unrepostedTrack.isReposted).thenReturn(false);
    when(() => unrepostedTrack.repostCount).thenReturn(0);

    var fetchCount = 0;
    when(() => mockTrackRepo.fetchTrackById(40)).thenAnswer((_) async {
      fetchCount += 1;
      if (fetchCount == 1) {
        return Right(initialTrack);
      }
      return Right(fetchCount.isEven ? repostedTrack : unrepostedTrack);
    });

    when(() => mockSocialRepo.repostTrack(40)).thenAnswer((_) async {});
    when(() => mockSocialRepo.unrepostTrack(40)).thenAnswer((_) async {});

    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockSocialRepo),
        trackRepositoryProvider.overrideWithValue(mockTrackRepo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(trackSocialProvider(40).future);

    final notifier = container.read(trackSocialProvider(40).notifier);
    await notifier.toggleAction(SocialActionType.repost);
    await notifier.toggleAction(SocialActionType.repost);
    await notifier.toggleAction(SocialActionType.repost);
    await notifier.toggleAction(SocialActionType.repost);

    final state = container.read(trackSocialProvider(40));
    expect(state.value?.isReposted, isFalse);
    expect(state.value?.repostCount, 0);
  });

  test('toggleAction(repost) syncs backend counts', () async {
    final initialTrack = MockTrack();
    when(() => initialTrack.isLiked).thenReturn(false);
    when(() => initialTrack.likeCount).thenReturn(3);
    when(() => initialTrack.isReposted).thenReturn(false);
    when(() => initialTrack.repostCount).thenReturn(0);

    final syncedTrack = MockTrack();
    when(() => syncedTrack.isLiked).thenReturn(false);
    when(() => syncedTrack.likeCount).thenReturn(3);
    when(() => syncedTrack.isReposted).thenReturn(true);
    when(() => syncedTrack.repostCount).thenReturn(7);

    var fetchCount = 0;
    when(() => mockTrackRepo.fetchTrackById(12)).thenAnswer((_) async {
      fetchCount += 1;
      return Right(fetchCount == 1 ? initialTrack : syncedTrack);
    });

    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockSocialRepo),
        trackRepositoryProvider.overrideWithValue(mockTrackRepo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(trackSocialProvider(12).future);

    await container
        .read(trackSocialProvider(12).notifier)
        .toggleAction(SocialActionType.repost);

    final state = container.read(trackSocialProvider(12));
    expect(state.value?.isReposted, isTrue);
    expect(state.value?.repostCount, 7);
    verify(() => mockSocialRepo.repostTrack(12)).called(1);
    verify(() => mockTrackRepo.fetchTrackById(12)).called(2);
  });

  test('toggleAction rolls back when repository throws AppException', () async {
    when(
      () => mockSocialRepo.likeTrack(any()),
    ).thenThrow(const ServerException('failed'));

    final originalTrack = MockTrack();
    when(() => originalTrack.isLiked).thenReturn(false);
    when(() => originalTrack.likeCount).thenReturn(6);
    when(() => originalTrack.isReposted).thenReturn(false);
    when(() => originalTrack.repostCount).thenReturn(0);
    when(
      () => mockTrackRepo.fetchTrackById(11),
    ).thenAnswer((_) async => Right(originalTrack));

    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockSocialRepo),
        trackRepositoryProvider.overrideWithValue(mockTrackRepo),
      ],
    );
    addTearDown(container.dispose);

    // Wait for initial fetch
    await container.read(trackSocialProvider(11).future);

    await container
        .read(trackSocialProvider(11).notifier)
        .toggleAction(SocialActionType.like);

    final state = container.read(trackSocialProvider(11));
    expect(state.value?.isLiked, isFalse);
    expect(state.value?.likeCount, 6);
  });
}
