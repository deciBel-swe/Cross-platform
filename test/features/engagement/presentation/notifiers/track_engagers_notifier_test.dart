import 'package:dartz/dartz.dart';
import 'package:decibel/features/engagement/domain/entities/paginated_engagers.dart';
import 'package:decibel/features/engagement/domain/entities/track_engager.dart';
import 'package:decibel/features/engagement/domain/repositories/track_social_repository.dart';
import 'package:decibel/features/engagement/presentation/notifiers/track_engagers_notifier.dart';
import 'package:decibel/features/engagement/presentation/providers/track_social_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackSocialRepository extends Mock
    implements ITrackSocialRepository {}

void main() {
  late MockTrackSocialRepository mockRepository;

  setUp(() {
    mockRepository = MockTrackSocialRepository();

    when(() => mockRepository.likeTrack(any())).thenAnswer((_) async {});
    when(() => mockRepository.unlikeTrack(any())).thenAnswer((_) async {});
    when(() => mockRepository.repostTrack(any())).thenAnswer((_) async {});
    when(() => mockRepository.unrepostTrack(any())).thenAnswer((_) async {});
  });

  test('fetches initial likers page', () async {
    when(
      () => mockRepository.fetchTrackLikers(trackId: 99, page: 0, size: 20),
    ).thenAnswer(
      (_) async => const Right(
        PaginatedEngagers(
          content: [
            TrackEngager(
              id: 1,
              username: 'u1',
              tier: 'FREE',
              isFollowing: false,
            ),
          ],
          pageNumber: 0,
          pageSize: 20,
          totalElements: 1,
          totalPages: 1,
          isLast: true,
        ),
      ),
    );

    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final value = await container.read(
      trackEngagersProvider((trackId: 99, type: EngagerType.likers)).future,
    );

    expect(value.content, hasLength(1));
    expect(value.content.first.username, 'u1');
    verify(
      () => mockRepository.fetchTrackLikers(trackId: 99, page: 0, size: 20),
    ).called(1);
  });

  test('loadMore appends next reposters page', () async {
    when(
      () => mockRepository.fetchTrackReposters(trackId: 77, page: 0, size: 20),
    ).thenAnswer(
      (_) async => const Right(
        PaginatedEngagers(
          content: [
            TrackEngager(
              id: 1,
              username: 'u1',
              tier: 'FREE',
              isFollowing: false,
            ),
          ],
          pageNumber: 0,
          pageSize: 20,
          totalElements: 2,
          totalPages: 2,
          isLast: false,
        ),
      ),
    );

    when(
      () => mockRepository.fetchTrackReposters(trackId: 77, page: 1, size: 20),
    ).thenAnswer(
      (_) async => const Right(
        PaginatedEngagers(
          content: [
            TrackEngager(id: 2, username: 'u2', tier: 'PRO', isFollowing: true),
          ],
          pageNumber: 1,
          pageSize: 20,
          totalElements: 2,
          totalPages: 2,
          isLast: true,
        ),
      ),
    );

    final container = ProviderContainer(
      overrides: [
        trackSocialRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final provider = trackEngagersProvider((
      trackId: 77,
      type: EngagerType.reposters,
    ));

    await container.read(provider.future);
    await container.read(provider.notifier).loadMore();

    final value = container.read(provider).valueOrNull;
    expect(value, isNotNull);
    expect(value!.content, hasLength(2));
    expect(value.content.map((e) => e.id), containsAll(<int>[1, 2]));
  });
}
