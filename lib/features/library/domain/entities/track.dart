import 'artist.dart';
import 'track_status.dart';

class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    this.trackUrl,
    this.coverUrl,
    this.waveformUrl,
    required this.genre,
    required this.tags,
    required this.state,
    required this.releaseDate,
    required this.playCount,
    required this.likeCount,
    required this.repostCount,
    required this.isLiked,
    required this.isReposted,
    required this.createdAt,
  });

  final int id;
  final String title;
  final Artist artist;
  final String? trackUrl;
  final String? coverUrl;
  final String? waveformUrl;
  final String genre;
  final List<String> tags;
  final TrackStatus state;
  final DateTime releaseDate;
  final int playCount;
  final int likeCount;
  final int repostCount;
  final bool isLiked;
  final bool isReposted;
  final DateTime createdAt;
}
