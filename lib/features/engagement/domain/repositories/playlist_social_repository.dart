import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../playlists/domain/entities/playlist.dart';

abstract class IPlaylistSocialRepository {
  Future<Either<Failure, bool>> toggleLike(int playlistId, bool isCurrentlyLiked);

  /// Fetches liked playlists for a specific user.
  Future<Either<Failure, List<Playlist>>> getLikedPlaylists(
    String username, {
    int page = 0,
    int size = 20,
  });
}
