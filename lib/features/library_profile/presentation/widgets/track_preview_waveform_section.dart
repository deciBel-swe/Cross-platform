import 'package:flutter/material.dart';

import 'track_waveform/track_waveform_canvas.dart';
import 'track_waveform/track_waveform_center_markers.dart';
import 'track_waveform/track_waveform_time_bubble.dart';

/// Widget to display the track waveform.
/// Shows:
/// - mirrored waveform
/// - center time bubble
/// - thin center line
class TrackWaveform extends StatelessWidget {
  const TrackWaveform({
    super.key,
    required this.peaks,
    required this.playedPosition,
    required this.totalDuration,
    this.dragPosition,
    this.height = 96,
  });

  final List<double> peaks;
  final Duration playedPosition;
  final Duration totalDuration;
  final Duration? dragPosition;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (peaks.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text(
            'No waveform data',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final totalMs = totalDuration.inMilliseconds;
    final playedMs = playedPosition.inMilliseconds;
    final dragMs = dragPosition?.inMilliseconds;

    final playedProgress = totalMs == 0
        ? 0.0
        : (playedMs / totalMs).clamp(0.0, 1.0);
    final dragProgress = dragMs == null
        ? null
        : (totalMs == 0 ? 0.0 : (dragMs / totalMs).clamp(0.0, 1.0));

    final displayPosition = dragPosition ?? playedPosition;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: TrackWaveformCanvas(
              peaks: peaks,
              progress: playedProgress,
              dragProgress: dragProgress,
            ),
          ),

          const TrackWaveformCenterMarkers(),

          Positioned(
            bottom: 34,
            child: TrackWaveformTimeBubble(
              currentPosition: displayPosition,
              totalDuration: totalDuration,
            ),
          ),
        ],
      ),
    );
  }
}
