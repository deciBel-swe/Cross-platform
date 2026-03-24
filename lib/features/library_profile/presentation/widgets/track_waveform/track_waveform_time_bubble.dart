import 'package:flutter/material.dart';

class TrackWaveformTimeBubble extends StatelessWidget {
  const TrackWaveformTimeBubble({
    super.key,
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
