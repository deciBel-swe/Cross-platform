import 'dart:async';
import 'package:dartz/dartz.dart' as dartz_either;
import 'package:decibel/features/auth/domain/entities/auth_state.dart';
import 'package:decibel/features/auth/domain/entities/auth_user.dart';
import 'package:decibel/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/engagement/domain/repositories/playlist_social_repository.dart';
import 'package:decibel/features/engagement/presentation/notifiers/user_liked_playlist_notifier.dart';
import 'package:decibel/features/playlists/domain/entities/playlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockPlaylistSocialRepository extends Mock implements IPlaylistSocialRepository {}

final userLikedPlaylistsProvider =
    AutoDisposeAsyncNotifierProvider<UserLikedPlaylistsNotifier, List<Playlist>>(
  UserLikedPlaylistsNotifier.new,
);

class MockAuthNotifier extends AsyncNotifier<AuthState> with Mock implements AuthNotifier {
  final AsyncValue<AuthState> initialState;
  MockAuthNotifier(this.initialState);

  @override
  FutureOr<AuthState> build() => initialState.value!;
}

void main() {
  late MockPlaylistSocialRepository mockRepository;
  const username = 'testuser';

  const user = AuthUser(
    id: 1,
    username: username,
    tier: UserTier.free,
  );

  final playlist = Playlist(
    id: 1,
    title: 'Liked Playlist',
    type: 'public',
    isPrivate: false,
    isLiked: true,
    tracks: const [],
    totalDurationSeconds: 0,
    trackCount: 0,
  );

  setUp(() async {
    mockRepository = MockPlaylistSocialRepository();
    await GetIt.I.reset();
    GetIt.I.registerSingleton<IPlaylistSocialRepository>(mockRepository);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  group('UserLikedPlaylistsNotifier', () {
    test('build returns empty list if not authenticated', () async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(() => MockAuthNotifier(const AsyncData(AuthUnauthenticated()))),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(userLikedPlaylistsProvider.future);

      expect(result, isEmpty);
    });

    test('build fetches liked playlists if authenticated', () async {
      when(() => mockRepository.getLikedPlaylists(username, page: 0, size: 20))
          .thenAnswer((_) async => dartz_either.Right([playlist]));

      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(() => MockAuthNotifier(const AsyncData(AuthAuthenticated(user: user)))),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(userLikedPlaylistsProvider.future);

      expect(result, hasLength(1));
      expect(result.first.id, 1);
      verify(() => mockRepository.getLikedPlaylists(username, page: 0, size: 20)).called(1);
    });

    test('removePlaylistLocal removes playlist from state', () async {
      when(() => mockRepository.getLikedPlaylists(username, page: 0, size: 20))
          .thenAnswer((_) async => dartz_either.Right([playlist]));

      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith(() => MockAuthNotifier(const AsyncData(AuthAuthenticated(user: user)))),
        ],
      );
      addTearDown(container.dispose);

      await container.read(userLikedPlaylistsProvider.future);
      
      container.read(userLikedPlaylistsProvider.notifier).removePlaylistLocal(1);

      final state = container.read(userLikedPlaylistsProvider);
      expect(state.value, isEmpty);
    });
  });
}
