import 'package:flutter/material.dart';

import 'waveform_painter.dart';

/// Widget to display the track waveform.
/// Shows:
/// - mirrored waveform
/// - center time bubble
/// - thin center line
class TrackWaveform extends StatelessWidget {
  const TrackWaveform({
    super.key,
    required this.peaks,
    required this.currentPosition,
    required this.totalDuration,
    this.height = 96,
  });

  final List<double> peaks;
  final Duration currentPosition;
  final Duration totalDuration;
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
    final currentMs = currentPosition.inMilliseconds;

    final progress = totalMs == 0 ? 0.0 : (currentMs / totalMs).clamp(0.0, 1.0);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: WaveformPainter(peaks: peaks, progress: progress),
            ),
          ),

          const _CenterProgressLine(),

          const Positioned.fill(
            child: IgnorePointer(child: _CenterGuideLine()),
          ),

          Positioned(
            bottom: 34,
            child: _TimeBubble(
              currentPosition: currentPosition,
              totalDuration: totalDuration,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterProgressLine extends StatelessWidget {
  const _CenterProgressLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _CenterGuideLine extends StatelessWidget {
  const _CenterGuideLine();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1.4,
        margin: const EdgeInsets.symmetric(vertical: 18),
        color: Colors.black.withValues(alpha: 0.5),
      ),
    );
  }
}

class _TimeBubble extends StatelessWidget {
  const _TimeBubble({
    required this.currentPosition,
    required this.totalDuration,
  });

  final Duration currentPosition;
  final Duration totalDuration;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          '${_formatDuration(currentPosition)}  |  ${_formatDuration(totalDuration)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
