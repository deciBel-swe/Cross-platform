import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/library/presentation/notifiers/track_audio_notifier.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_audio_provider.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  late MockAudioPlayer player;
  late StreamController<Duration> positionController;
  late StreamController<PlayerState> playerStateController;
  late StreamController<Duration?> durationController;
  late StreamController<PlaybackEvent> playbackEventController;

  setUpAll(() {
    registerFallbackValue(Duration.zero);
    registerFallbackValue(
      AudioSource.uri(Uri.parse('https://example.com/audio.mp3')),
    );
  });

  setUp(() {
    player = MockAudioPlayer();

    positionController = StreamController<Duration>.broadcast();
    playerStateController = StreamController<PlayerState>.broadcast();
    durationController = StreamController<Duration?>.broadcast();
    playbackEventController = StreamController<PlaybackEvent>.broadcast();

    when(
      () => player.positionStream,
    ).thenAnswer((_) => positionController.stream);
    when(
      () => player.playerStateStream,
    ).thenAnswer((_) => playerStateController.stream);
    when(
      () => player.durationStream,
    ).thenAnswer((_) => durationController.stream);
    when(
      () => player.playbackEventStream,
    ).thenAnswer((_) => playbackEventController.stream);

    when(() => player.duration).thenReturn(null);
    when(() => player.dispose()).thenAnswer((_) async {});
    when(() => player.play()).thenAnswer((_) async {});
    when(() => player.pause()).thenAnswer((_) async {});
    when(() => player.stop()).thenAnswer((_) async {});
    when(() => player.seek(any())).thenAnswer((_) async {});
    when(() => player.setVolume(any())).thenAnswer((_) async {});
    when(
      () => player.setAudioSource(any(), preload: any(named: 'preload')),
    ).thenAnswer((_) async => const Duration(seconds: 48));

    TrackAudioNotifier.audioPlayerFactory = () => player;
  });

  tearDown(() async {
    TrackAudioNotifier.audioPlayerFactory = null;

    await positionController.close();
    await playerStateController.close();
    await durationController.close();
    await playbackEventController.close();
  });

  ProviderContainer buildContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('TrackAudioNotifier initial state', () {
    test('build creates player and returns default state', () {
      final container = buildContainer();

      final state = container.read(trackAudioProvider);

      expect(state.isPrepared, isFalse);
      expect(state.isPreparing, isFalse);
      expect(state.isPlaying, isFalse);
      expect(state.position, Duration.zero);
      expect(state.duration, Duration.zero);
      expect(state.progress, 0);
      expect(state.queue, isEmpty);
      expect(state.currentTrack, isNull);
      expect(state.preparedTrackId, isNull);
      expect(state.preparedTrackUrl, isNull);
    });
  });

  group('stream listeners', () {
    test('position stream updates position and progress', () async {
      final container = buildContainer();
      container.read(trackAudioProvider);

      durationController.add(const Duration(seconds: 100));
      await Future<void>.delayed(Duration.zero);

      positionController.add(const Duration(seconds: 25));
      await Future<void>.delayed(Duration.zero);

      final state = container.read(trackAudioProvider);

      expect(state.duration, const Duration(seconds: 100));
      expect(state.position, const Duration(seconds: 25));
      expect(state.progress, 0.25);
    });

    test('duration stream updates duration', () async {
      final container = buildContainer();
      container.read(trackAudioProvider);

      durationController.add(const Duration(seconds: 90));
      await Future<void>.delayed(Duration.zero);

      final state = container.read(trackAudioProvider);

      expect(state.duration, const Duration(seconds: 90));
    });

    test('player state stream updates isPlaying', () async {
      final container = buildContainer();
      container.read(trackAudioProvider);

      playerStateController.add(PlayerState(true, ProcessingState.ready));
      await Future<void>.delayed(Duration.zero);

      expect(container.read(trackAudioProvider).isPlaying, isTrue);

      playerStateController.add(PlayerState(false, ProcessingState.ready));
      await Future<void>.delayed(Duration.zero);

      expect(container.read(trackAudioProvider).isPlaying, isFalse);
    });

    test('position stream is ignored while dragging', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      durationController.add(const Duration(seconds: 100));
      await Future<void>.delayed(Duration.zero);

      notifier.onDragStart();

      positionController.add(const Duration(seconds: 50));
      await Future<void>.delayed(Duration.zero);

      final state = container.read(trackAudioProvider);

      expect(state.isDragging, isTrue);
      expect(state.position, Duration.zero);
    });
  });

  group('drag functions', () {
    test('onDragStart enables dragging and stores current progress', () {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      notifier.onDragStart();

      final state = container.read(trackAudioProvider);

      expect(state.isDragging, isTrue);
      expect(state.dragProgress, 0);
      expect(state.dragPosition, Duration.zero);
    });

    test('onDragUpdate clamps progress below zero', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      durationController.add(const Duration(seconds: 100));
      await Future<void>.delayed(Duration.zero);

      notifier.onDragUpdate(-5);

      final state = container.read(trackAudioProvider);

      expect(state.isDragging, isTrue);
      expect(state.dragProgress, 0);
      expect(state.dragPosition, Duration.zero);
    });

    test('onDragUpdate clamps progress above one', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      durationController.add(const Duration(seconds: 100));
      await Future<void>.delayed(Duration.zero);

      notifier.onDragUpdate(5);

      final state = container.read(trackAudioProvider);

      expect(state.isDragging, isTrue);
      expect(state.dragProgress, 1);
      expect(state.dragPosition, const Duration(seconds: 100));
    });

    test('onDragUpdate calculates drag position', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      durationController.add(const Duration(seconds: 100));
      await Future<void>.delayed(Duration.zero);

      notifier.onDragUpdate(0.4);

      final state = container.read(trackAudioProvider);

      expect(state.isDragging, isTrue);
      expect(state.dragProgress, 0.4);
      expect(state.dragPosition, const Duration(seconds: 40));
    });

    test('onDragEnd clears drag state when not prepared', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      durationController.add(const Duration(seconds: 100));
      await Future<void>.delayed(Duration.zero);

      notifier.onDragUpdate(0.5);
      await notifier.onDragEnd(0.5);

      final state = container.read(trackAudioProvider);

      expect(state.isDragging, isFalse);
      expect(state.dragProgress, isNull);
      expect(state.dragPosition, isNull);
    });
  });

  group('queue functions', () {
    test('addToQueue adds playable track', () {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      notifier.addToQueue(_track(id: 1));

      final state = container.read(trackAudioProvider);

      expect(state.queue.map((track) => track.id), [1]);
    });

    test('addToQueue does not add duplicate track', () {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final track = _track(id: 1);

      notifier.addToQueue(track);
      notifier.addToQueue(track);

      final state = container.read(trackAudioProvider);

      expect(state.queue.length, 1);
    });

    test('addToQueue ignores processing track', () {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      notifier.addToQueue(_track(id: 1, state: TrackStatus.processing));

      final state = container.read(trackAudioProvider);

      expect(state.queue, isEmpty);
    });

    test('addToQueue ignores failed track', () {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      notifier.addToQueue(_track(id: 1, state: TrackStatus.failed));

      final state = container.read(trackAudioProvider);

      expect(state.queue, isEmpty);
    });

    test('addToQueue ignores track without url', () {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      notifier.addToQueue(_track(id: 1, trackUrl: null));

      final state = container.read(trackAudioProvider);

      expect(state.queue, isEmpty);
    });

    test('removeFromQueue removes track by id', () {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      notifier.addToQueue(_track(id: 1));
      notifier.addToQueue(_track(id: 2));

      notifier.removeFromQueue(1);

      final state = container.read(trackAudioProvider);

      expect(state.queue.map((track) => track.id), [2]);
    });

    test('removeFromQueue does nothing when id is missing', () {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      notifier.addToQueue(_track(id: 1));
      notifier.removeFromQueue(99);

      final state = container.read(trackAudioProvider);

      expect(state.queue.map((track) => track.id), [1]);
    });

    test('reorderQueue moves item', () {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      notifier.addToQueue(_track(id: 1));
      notifier.addToQueue(_track(id: 2));
      notifier.addToQueue(_track(id: 3));

      notifier.reorderQueue(0, 2);

      final state = container.read(trackAudioProvider);

      expect(state.queue.map((track) => track.id), [2, 1, 3]);
    });

    test('reorderQueue ignores invalid old index', () {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      notifier.addToQueue(_track(id: 1));
      notifier.addToQueue(_track(id: 2));

      notifier.reorderQueue(-1, 1);

      final state = container.read(trackAudioProvider);

      expect(state.queue.map((track) => track.id), [1, 2]);
    });

    test('reorderQueue ignores invalid new index', () {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      notifier.addToQueue(_track(id: 1));
      notifier.addToQueue(_track(id: 2));

      notifier.reorderQueue(0, 99);

      final state = container.read(trackAudioProvider);

      expect(state.queue.map((track) => track.id), [1, 2]);
    });
  });

  group('audio guards before preparation', () {
    test('play does nothing when not prepared', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.play();

      verifyNever(() => player.play());
      expect(container.read(trackAudioProvider).isPlaying, isFalse);
    });

    test('pause does nothing when not prepared', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.pause();

      verifyNever(() => player.pause());
    });

    test('seek does nothing when not prepared', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.seek(const Duration(seconds: 10));

      verifyNever(() => player.seek(any()));
    });

    test('stop does not call player stop when not prepared', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.stop();

      verifyNever(() => player.stop());
    });
  });

  group('volume', () {
    test('setVolume calls player setVolume', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.setVolume(0.5);

      verify(() => player.setVolume(0.5)).called(1);
    });
  });

  group('playTrack and initialization', () {
    test('playTrack ignores track without url', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.playTrack(track: _track(id: 1, trackUrl: null));

      verifyNever(
        () => player.setAudioSource(any(), preload: any(named: 'preload')),
      );
    });

    test('playTrack ignores processing track', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.playTrack(
        track: _track(id: 1, state: TrackStatus.processing),
      );

      verifyNever(
        () => player.setAudioSource(any(), preload: any(named: 'preload')),
      );
    });

    test('playTrack ignores failed track', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.playTrack(track: _track(id: 1, state: TrackStatus.failed));

      verifyNever(
        () => player.setAudioSource(any(), preload: any(named: 'preload')),
      );
    });

    test('playTrack prepares playable track without autoplay', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final track = _track(id: 1);

      await expectLater(
        notifier.playTrack(track: track, queue: [track], autoPlay: false),
        completes,
      );

      verify(
        () => player.setAudioSource(any(), preload: any(named: 'preload')),
      ).called(1);

      verifyNever(() => player.play());
    });

    test('playTrack with autoplay completes for playable track', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final track = _track(id: 1);

      await expectLater(
        notifier.playTrack(track: track, queue: [track], autoPlay: true),
        completes,
      );

      verify(
        () => player.setAudioSource(any(), preload: any(named: 'preload')),
      ).called(1);
    });

    test('initializeForTrack prepares playable source', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final track = _track(id: 1);

      await expectLater(
        notifier.initializeForTrack(
          trackId: track.id,
          trackUrl: track.normalizedTrackUrl!,
          track: track,
          queue: [track],
          autoPlay: false,
        ),
        completes,
      );

      verify(
        () => player.setAudioSource(any(), preload: any(named: 'preload')),
      ).called(1);

      verifyNever(() => player.play());
    });

    test(
      'initializeForTrack with autoplay completes for playable track',
      () async {
        final container = buildContainer();
        final notifier = container.read(trackAudioProvider.notifier);

        final track = _track(id: 1);

        await expectLater(
          notifier.initializeForTrack(
            trackId: track.id,
            trackUrl: track.normalizedTrackUrl!,
            track: track,
            queue: [track],
            autoPlay: true,
          ),
          completes,
        );

        verify(
          () => player.setAudioSource(any(), preload: any(named: 'preload')),
        ).called(1);
      },
    );

    test(
      'initializeForTrack handles source failure without throwing',
      () async {
        when(
          () => player.setAudioSource(any(), preload: any(named: 'preload')),
        ).thenThrow(Exception('source failed'));

        final container = buildContainer();
        final notifier = container.read(trackAudioProvider.notifier);

        final track = _track(id: 1);

        await expectLater(
          notifier.initializeForTrack(
            trackId: track.id,
            trackUrl: track.normalizedTrackUrl!,
            track: track,
            queue: [track],
            autoPlay: false,
          ),
          completes,
        );

        final state = container.read(trackAudioProvider);

        expect(state.isPlaying, isFalse);
      },
    );
  });

  group('prepared playback functions', () {
    test('play does nothing before track is prepared', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.play();

      verifyNever(() => player.play());
    });

    test('pause does nothing before track is prepared', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.pause();

      verifyNever(() => player.pause());
    });

    test('seek does nothing before track is prepared', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.seek(const Duration(seconds: 10));

      verifyNever(() => player.seek(any()));
    });

    test('stop does nothing before track is prepared', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      await notifier.stop();

      verifyNever(() => player.stop());
    });

    test('play completes after prepare', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final track = _track(id: 1);

      await notifier.playTrack(track: track, queue: [track], autoPlay: false);

      await expectLater(notifier.play(), completes);
    });

    test('pause completes after prepare', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final track = _track(id: 1);

      await notifier.playTrack(track: track, queue: [track], autoPlay: false);

      await expectLater(notifier.pause(), completes);
    });

    test('seek completes after prepare', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final track = _track(id: 1);

      await notifier.playTrack(track: track, queue: [track], autoPlay: false);

      await expectLater(notifier.seek(const Duration(seconds: 10)), completes);
    });

    test('stop completes after prepare', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final track = _track(id: 1);

      await notifier.playTrack(track: track, queue: [track], autoPlay: false);

      await expectLater(notifier.stop(), completes);
    });
  });

  group('queue navigation', () {
    test('skipNext completes when queue has next track', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final first = _track(id: 1);
      final second = _track(id: 2);

      await notifier.playTrack(
        track: first,
        queue: [first, second],
        autoPlay: false,
      );

      await expectLater(notifier.skipNext(), completes);
    });

    test('skipNext does nothing when current track is last', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final first = _track(id: 1);
      final second = _track(id: 2);

      await notifier.playTrack(
        track: second,
        queue: [first, second],
        autoPlay: false,
      );

      clearInteractions(player);

      await notifier.skipNext();

      verifyNever(
        () => player.setAudioSource(any(), preload: any(named: 'preload')),
      );
    });

    test('skipPrevious completes when queue has previous track', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final first = _track(id: 1);
      final second = _track(id: 2);

      await notifier.playTrack(
        track: second,
        queue: [first, second],
        autoPlay: false,
      );

      await expectLater(notifier.skipPrevious(), completes);
    });

    test('skipPrevious does nothing when current track is first', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final first = _track(id: 1);
      final second = _track(id: 2);

      await notifier.playTrack(
        track: first,
        queue: [first, second],
        autoPlay: false,
      );

      clearInteractions(player);

      await notifier.skipPrevious();

      verifyNever(
        () => player.setAudioSource(any(), preload: any(named: 'preload')),
      );
    });

    test('playFromQueueIndex ignores invalid index', () async {
      final container = buildContainer();
      final notifier = container.read(trackAudioProvider.notifier);

      final first = _track(id: 1);
      final second = _track(id: 2);

      await notifier.playTrack(
        track: first,
        queue: [first, second],
        autoPlay: false,
      );

      clearInteractions(player);

      await notifier.playFromQueueIndex(99);

      verifyNever(
        () => player.setAudioSource(any(), preload: any(named: 'preload')),
      );
    });
  });
}

Track _track({
  required int id,
  String? trackUrl = 'https://example.com/audio.mp3',
  TrackStatus state = TrackStatus.finished,
}) {
  return Track(
    id: id,
    title: 'Track $id',
    artist: const Artist(
      id: 1,
      username: 'artist',
      displayName: 'Artist',
      avatarUrl: null,
    ),
    trackUrl: trackUrl,
    coverUrl: null,
    waveformUrl: null,
    genre: 'Pop',
    tags: const ['test'],
    state: state,
    releaseDate: DateTime(2026, 1, 1),
    playCount: 0,
    likeCount: 0,
    repostCount: 0,
    isLiked: false,
    isReposted: false,
    createdAt: DateTime(2026, 1, 1),
  );
}
