import 'package:flutter/material.dart';

import 'waveform_painter.dart';

/// Widget to display the track waveform.
class TrackWaveform extends StatelessWidget {
  final List<double> peaks;
  final Duration currentPosition;
  final Duration totalDuration;
  final double height;

  const TrackWaveform({
    super.key,
    required this.peaks,
    required this.currentPosition,
    required this.totalDuration,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    if (peaks.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('No waveform data')),
      );
    }

    final totalMs = totalDuration.inMilliseconds;
    final currentMs = currentPosition.inMilliseconds;

    final progress = totalMs == 0 ? 0.0 : (currentMs / totalMs).clamp(0.0, 1.0);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: WaveformPainter(peaks: peaks, progress: progress),
      ),
    );
  }
}
