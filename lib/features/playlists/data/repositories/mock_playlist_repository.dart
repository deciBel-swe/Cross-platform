import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/artist.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_status.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/playlist_metadata.dart';
import '../../domain/repositories/i_playlist_repository.dart';

// Mock artists
const _artist1 = Artist(id: 1, username: 'Yasser Al-Dosary');
const _artist2 = Artist(id: 2, username: 'Mohammed Sediek Al-Menshawy');
const _artist3 = Artist(id: 3, username: 'Al-Hosary');

// Mock Tracks to populate the playlists
final List<Track> _mockTracks = [
  Track(
    id: 101,
    title: 'Taha',
    artist: _artist1,
    trackUrl: 'https://Taha.mp3',
    coverUrl: '',
    waveformUrl: '',
    genre: "Qur'an",
    tags: [],
    state: TrackStatus.finished,
    releaseDate: DateTime(2020, 4, 24),
    playCount: 15420,
    likeCount: 342,
    repostCount: 56,
    isLiked: false,
    isReposted: false,
    createdAt: DateTime(2020, 4, 20),
  ),
  Track(
    id: 102,
    title: 'Mariam',
    artist: _artist2,
    trackUrl: 'https://Taha.mp3',
    coverUrl: '',
    waveformUrl: '',
    genre: "Qur'an",
    tags: [],
    state: TrackStatus.finished,
    releaseDate: DateTime(2024, 1, 15),
    playCount: 89000,
    likeCount: 4500,
    repostCount: 890,
    isLiked: true,
    isReposted: false,
    createdAt: DateTime(2024, 1, 10),
  ),
  Track(
    id: 103,
    title: 'Al-Kahf',
    artist: _artist3,
    trackUrl: 'https://Taha.mp3',
    coverUrl: '',
    waveformUrl: '',
    genre: "Qur'an",
    tags: [],
    state: TrackStatus.finished,
    releaseDate: DateTime(2023, 11, 20),
    playCount: 230500,
    likeCount: 12400,
    repostCount: 3100,
    isLiked: false,
    isReposted: true,
    createdAt: DateTime(2023, 11, 18),
  ),
];
// A local list to simulate a database
final List<Playlist> _mockPlaylists = [
  const Playlist(
    id: 1,
    title: "Electronic Focus",
    description: 'This is a Playlist',
    type: "PLAYLIST",
    isPrivate: false,
    isLiked: true,
    owner: PlaylistOwner(id: 101, username: "Ahmed Abd Al-Jaleel"),
    tracks: [],
  ),
  Playlist(
    id: 2,
    title: "Qur'an",
    description: '',
    type: "PLAYLIST",
    isPrivate: true,
    isLiked: false,
    owner: const PlaylistOwner(id: 101, username: "Ahmed Abd Al-Jaleel"),
    tracks: _mockTracks,
  ),
];

class MockPlaylistRepository implements IPlaylistRepository {
  @override
  Future<Either<Failure, List<Playlist>>> getUserPlaylists({
    int page = 0,
    int size = 20,
  }) async {
    return Right(_mockPlaylists);
  }

  @override
  Future<Either<Failure, Playlist>> createPlaylist(
    PlaylistMetadata metadata,
  ) async {
    final uniqueId = DateTime.now().millisecondsSinceEpoch;

    final newPlaylist = Playlist(
      id: uniqueId,
      title: metadata.title,
      type: "PLAYLIST",
      isPrivate: metadata.isPrivate,
      coverArt: metadata.coverImage?.path,
      isLiked: false,
      owner: const PlaylistOwner(id: 101, username: "Ahmed Abd Al-Jaleel"),
      tracks: [],
    );
    _mockPlaylists.add(newPlaylist);
    return Right(newPlaylist);
  }

  @override
  Future<Either<Failure, void>> deletePlaylist(int playlistId) async {
    _mockPlaylists.removeWhere((p) => p.id == playlistId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, Playlist>> getPlaylistDetails(int playlistId) async {
    final playlist = _mockPlaylists.firstWhere((p) => p.id == playlistId);
    return Right(playlist);
  }

  @override
  Future<Either<Failure, Playlist>> updatePlaylist(
    int playlistId,
    PlaylistMetadata metadata,
  ) async {
    final index = _mockPlaylists.indexWhere((p) => p.id == playlistId);

    if (index == -1) {
      return const Left(ServerFailure("Playlist not found"));
    }

    final existingPlaylist = _mockPlaylists[index];

    final updatedPlaylist = Playlist(
      id: existingPlaylist.id,
      title: metadata.title.isNotEmpty
          ? metadata.title
          : existingPlaylist.title,
      description: metadata.description,
      type: existingPlaylist.type,
      isPrivate: metadata.isPrivate,
      coverArt: metadata.coverImage?.path ?? existingPlaylist.coverArt,
      isLiked: existingPlaylist.isLiked,
      owner: existingPlaylist.owner,
      tracks: existingPlaylist.tracks,
    );

    _mockPlaylists[index] = updatedPlaylist;

    return Right(updatedPlaylist);
  }

  @override
  Future<Either<Failure, Playlist>> reorderTracks(
    int playlistId,
    List<int> trackIds,
  ) async {
    final index = _mockPlaylists.indexWhere((p) => p.id == playlistId);
    if (index == -1) {
      return const Left(ServerFailure("Playlist not found"));
    }

    final playlist = _mockPlaylists[index];

    // Create a new list of tracks based on the order of the IDs provided
    final reorderedTracks = <Track>[];

    try {
      for (final id in trackIds) {
        // Find the track in the existing playlist that matches the ID
        final track = playlist.tracks.firstWhere((t) => t.id == id);
        reorderedTracks.add(track);
      }
    } catch (e) {
      return const Left(
        ServerFailure("One or more tracks not found in playlist."),
      );
    }

    final updatedPlaylist = Playlist(
      id: playlist.id,
      title: playlist.title,
      description: playlist.description,
      type: playlist.type,
      isPrivate: playlist.isPrivate,
      coverArt: playlist.coverArt,
      isLiked: playlist.isLiked,
      owner: playlist.owner,
      tracks: reorderedTracks,
    );

    _mockPlaylists[index] = updatedPlaylist;

    return Right(updatedPlaylist);
  }

  @override
  Future<Either<Failure, String>> getPlaylistSecretLink(int playlistId) async {
    return Right("https://deciebl.app/secret-link/$playlistId");
  }

  @override
  Future<Either<Failure, void>> addTrackToPlaylist(
    int playlistId,
    int trackId,
  ) async {
    final index = _mockPlaylists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return const Left(ServerFailure("Playlist not found"));

    try {
      final track = _mockTracks.firstWhere((t) => t.id == trackId);
      final playlist = _mockPlaylists[index];
      // Prevent duplicates in mock
      if (!playlist.tracks.any((t) => t.id == trackId)) {
        playlist.tracks.add(track);
      }
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure("Track not found in mock data"));
    }
  }

  @override
  Future<Either<Failure, void>> removeTrackFromPlaylist(
    int playlistId,
    int trackId,
  ) async {
    final index = _mockPlaylists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return const Left(ServerFailure("Playlist not found"));

    _mockPlaylists[index].tracks.removeWhere((t) => t.id == trackId);
    return const Right(null);
  }
}
