import 'package:flutter/widgets.dart';

import '../../../library_profile/presentation/widgets/track_preview_waveform_section.dart';
import '../notifiers/track_audio_notifier.dart';
import '../state/track_audio_state.dart';

class InteractiveWaveform extends StatelessWidget {
  const InteractiveWaveform({
    required this.peaks,
    required this.audioState,
    required this.audioNotifier,
  });

  final List<double> peaks;
  final TrackAudioState audioState;
  final TrackAudioNotifier audioNotifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Builder(
        builder: (context) {
          final waveformWidth = MediaQuery.of(context).size.width - 16.0;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (_) => audioNotifier.onDragStart(),
            onHorizontalDragUpdate: (details) {
              final progress = (details.localPosition.dx / waveformWidth).clamp(
                0.0,
                1.0,
              );
              audioNotifier.onDragUpdate(progress);
            },
            onHorizontalDragEnd: (_) async {
              await audioNotifier.onDragEnd(
                audioState.dragProgress ?? audioState.progress,
              );
            },
            child: TrackWaveform(
              peaks: peaks,
              playedPosition: audioState.position,
              totalDuration: audioState.duration,
              dragPosition: audioState.dragPosition,
              height: 140,
            ),
          );
        },
      ),
    );
  }
}
