import 'package:flutter/material.dart';

import '../waveform_painter.dart';

class TrackWaveformCanvas extends StatelessWidget {
  const TrackWaveformCanvas({
    super.key,
    required this.peaks,
    required this.progress,
    this.dragProgress,
  });

  final List<double> peaks;
  final double progress;
  final double? dragProgress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveformPainter(
        peaks: peaks,
        progress: progress,
        dragProgress: dragProgress,
        playedColor: Theme.of(context).colorScheme.primary,
        dragColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.15),
        unplayedColor: Theme.of(context).colorScheme.outlineVariant,
        centerLineColor: Theme.of(context).dividerColor.withValues(alpha: 0.2),
      ),
    );
  }
}
