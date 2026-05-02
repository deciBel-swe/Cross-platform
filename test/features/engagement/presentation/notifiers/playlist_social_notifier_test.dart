import 'package:dartz/dartz.dart' as dartz_either;
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/engagement/domain/repositories/playlist_social_repository.dart';
import 'package:decibel/features/engagement/presentation/providers/playlist_social_provider.dart';
import 'package:decibel/features/playlists/domain/entities/playlist.dart';
import 'package:decibel/features/playlists/presentation/notifiers/playlist_details_notifier.dart';
import 'package:decibel/features/playlists/presentation/providers/playlist_details_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockPlaylistSocialRepository extends Mock implements IPlaylistSocialRepository {}

class MockPlaylistDetailsNotifier extends AutoDisposeFamilyAsyncNotifier<Playlist, int>
    with Mock
    implements PlaylistDetailsNotifier {}

void main() {
  late MockPlaylistSocialRepository mockRepository;
  late MockPlaylistDetailsNotifier mockDetailsNotifier;
  const playlistId = 456;

  final playlist = Playlist(
    id: playlistId,
    title: 'Test Playlist',
    type: 'public',
    isPrivate: false,
    isLiked: false,
    tracks: const [],
    totalDurationSeconds: 0,
    trackCount: 0,
  );

  setUp(() async {
    mockRepository = MockPlaylistSocialRepository();
    mockDetailsNotifier = MockPlaylistDetailsNotifier();
    await GetIt.I.reset();
    GetIt.I.registerSingleton<IPlaylistSocialRepository>(mockRepository);
    
    // Register fallback for mocktail
    registerFallbackValue(playlistId);
    
    when(() => mockDetailsNotifier.build(any())).thenAnswer((_) async => playlist);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  group('PlaylistSocialNotifier', () {
    test('build fetches initial liked status from playlistDetailsProvider', () async {
      final container = ProviderContainer(
        overrides: [
          playlistDetailsProvider.overrideWith(() => mockDetailsNotifier),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(playlistSocialProvider(playlistId).future);

      expect(result.isLiked, false);
      verify(() => mockDetailsNotifier.build(playlistId)).called(1);
    });

    test('toggleLike performs optimistic update and calls repository', () async {
      when(() => mockRepository.toggleLike(playlistId, false))
          .thenAnswer((_) async => const dartz_either.Right(true));

      final container = ProviderContainer(
        overrides: [
          playlistDetailsProvider.overrideWith(() => mockDetailsNotifier),
        ],
      );
      addTearDown(container.dispose);

      // Initialize
      await container.read(playlistSocialProvider(playlistId).future);

      // Toggle
      await container.read(playlistSocialProvider(playlistId).notifier).toggleLike();

      final state = container.read(playlistSocialProvider(playlistId));
      expect(state.value?.isLiked, true);
      verify(() => mockRepository.toggleLike(playlistId, false)).called(1);
    });

    test('toggleLike reverts on failure', () async {
      when(() => mockRepository.toggleLike(playlistId, false))
          .thenAnswer((_) async => dartz_either.Left(ServerFailure('error')));

      final container = ProviderContainer(
        overrides: [
          playlistDetailsProvider.overrideWith(() => mockDetailsNotifier),
        ],
      );
      addTearDown(container.dispose);

      // Initialize
      await container.read(playlistSocialProvider(playlistId).future);

      // Toggle
      await container.read(playlistSocialProvider(playlistId).notifier).toggleLike();

      final state = container.read(playlistSocialProvider(playlistId));
      expect(state.value?.isLiked, false);
    });
  });
}

class ServerFailure extends Mock implements Failure {
  final String message;
  ServerFailure(this.message);
}
