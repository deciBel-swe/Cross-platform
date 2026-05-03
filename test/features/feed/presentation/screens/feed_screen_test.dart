import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/domain/entities/auth_user.dart' as auth;
import 'package:decibel/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/engagement/domain/models/track_action_data.dart';
import 'package:decibel/features/engagement/presentation/notifiers/track_action_notifier.dart';
import 'package:decibel/features/engagement/presentation/providers/track_social_provider.dart';
import 'package:decibel/features/feed/domain/entities/feed_track.dart';
import 'package:decibel/features/feed/domain/entities/paginated_feed.dart';
import 'package:decibel/features/feed/domain/repositories/i_feed_repository.dart';
import 'package:decibel/features/feed/presentation/providers/feed_repository_provider.dart';
import 'package:decibel/features/feed/presentation/screens/feed_screen.dart';
import 'package:decibel/features/library/domain/entities/track.dart' as library_track;
import 'package:decibel/features/library/presentation/notifiers/track_audio_notifier.dart';
import 'package:decibel/features/library/presentation/state/track_audio_state.dart';
import 'package:decibel/features/library_profile/domain/entities/user_profile.dart' as profile;
import 'package:decibel/features/library_profile/presentation/notifiers/user_profile_notifier.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_audio_provider.dart';
import 'package:decibel/features/library_profile/presentation/providers/user_profile_provider.dart';
import 'package:decibel/features/offline/domain/usecases/download_track_usecase.dart';
import 'package:decibel/features/offline/presentation/notifiers/track_download_notifier.dart';
import 'package:decibel/features/offline/presentation/providers/track_download_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFeedRepository extends Mock implements IFeedRepository {}
class MockDownloadTrackUseCase extends Mock implements DownloadTrackUseCase {}

class FakeTrackSocialNotifier extends TrackSocialNotifier {
  @override
  FutureOr<TrackSocialData> build(int arg) => const TrackSocialData(
        isLiked: false,
        likeCount: 0,
        isReposted: false,
        repostCount: 0,
      );
}

class FakeTrackAudioNotifier extends TrackAudioNotifier {
  @override
  TrackAudioState build() => const TrackAudioState();
  
  @override
  Future<void> playTrack({
    required library_track.Track track,
    List<library_track.Track>? queue,
    Duration duration = Duration.zero,
    bool autoPlay = true,
  }) async {}
}

class FakeUserProfileNotifier extends UserProfileNotifier {
  @override
  Future<Either<Failure, profile.UserProfile>> build() async =>
      const Right(profile.UserProfile(
        id: 1,
        role: 'user',
        email: 'test@test.com',
        username: 'test',
        emailVerified: true,
        tier: profile.UserTier.free,
        profileDetails: profile.UserProfileDetails(favoriteGenres: []),
        privacySettings: profile.PrivacySettings(isPrivate: false, showHistory: true),
        stats: profile.UserStats(followers: 0, following: 0, tracksCount: 0),
      ));
}

class FakeAuthNotifier extends AuthNotifier {
  @override
  FutureOr<AuthState> build() => const AuthAuthenticated(
        user: auth.AuthUser(id: 1, username: 'test', tier: auth.UserTier.free),
      );
}

class FakeTrackDownloadNotifier extends TrackDownloadNotifier {
  FakeTrackDownloadNotifier(super.useCase);
}

