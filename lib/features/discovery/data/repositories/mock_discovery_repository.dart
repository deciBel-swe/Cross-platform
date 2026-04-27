import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/discovery_playlist.dart';
import '../../domain/entities/discovery_search_response.dart';
import '../../domain/entities/discovery_search_type.dart';
import '../../domain/entities/discovery_track.dart';
import '../../domain/entities/discovery_user.dart';
import '../../domain/entities/paginated_discovery_tracks.dart';
import '../../domain/repositories/discovery_repository.dart';

@LazySingleton(as: DiscoveryRepository, env: ['mock'])
class MockDiscoveryRepository implements DiscoveryRepository {
  const MockDiscoveryRepository();

  @override
  Future<Either<Failure, DiscoverySearchResponse>> search({
    required String query,
    required DiscoverySearchType type,
    required int page,
    required int size,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();

    final users = _mockUsers
        .where(
          (DiscoveryUser user) =>
              user.username.toLowerCase().contains(normalizedQuery) ||
              (user.displayName?.toLowerCase().contains(normalizedQuery) ??
                  false),
        )
        .toList(growable: false);

    final tracks = _mockTracks
        .where(
          (DiscoveryTrack track) =>
              track.title.toLowerCase().contains(normalizedQuery) ||
              track.artist.username.toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false);

    final playlists = _mockPlaylists
        .where(
          (DiscoveryPlaylist playlist) =>
              playlist.title.toLowerCase().contains(normalizedQuery) ||
              playlist.owner.username.toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false);

    return Right(
      DiscoverySearchResponse(
        users: type == DiscoverySearchType.tracks ||
                type == DiscoverySearchType.playlists
            ? const <DiscoveryUser>[]
            : users,
        tracks: type == DiscoverySearchType.users ||
                type == DiscoverySearchType.playlists
            ? const <DiscoveryTrack>[]
            : tracks,
        playlists: type == DiscoverySearchType.users ||
                type == DiscoverySearchType.tracks
            ? const <DiscoveryPlaylist>[]
            : playlists,
        pageNumber: page,
        pageSize: size,
        totalElements: users.length + tracks.length + playlists.length,
        totalPages: 1,
        isLast: true,
      ),
    );
  }

  @override
  Future<Either<Failure, PaginatedDiscoveryTracks>> getTrendingTracks({
    required int page,
    required int size,
  }) async {
    final filteredTracks = _mockTracks.skip(page * size).take(size).toList();
    return Right(
      PaginatedDiscoveryTracks(
        content: filteredTracks,
        pageNumber: page,
        pageSize: filteredTracks.length,
        totalElements: _mockTracks.length,
        totalPages: 1,
        isLast: true,
      ),
    );
  }

  @override
  Future<Either<Failure, PaginatedDiscoveryTracks>> getGenreStation({
    required int page,
    required int size,
  }) async {
    final filteredTracks = _mockTracks.reversed
        .skip(page * size)
        .take(size)
        .toList(growable: false);
    return Right(
      PaginatedDiscoveryTracks(
        content: filteredTracks,
        pageNumber: page,
        pageSize: filteredTracks.length,
        totalElements: filteredTracks.length,
        totalPages: 1,
        isLast: true,
      ),
    );
  }

  @override
  Future<Either<Failure, PaginatedDiscoveryTracks>> getArtistStation({
    required int page,
    required int size,
  }) async {
    final tracks = _mockTracks
        .where((DiscoveryTrack track) => track.artist.id == 1)
        .skip(page * size)
        .take(size)
        .toList(growable: false);
    final content = tracks.isEmpty
        ? _mockTracks.take(size).toList(growable: false)
        : tracks;
    return Right(
      PaginatedDiscoveryTracks(
        content: content,
        pageNumber: page,
        pageSize: content.length,
        totalElements: _mockTracks.length,
        totalPages: 1,
        isLast: true,
      ),
    );
  }

  @override
  Future<Either<Failure, PaginatedDiscoveryTracks>> getLikesStation() async {
    return Right(
      PaginatedDiscoveryTracks(
        content: _mockTracks.take(6).toList(growable: false),
        pageNumber: 0,
        pageSize: 6,
        totalElements: 6,
        totalPages: 1,
        isLast: true,
      ),
    );
  }
}

const List<DiscoveryUser> _mockUsers = <DiscoveryUser>[
  DiscoveryUser(
    id: 1,
    username: 'nightdrive',
    displayName: 'Night Drive',
    followerCount: 12800,
    trackCount: 42,
  ),
  DiscoveryUser(
    id: 2,
    username: 'sunsetloops',
    displayName: 'Sunset Loops',
    followerCount: 8600,
    trackCount: 31,
  ),
  DiscoveryUser(
    id: 3,
    username: 'basementfm',
    displayName: 'Basement FM',
    followerCount: 23100,
    trackCount: 58,
  ),
];

const List<DiscoveryTrack> _mockTracks = <DiscoveryTrack>[
  DiscoveryTrack(
    id: 101,
    title: 'Orange Skyline',
    artist: DiscoveryUser(id: 1, username: 'nightdrive'),
    genre: 'Electronic',
    playCount: 185000,
    likeCount: 9200,
    repostCount: 420,
    commentCount: 118,
  ),
  DiscoveryTrack(
    id: 102,
    title: 'South Side Signal',
    artist: DiscoveryUser(id: 3, username: 'basementfm'),
    genre: 'Hip-Hop',
    playCount: 301000,
    likeCount: 12400,
    repostCount: 702,
    commentCount: 215,
  ),
  DiscoveryTrack(
    id: 103,
    title: 'Afterhours Motel',
    artist: DiscoveryUser(id: 2, username: 'sunsetloops'),
    genre: 'Ambient',
    playCount: 99000,
    likeCount: 6100,
    repostCount: 188,
    commentCount: 74,
  ),
  DiscoveryTrack(
    id: 104,
    title: 'Concrete Romance',
    artist: DiscoveryUser(id: 1, username: 'nightdrive'),
    genre: 'Pop',
    playCount: 412000,
    likeCount: 18100,
    repostCount: 931,
    commentCount: 302,
  ),
  DiscoveryTrack(
    id: 105,
    title: 'Loose Change Drums',
    artist: DiscoveryUser(id: 3, username: 'basementfm'),
    genre: 'Hip-Hop',
    playCount: 267000,
    likeCount: 11300,
    repostCount: 540,
    commentCount: 141,
  ),
  DiscoveryTrack(
    id: 106,
    title: 'Glasswave',
    artist: DiscoveryUser(id: 2, username: 'sunsetloops'),
    genre: 'Electronic',
    playCount: 148000,
    likeCount: 7900,
    repostCount: 301,
    commentCount: 92,
  ),
];

const List<DiscoveryPlaylist> _mockPlaylists = <DiscoveryPlaylist>[
  DiscoveryPlaylist(
    id: 401,
    title: 'Late Night Rotation',
    owner: DiscoveryUser(id: 1, username: 'nightdrive'),
    trackCount: 18,
  ),
  DiscoveryPlaylist(
    id: 402,
    title: 'Warehouse Picks',
    owner: DiscoveryUser(id: 3, username: 'basementfm'),
    trackCount: 24,
  ),
];
