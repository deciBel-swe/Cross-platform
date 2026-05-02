import 'dart:async';
import 'package:decibel/features/engagement/presentation/notifiers/liked_tracks_notifier.dart';
import 'package:decibel/features/engagement/presentation/notifiers/liked_tracks_scroll_controller_provider.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackCollectionNotifier extends AutoDisposeFamilyAsyncNotifier<List<Track>, TrackCollectionType>
    with Mock
    implements TrackCollectionNotifier {
  @override
  FutureOr<List<Track>> build(TrackCollectionType arg) => [];
}

void main() {
  group('likedTracksScrollControllerProvider', () {
    test('disposes controller when provider is disposed', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(likedTracksScrollControllerProvider);
      
      container.dispose();
      
      expect(() => controller.addListener(() {}), throwsFlutterError);
    });
  });
}
