import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/presentation/notifiers/track_audio_notifier.dart';
import '../../../library/presentation/state/track_audio_state.dart';

final trackAudioProvider =
    NotifierProvider<TrackAudioNotifier, TrackAudioState>(
      TrackAudioNotifier.new,
    );