void main() {
  late MockFeedRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const AsyncValue<PaginatedFeed>.loading());
  });

  setUp(() {
    mockRepository = MockFeedRepository();
  });

  FeedTrack createFeedTrack(int id) {
    return FeedTrack(
      id: id,
      title: 'Track $id',
      artistId: id,
      artistUsername: 'artist$id',
      genre: 'Rock',
      access: 'PLAYABLE',
      isReposted: false,
      isLiked: false,
      tags: [],
      releaseDate: DateTime.now(),
      playCount: 100,
      likeCount: 10,
      repostCount: 5,
      commentCount: 2,
      isPrivate: false,
      uploadDate: DateTime.now(),
      trackDurationSeconds: 180,
    );
  }

  Widget createWidget({Size size = const Size(1080, 1920)}) {
    return ProviderScope(
      overrides: [
        feedRepositoryProvider.overrideWithValue(mockRepository),
        trackSocialProvider.overrideWith(() => FakeTrackSocialNotifier()),
        trackAudioProvider.overrideWith(() => FakeTrackAudioNotifier()),
        userProfileProvider.overrideWith(() => FakeUserProfileNotifier()),
        authStateProvider.overrideWith(() => FakeAuthNotifier()),
        trackDownloadProvider.overrideWith((ref) => FakeTrackDownloadNotifier(MockDownloadTrackUseCase())),
        mobileMiniPlayerSuppressedProvider.overrideWith((ref) => false),
      ],
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: const FeedScreen(),
        ),
      ),
    );
  }

  group('FeedScreen', () {
    testWidgets('renders loading state initially', (tester) async {
      when(() => mockRepository.getFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) => Completer<Either<Failure, PaginatedFeed>>().future);

      await tester.pumpWidget(createWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders empty state when no tracks', (tester) async {
      when(() => mockRepository.getFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => const Right<Failure, PaginatedFeed>(PaginatedFeed(
                content: [],
                pageNumber: 0,
                pageSize: 20,
                totalElements: 0,
                totalPages: 0,
                isLast: true,
              )));
      
      when(() => mockRepository.getDiscoverFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => const Right<Failure, PaginatedFeed>(PaginatedFeed(
                content: [],
                pageNumber: 0,
                pageSize: 20,
                totalElements: 0,
                totalPages: 0,
                isLast: true,
              )));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Your feed is empty'), findsOneWidget);
    });

    testWidgets('renders list of tracks when data is available', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      
      final tFeed = PaginatedFeed(
        content: [createFeedTrack(1), createFeedTrack(2)],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 2,
        totalPages: 1,
        isLast: true,
      );

      when(() => mockRepository.getFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => Right<Failure, PaginatedFeed>(tFeed));
      
      when(() => mockRepository.getDiscoverFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => const Right<Failure, PaginatedFeed>(PaginatedFeed(
                content: [],
                pageNumber: 0,
                pageSize: 20,
                totalElements: 0,
                totalPages: 0,
                isLast: true,
              )));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Track 1'), findsOneWidget);
      expect(find.text('Track 2'), findsOneWidget);
    });

    testWidgets('switches to discover tab and renders pager', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      
      final tFeed = PaginatedFeed(
        content: [createFeedTrack(1)],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 1,
        totalPages: 1,
        isLast: true,
      );

      when(() => mockRepository.getFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => Right<Failure, PaginatedFeed>(tFeed));
      
      when(() => mockRepository.getDiscoverFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => Right<Failure, PaginatedFeed>(tFeed));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      // Tap Discover tab
      await tester.tap(find.text('Discover').first);
      await tester.pump();
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('Track 1'), findsOneWidget);
    });

    testWidgets('renders desktop layout header', (tester) async {
      const desktopSize = Size(1440, 900);
      await tester.binding.setSurfaceSize(desktopSize);
      
      when(() => mockRepository.getFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => const Right<Failure, PaginatedFeed>(PaginatedFeed(
                content: [],
                pageNumber: 0,
                pageSize: 20,
                totalElements: 0,
                totalPages: 0,
                isLast: true,
              )));
      
      when(() => mockRepository.getDiscoverFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => const Right<Failure, PaginatedFeed>(PaginatedFeed(
                content: [],
                pageNumber: 0,
                pageSize: 20,
                totalElements: 0,
                totalPages: 0,
                isLast: true,
              )));

      await tester.pumpWidget(createWidget(size: desktopSize));
      await tester.pumpAndSettle();

      expect(find.text('Your Feed'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);
    });

    testWidgets('pull to refresh triggers repository call', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      
      final tFeed = PaginatedFeed(
        content: [createFeedTrack(1)],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 1,
        totalPages: 1,
        isLast: true,
      );

      when(() => mockRepository.getFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => Right<Failure, PaginatedFeed>(tFeed));
      
      when(() => mockRepository.getDiscoverFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => Right<Failure, PaginatedFeed>(tFeed));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      // Perform pull to refresh
      await tester.fling(find.byType(ListView), const Offset(0.0, 300.0), 1000.0);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      
      verify(() => mockRepository.getFeed(page: 0, size: 20)).called(any<int>());
    }, skip: true);

    testWidgets('renders error state and allows retry', (tester) async {
      when(() => mockRepository.getFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => const Left<Failure, PaginatedFeed>(ServerFailure('Error')));

      await tester.pumpWidget(createWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Could not load your feed'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      when(() => mockRepository.getFeed(page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => const Right<Failure, PaginatedFeed>(PaginatedFeed(
                content: [],
                pageNumber: 0,
                pageSize: 20,
                totalElements: 0,
                totalPages: 0,
                isLast: true,
              )));

      await tester.tap(find.text('Retry'));
      await tester.pump();
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('Your feed is empty'), findsOneWidget);
    });
  });
}
