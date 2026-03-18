import 'package:flutter/material.dart';

/// Custom painter to draw the track waveform.
class WaveformPainter extends CustomPainter {
  final List<double> peaks;
  final double progress;

  WaveformPainter({required this.peaks, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paintPlayed = Paint()..color = Colors.orange;
    final paintUnplayed = Paint()..color = Colors.grey;

    final barWidth = size.width / peaks.length;

    final playedBars = (peaks.length * progress).floor();

    for (int i = 0; i < peaks.length; i++) {
      final barHeight = peaks[i] * size.height;

      final x = i * barWidth;
      final y = (size.height - barHeight) / 2;

      final rect = Rect.fromLTWH(x, y, barWidth * 0.8, barHeight);

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        i < playedBars ? paintPlayed : paintUnplayed,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.peaks != peaks;
  }
}
