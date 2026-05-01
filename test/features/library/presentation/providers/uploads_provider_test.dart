import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/domain/entities/auth_user.dart';
import 'package:decibel/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/paginated_tracks.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/library_profile/domain/repositories/track_repository.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_repository_provider.dart';
import 'package:decibel/features/library_profile/presentation/providers/uploads_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackRepository extends Mock implements TrackRepository {}

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(this.initialState);
  final AuthState initialState;

  @override
  FutureOr<AuthState> build() => initialState;
}

// Fallbacks
class FakeTrack extends Fake implements Track {}

void main() {
  late MockTrackRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(FakeTrack());
  });

  setUp(() {
    mockRepo = MockTrackRepository();
    // Start fresh
    UploadsNotifier.clearMemoryCache();
  });

  ProviderContainer createContainer({required AuthState authState}) {
    return ProviderContainer(
      overrides: [
        trackRepositoryProvider.overrideWithValue(mockRepo),
        authStateProvider.overrideWith(() => FakeAuthNotifier(authState)),
      ],
    );
  }

  group('UploadsNotifier', () {
    const user = AuthUser(id: 1, username: 'test_user', tier: UserTier.free);
    const authState = AuthAuthenticated(user: user);

    test('initial build fetches tracks for authenticated user', () async {
      final tracks = [
        Track(
          id: 1,
          title: 'Track 1',
          artist: const Artist(id: 1, username: 'User'),
          genre: 'Pop',
          tags: [],
          state: TrackStatus.finished,
          releaseDate: DateTime.now(),
          playCount: 10,
          likeCount: 5,
          repostCount: 0,
          isLiked: false,
          isReposted: false,
          trackDurationSeconds: 120, createdAt: DateTime.now(),
        ),
      ];
      final paginated = PaginatedTracks(
        content: tracks,
        pageNumber: 0,
        pageSize: 20,
        totalElements: 1,
        totalPages: 1,
        isLast: true,
      );

      when(
        () => mockRepo.fetchMyTracks(page: 0, size: 20),
      ).thenAnswer((_) async => Right(paginated));

      final container = createContainer(authState: authState);
      container.listen(uploadsProvider, (_, _) {}); // Keep alive

      final state = await container.read(uploadsProvider.future);

      expect(state, tracks);
      verify(() => mockRepo.fetchMyTracks(page: 0, size: 20)).called(1);
    });

    test('initial build returns empty list if unauthenticated', () async {
      final container = createContainer(authState: const AuthUnauthenticated());
      container.listen(uploadsProvider, (_, _) {}); // Keep alive

      final state = await container.read(uploadsProvider.future);

      expect(state, isEmpty);
      verifyNever(
        () => mockRepo.fetchMyTracks(
          page: any(named: 'page'),
          size: any(named: 'size'),
        ),
      );
    });

    test('initial build keeps failed uploads visible', () async {
      final failedTrack = Track(
        id: 7,
        title: 'Failed Track',
        artist: const Artist(id: 1, username: 'User'),
        genre: 'Pop',
        tags: [],
        state: TrackStatus.failed,
        releaseDate: DateTime.now(),
        playCount: 0,
        likeCount: 0,
        repostCount: 0,
        isLiked: false,
        isReposted: false,
        trackDurationSeconds: 120, createdAt: DateTime.now(),
      );

      when(() => mockRepo.fetchMyTracks(page: 0, size: 20)).thenAnswer(
        (_) async => Right(
          PaginatedTracks(
            content: [failedTrack],
            pageNumber: 0,
            pageSize: 20,
            totalElements: 1,
            totalPages: 1,
            isLast: true,
          ),
        ),
      );

      final container = createContainer(authState: authState);
      container.listen(uploadsProvider, (_, _) {});

      final state = await container.read(uploadsProvider.future);

      expect(state, hasLength(1));
      expect(state.first.id, failedTrack.id);
      expect(state.first.state, TrackStatus.failed);
    });

    test('refreshAll re-fetches data', () async {
      // Setup mock before container creation due to sync build
      when(() => mockRepo.fetchMyTracks(page: 0, size: 20)).thenAnswer(
        (_) async => const Right(
          PaginatedTracks(
            content: [],
            pageNumber: 0,
            pageSize: 20,
            totalElements: 0,
            totalPages: 0,
            isLast: true,
          ),
        ),
      );

      final container = createContainer(authState: authState);
      container.listen(uploadsProvider, (_, _) {}); // Keep alive

      // Ensure initial load completes
      await container.read(uploadsProvider.future);

      // Wait for async auth state to settle if needed, though future completion implies a value
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Verify fetchTracks was called once by initial build
      verify(() => mockRepo.fetchMyTracks(page: 0, size: 20)).called(1);

      clearInteractions(mockRepo);

      // Act
      await container.read(uploadsProvider.notifier).refreshAll();

      // Allow async operations to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final refreshState = container.read(uploadsProvider);
      expect(
        refreshState.hasError,
        isFalse,
        reason: 'Refresh failed with error: ${refreshState.error}',
      );

      // Verify called ONCE (refresh only)
      verify(() => mockRepo.fetchMyTracks(page: 0, size: 20)).called(1);
    });

    test('loadNextPage fetches next page', () async {
      // Page 0
      final page0 = PaginatedTracks(
        content: [
          Track(
            id: 1,
            title: 'T1',
            artist: const Artist(id: 1, username: 'U'),
            genre: '',
            tags: [],
            state: TrackStatus.finished,
            releaseDate: DateTime.now(),
            playCount: 0,
            likeCount: 0,
            repostCount: 0,
            isLiked: false,
            isReposted: false,
            trackDurationSeconds: 120, createdAt: DateTime.now(),
          ),
        ],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 2,
        totalPages: 1,
        isLast: false, // Not last
      );

      // Page 1
      final page1 = PaginatedTracks(
        content: [
          Track(
            id: 2,
            title: 'T2',
            artist: const Artist(id: 1, username: 'U'),
            genre: '',
            tags: [],
            state: TrackStatus.finished,
            releaseDate: DateTime.now(),
            playCount: 0,
            likeCount: 0,
            repostCount: 0,
            isLiked: false,
            isReposted: false,
            trackDurationSeconds: 120, createdAt: DateTime.now(),
          ),
        ],
        pageNumber: 1,
        pageSize: 20,
        totalElements: 2,
        totalPages: 1,
        isLast: true,
      );

      when(
        () => mockRepo.fetchMyTracks(page: 0, size: 20),
      ).thenAnswer((_) async => Right(page0));

      when(
        () => mockRepo.fetchMyTracks(page: 1, size: 20),
      ).thenAnswer((_) async => Right(page1));

      final container = createContainer(authState: authState);
      container.listen(uploadsProvider, (_, _) {}); // Keep alive

      // Load initial
      await container.read(uploadsProvider.future);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Act
      await container.read(uploadsProvider.notifier).loadNextPage();

      // Assert
      final state = container.read(uploadsProvider).value;
      expect(state, hasLength(2));
      expect(state![0].id, 1);
      expect(state[1].id, 2);
    });

    test('addTrack updates state optimistically', () async {
      when(() => mockRepo.fetchMyTracks(page: 0, size: 20)).thenAnswer(
        (_) async => const Right(
          PaginatedTracks(
            content: [],
            pageNumber: 0,
            pageSize: 20,
            totalElements: 0,
            totalPages: 0,
            isLast: true,
          ),
        ),
      );

      final container = createContainer(authState: authState);
      container.listen(uploadsProvider, (_, _) {}); // Keep alive

      await container.read(uploadsProvider.future);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final newTrack = Track(
        id: 99,
        title: 'Optimistic Track',
        artist: const Artist(id: 1, username: 'User'),
        genre: 'Pop',
        tags: [],
        state: TrackStatus.processing,
        releaseDate: DateTime.now(),
        playCount: 0,
        likeCount: 0,
        repostCount: 0,
        isLiked: false,
        isReposted: false,
        trackDurationSeconds: 120, createdAt: DateTime.now(),
      );

      // Act
      container.read(uploadsProvider.notifier).addTrack(newTrack);

      // Assert
      final state = container.read(uploadsProvider).value;
      expect(state, hasLength(1));
      expect(state!.first.id, 99);
      expect(state.first.state, TrackStatus.processing);
    });

    test('deleteTrack removes track from loaded uploads', () async {
      final firstTrack = Track(
        id: 1,
        title: 'First Track',
        artist: const Artist(id: 1, username: 'User'),
        genre: 'Pop',
        tags: [],
        state: TrackStatus.finished,
        releaseDate: DateTime.now(),
        playCount: 0,
        likeCount: 0,
        repostCount: 0,
        isLiked: false,
        isReposted: false,
        trackDurationSeconds: 120, createdAt: DateTime.now(),
      );
      final secondTrack = Track(
        id: 2,
        title: 'Second Track',
        artist: const Artist(id: 1, username: 'User'),
        genre: 'Pop',
        tags: [],
        state: TrackStatus.finished,
        releaseDate: DateTime.now(),
        playCount: 0,
        likeCount: 0,
        repostCount: 0,
        isLiked: false,
        isReposted: false,
        trackDurationSeconds: 120, createdAt: DateTime.now(),
      );

      when(() => mockRepo.fetchMyTracks(page: 0, size: 20)).thenAnswer(
        (_) async => Right(
          PaginatedTracks(
            content: [firstTrack, secondTrack],
            pageNumber: 0,
            pageSize: 20,
            totalElements: 2,
            totalPages: 1,
            isLast: true,
          ),
        ),
      );
      when(
        () => mockRepo.deleteTrack(firstTrack.id),
      ).thenAnswer((_) async => const Right(true));

      final container = createContainer(authState: authState);
      container.listen(uploadsProvider, (_, _) {});
      await container.read(uploadsProvider.future);

      final deleted = await container
          .read(uploadsProvider.notifier)
          .deleteTrack(firstTrack.id);

      final state = container.read(uploadsProvider).value;
      expect(deleted, isTrue);
      expect(state, hasLength(1));
      expect(state!.first.id, secondTrack.id);
      verify(() => mockRepo.deleteTrack(firstTrack.id)).called(1);
    });

    test('invalidateCache just clears memory cache', () async {
      when(() => mockRepo.fetchMyTracks(page: 0, size: 20)).thenAnswer(
        (_) async => const Right(
          PaginatedTracks(
            content: [],
            pageNumber: 0,
            pageSize: 20,
            totalElements: 0,
            totalPages: 0,
            isLast: true,
          ),
        ),
      );

      final container = createContainer(authState: authState);
      container.listen(uploadsProvider, (_, _) {}); // Keep alive

      // Initial load
      await container.read(uploadsProvider.future);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Act
      container.read(uploadsProvider.notifier).invalidateCache();

      // No visible state change, but mainly testing it doesn't crash
      final state = container.read(uploadsProvider).value;
      expect(state, isEmpty);
    });
  });
}
