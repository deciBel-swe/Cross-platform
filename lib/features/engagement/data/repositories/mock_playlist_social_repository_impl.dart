import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../playlists/domain/entities/playlist.dart';
import '../../domain/repositories/playlist_social_repository.dart';

@Environment('mock')
@LazySingleton(as: IPlaylistSocialRepository)
class MockPlaylistSocialRepositoryImpl implements IPlaylistSocialRepository {
  final Map<int, bool> _likedState = {};

  @override
  Future<Either<Failure, bool>> toggleLike(
    int playlistId,
    bool isCurrentlyLiked,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _likedState[playlistId] = !isCurrentlyLiked;
    return Right(!isCurrentlyLiked);
  }

  @override
  Future<Either<Failure, List<Playlist>>> getLikedPlaylists(
    String username, {
    int page = 0,
    int size = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const Right([]);
  }
}
