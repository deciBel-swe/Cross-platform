import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/track_audio_notifier.dart';
import '../state/track_audio_state.dart';

final trackAudioProvider =
    NotifierProvider<TrackAudioNotifier, TrackAudioState>(
      TrackAudioNotifier.new,
    );
