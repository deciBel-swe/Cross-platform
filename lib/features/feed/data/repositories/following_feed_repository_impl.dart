import 'package:injectable/injectable.dart';

import '../../domain/entities/following_feed_item.dart';
import '../../domain/repositories/following_feed_repository.dart';
import '../datasources/following_feed_remote_datasource.dart';

@LazySingleton(as: FollowingFeedRepository)
class FollowingFeedRepositoryImpl implements FollowingFeedRepository {
  FollowingFeedRepositoryImpl(this._remoteDatasource);

  final FollowingFeedRemoteDatasource _remoteDatasource;

  @override
  Future<List<FollowingFeedItem>> getFollowingFeed({
    int page = 0,
    int size = 20,
  }) async {
    final data = await _remoteDatasource.getFollowingFeed(
      page: page,
      size: size,
    );

    final List<dynamic> content =
        (data['content'] as List<dynamic>?) ?? <dynamic>[];

    return content.map((item) {
      final Map<String, dynamic> json = item as Map<String, dynamic>;
      final Map<String, dynamic> artist =
          (json['artist'] as Map<String, dynamic>?) ?? <String, dynamic>{};

      final String userName =
          (artist['username'] ?? 'Unknown User').toString();

      final String trackTitle =
          (json['title'] ?? 'Untitled Track').toString();

      final String trackArtist = userName;

      final String genre =
          (json['genre'] ?? 'Unknown').toString();

      final int playCount = (json['playCount'] as int?) ?? 0;
      final int likeCount = (json['likeCount'] as int?) ?? 0;
      final int repostCount = (json['repostCount'] as int?) ?? 0;

      final String uploadDate =
          (json['uploadDate'] ?? '').toString();

      return FollowingFeedItem(
        userName: userName,
        action: 'posted a track',
        trackTitle: trackTitle,
        trackArtist: trackArtist,
        timeAgo: _timeAgoFromUploadDate(uploadDate),
        genre: genre,
        likes: likeCount.toString(),
        reposts: repostCount.toString(),
        plays: playCount.toString(),
        comments: '0',
        duration: '0:00',
        waveformPeaks: _buildMockPeaks(
          seed: '$userName$trackTitle'.hashCode,
        ),
      );
    }).toList();
  }
}

String _timeAgoFromUploadDate(String uploadDate) {
  if (uploadDate.isEmpty) {
    return 'Recently';
  }

  final DateTime? parsed = DateTime.tryParse(uploadDate);
  if (parsed == null) {
    return 'Recently';
  }

  final Duration diff = DateTime.now().difference(parsed);

  if (diff.inMinutes < 1) {
    return 'Just now';
  }
  if (diff.inHours < 1) {
    return '${diff.inMinutes} min ago';
  }
  if (diff.inDays < 1) {
    return '${diff.inHours} hours ago';
  }
  if (diff.inDays < 30) {
    return '${diff.inDays} days ago';
  }
  if (diff.inDays < 365) {
    return '${(diff.inDays / 30).floor()} months ago';
  }

  return '${(diff.inDays / 365).floor()} years ago';
}

List<double> _buildMockPeaks({required int seed, int count = 120}) {
  final baseSeed = seed.abs() + 17;

  return List<double>.generate(count, (index) {
    final rawValue = ((baseSeed + (index * 37)) % 100) / 100;
    final folded = rawValue <= 0.5 ? rawValue : (1 - rawValue);
    return (folded * 1.8).clamp(0.06, 1.0);
  });
}