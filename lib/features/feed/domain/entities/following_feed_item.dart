class FollowingFeedItem {
  const FollowingFeedItem({
    required this.userName,
    required this.action,
    required this.trackTitle,
    required this.trackArtist,
    required this.timeAgo,
    required this.genre,
    required this.likes,
    required this.reposts,
    required this.plays,
    required this.comments,
    required this.duration,
    required this.waveformPeaks,
  });

  final String userName;
  final String action; // "posted" / "reposted"
  final String trackTitle;
  final String trackArtist;
  final String timeAgo;
  final String genre;
  final String likes;
  final String reposts;
  final String plays;
  final String comments;
  final String duration;
  final List<double> waveformPeaks;
}