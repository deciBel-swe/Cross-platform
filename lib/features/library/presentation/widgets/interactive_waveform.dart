import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../library_profile/presentation/widgets/track_preview_waveform_section.dart';
import '../notifiers/track_audio_notifier.dart';
import '../state/track_audio_state.dart';

class InteractiveWaveform extends StatefulWidget {
  const InteractiveWaveform({
    super.key,
    required this.peaks,
    required this.audioState,
    required this.audioNotifier,
  });

  final List<double> peaks;
  final TrackAudioState audioState;
  final TrackAudioNotifier audioNotifier;

  /// Builds a draggable waveform bound to the audio notifier.
  @override
  State<InteractiveWaveform> createState() => _InteractiveWaveformState();
}

class _InteractiveWaveformState extends State<InteractiveWaveform> {
  int? _lastHapticPeakIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Builder(
        builder: (context) {
          final waveformWidth = MediaQuery.of(context).size.width - 16.0;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (_) {
              widget.audioNotifier.onDragStart();
              _lastHapticPeakIndex = null;
            },
            onHorizontalDragUpdate: (details) {
              final progress = (details.localPosition.dx / waveformWidth).clamp(
                0.0,
                1.0,
              );
              widget.audioNotifier.onDragUpdate(progress);

              if (widget.peaks.isNotEmpty) {
                final currentPeakIndex = (progress * widget.peaks.length)
                    .floor()
                    .clamp(0, widget.peaks.length - 1);

                if (_lastHapticPeakIndex != currentPeakIndex) {
                  _lastHapticPeakIndex = currentPeakIndex;
                  if (!ResponsiveUtils.isDesktop(context)) {
                    HapticFeedback.selectionClick();
                  }
                }
              }
            },
            onHorizontalDragEnd: (_) async {
              await widget.audioNotifier.onDragEnd(
                widget.audioState.dragProgress ?? widget.audioState.progress,
              );
              _lastHapticPeakIndex = null;
            },
            child: TrackWaveform(
              peaks: widget.peaks,
              playedPosition: widget.audioState.position,
              totalDuration: widget.audioState.duration,
              dragPosition: widget.audioState.dragPosition,
              height: 140,
            ),
          );
        },
      ),
    );
  }
}
