import 'dart:async';

import 'package:decibel/features/library/presentation/notifiers/track_audio_notifier.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_audio_provider.dart';
import 'package:decibel/features/library/presentation/state/track_audio_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  late MockAudioPlayer mockPlayer;
  late StreamController<Duration> positionController;
  late StreamController<PlayerState> playerStateController;

  setUp(() {
    mockPlayer = MockAudioPlayer();
    positionController = StreamController<Duration>.broadcast();
    playerStateController = StreamController<PlayerState>.broadcast();

    // Mock streams
    when(
      () => mockPlayer.positionStream,
    ).thenAnswer((_) => positionController.stream);
    when(
      () => mockPlayer.playerStateStream,
    ).thenAnswer((_) => playerStateController.stream);

    // Mock basic properties
    when(() => mockPlayer.play()).thenAnswer((_) async {});
    when(() => mockPlayer.pause()).thenAnswer((_) async {});
    when(() => mockPlayer.stop()).thenAnswer((_) async {});
    when(() => mockPlayer.seek(any())).thenAnswer((_) async {});
    when(
      () => mockPlayer.setUrl(any()),
    ).thenAnswer((_) async => const Duration(seconds: 100));
    when(
      () => mockPlayer.setFilePath(any()),
    ).thenAnswer((_) async => const Duration(seconds: 100));
    when(() => mockPlayer.dispose()).thenAnswer((_) async {});
    when(() => mockPlayer.duration).thenReturn(const Duration(seconds: 100));

    // Inject mock factory
    TrackAudioNotifier.audioPlayerFactory = () => mockPlayer;
  });

  tearDown(() {
    TrackAudioNotifier.audioPlayerFactory = null;
    positionController.close();
    playerStateController.close();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('TrackAudioNotifier', () {
    test('initial state is default', () {
      final container = createContainer();
      final state = container.read(trackAudioProvider);
      expect(state, const TrackAudioState());
    });

    test('initializeForTrack sets up player and state', () async {
      final container = createContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      // Act
      await notifier.initializeForTrack(
        trackId: 1,
        trackUrl: 'https://example.com/track.mp3',
        duration: const Duration(seconds: 100),
        autoPlay: false,
      );

      // Assert
      final state = container.read(trackAudioProvider);
      expect(state.isPrepared, true);
      expect(state.preparedTrackId, 1);
      expect(state.preparedTrackUrl, 'https://example.com/track.mp3');
      expect(state.duration, const Duration(seconds: 100));

      verify(
        () => mockPlayer.setUrl('https://example.com/track.mp3'),
      ).called(1);
    });

    test('initializeForTrack triggers play if autoPlay is true', () async {
      final container = createContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.initializeForTrack(
        trackId: 1,
        trackUrl: 'https://example.com/track.mp3',
        autoPlay: true,
      );

      verify(() => mockPlayer.play()).called(1);
    });

    test('updates position and progress from stream', () async {
      final container = createContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      // Initialize first ensuring streams are listened to
      // We need to trigger build() which happens on read
      container.read(trackAudioProvider);

      // Initialize properly
      await notifier.initializeForTrack(
        trackId: 1,
        trackUrl: 'url',
        duration: const Duration(seconds: 100),
        autoPlay: false,
      );

      // Emit position update
      positionController.add(const Duration(seconds: 50));

      // Wait for stream event to propagate
      await Future<void>.delayed(Duration.zero);

      final state = container.read(trackAudioProvider);
      expect(state.position, const Duration(seconds: 50));
      expect(state.progress, 0.5);
    });

    test('updates isPlaying from playerState stream', () async {
      final container = createContainer();
      container.read(trackAudioProvider); // trigger build

      playerStateController.add(PlayerState(true, ProcessingState.ready));

      await Future<void>.delayed(Duration.zero);

      final state = container.read(trackAudioProvider);
      expect(state.isPlaying, true);
    });

    test('seek calls player.seek', () async {
      final container = createContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.initializeForTrack(
        trackId: 1,
        trackUrl: 'url',
        duration: const Duration(seconds: 100),
        autoPlay: false,
      );

      await notifier.seek(const Duration(seconds: 30));

      verify(() => mockPlayer.seek(const Duration(seconds: 30))).called(1);

      final state = container.read(trackAudioProvider);
      expect(state.position, const Duration(seconds: 30));
    });

    test('dispose cancels streams and disposes player', () async {
      final container = createContainer();
      container.read(trackAudioProvider); // Initialize

      container.dispose(); // Should trigger onDispose

      // Give time for async disposal
      await Future<void>.delayed(Duration.zero);

      verify(() => mockPlayer.dispose()).called(1);
    });
  });
}
