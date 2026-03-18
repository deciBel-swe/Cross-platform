import 'package:flutter/material.dart';

import '../waveform_painter.dart';

class TrackWaveformCanvas extends StatelessWidget {
  const TrackWaveformCanvas({
    super.key,
    required this.peaks,
    required this.progress,
  });

  final List<double> peaks;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveformPainter(
        peaks: peaks,
        progress: progress,
        playedColor: Theme.of(context).colorScheme.primary,
        unplayedColor: Theme.of(context).colorScheme.outlineVariant,
        centerLineColor: Theme.of(context).dividerColor.withValues(alpha: 0.2),
      ),
    );
  }
}
