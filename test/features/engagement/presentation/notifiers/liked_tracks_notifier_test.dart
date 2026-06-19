import 'package:decibel/features/engagement/domain/repositories/track_social_repository.dart';
import 'package:decibel/features/engagement/presentation/notifiers/liked_tracks_notifier.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/paginated_tracks.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackSocialRepository extends Mock
    implements ITrackSocialRepository {}

Track _track(int id) => Track(
  id: id,
  title: 'Track $id',
  artist: const Artist(id: 1, username: 'tester'),
  genre: 'House',
  tags: const [],
  state: TrackStatus.finished,
  releaseDate: DateTime(2026, 1, 1),
  playCount: 0,
  likeCount: 0,
  repostCount: 0,
  isLiked: false,
  isReposted: false,
  trackDurationSeconds: 120, createdAt: DateTime(2026, 1, 1),
);

void main() {
  late MockTrackSocialRepository mockRepository;

  setUp(() async {
    mockRepository = MockTrackSocialRepository();
    await GetIt.I.reset();
    GetIt.I.registerSingleton<ITrackSocialRepository>(mockRepository);

    when(() => mockRepository.likeTrack(any())).thenAnswer((_) async {});
    when(() => mockRepository.unlikeTrack(any())).thenAnswer((_) async {});
    when(() => mockRepository.repostTrack(any())).thenAnswer((_) async {});
    when(() => mockRepository.unrepostTrack(any())).thenAnswer((_) async {});
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  test('liked provider fetches first page from liked endpoint', () async {
    when(() => mockRepository.getLikedTracks(page: 0, size: 20)).thenAnswer(
      (_) async => PaginatedTracks(
        content: [_track(1)],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 1,
        totalPages: 1,
        isLast: true,
      ),
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final value = await container.read(likedTracksProvider.future);

    expect(value, hasLength(1));
    expect(value.first.id, 1);
    verify(() => mockRepository.getLikedTracks(page: 0, size: 20)).called(1);
  });

  test('reposted provider fetches first page from reposted endpoint', () async {
    when(() => mockRepository.getRepostedTracks(page: 0, size: 20)).thenAnswer(
      (_) async => PaginatedTracks(
        content: [_track(5)],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 1,
        totalPages: 1,
        isLast: true,
      ),
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final value = await container.read(repostedTracksProvider.future);

    expect(value, hasLength(1));
    expect(value.first.id, 5);
    verify(() => mockRepository.getRepostedTracks(page: 0, size: 20)).called(1);
  });

  test('loadMore appends only unique tracks', () async {
    when(() => mockRepository.getLikedTracks(page: 0, size: 20)).thenAnswer(
      (_) async => PaginatedTracks(
        content: [_track(1)],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 2,
        totalPages: 2,
        isLast: false,
      ),
    );

    when(() => mockRepository.getLikedTracks(page: 1, size: 20)).thenAnswer(
      (_) async => PaginatedTracks(
        content: [_track(1), _track(2)],
        pageNumber: 1,
        pageSize: 20,
        totalElements: 2,
        totalPages: 2,
        isLast: true,
      ),
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(likedTracksProvider.future);
    await container.read(likedTracksProvider.notifier).loadMore();

    final tracks = container.read(likedTracksProvider).valueOrNull;
    expect(tracks, isNotNull);
    expect(tracks!, hasLength(2));
    expect(tracks.map((t) => t.id), containsAll(<int>[1, 2]));
  });

  test('removeTrackLocal removes matching track id', () async {
    when(() => mockRepository.getLikedTracks(page: 0, size: 20)).thenAnswer(
      (_) async => PaginatedTracks(
        content: [_track(1), _track(2)],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 2,
        totalPages: 1,
        isLast: true,
      ),
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(likedTracksProvider.future);
    container.read(likedTracksProvider.notifier).removeTrackLocal(1);

    final tracks = container.read(likedTracksProvider).valueOrNull;
    expect(tracks, isNotNull);
    expect(tracks!.map((t) => t.id).toList(), [2]);
  });
}
