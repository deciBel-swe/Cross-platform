class TrackPeaks {
  const TrackPeaks({
    required this.trackId,
    required this.duration,
    required this.peaks,
  });

  final int trackId;
  final int duration;
  final List<int> peaks;
}
