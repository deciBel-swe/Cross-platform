import 'package:decibel/features/library/presentation/notifiers/track_audio_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/track_audio_state.dart';

final trackAudioProvider =
    NotifierProvider<TrackAudioNotifier, TrackAudioState>(
      TrackAudioNotifier.new,
    );
