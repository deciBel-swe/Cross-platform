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
    when(
      () => mockTrackRepo.fetchTrackById(10),
    ).thenAnswer((_) async => Right(initialTrack));

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
    expect(state.value?.likeCount, 5);
    verify(() => mockSocialRepo.likeTrack(10)).called(1);
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
