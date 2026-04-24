import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/playlist_metadata.dart';
import '../../domain/repositories/i_playlist_repository.dart';

/// The Tab will update this, and the AppBar Save button will read it

/// Provider that manages the list of user playlists and handles state updates.
final userPlaylistsProvider =
    AsyncNotifierProvider.autoDispose<UserPlaylistsNotifier, List<Playlist>>(
      UserPlaylistsNotifier.new,
    );

final playlistRepositoryProvider = Provider<IPlaylistRepository>((ref) {
  return getIt<IPlaylistRepository>();
});

class UserPlaylistsNotifier extends AutoDisposeAsyncNotifier<List<Playlist>> {
  // Helper to easily get the repository.
  //final repository = getIt<IPlaylistRepository>();
  IPlaylistRepository get _repository => ref.read(playlistRepositoryProvider);

  @override
  FutureOr<List<Playlist>> build() async {
    // Fetch initial data
    final result = await _repository.getUserPlaylists(page: 0, size: 20);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (playlists) => playlists,
    );
  }

  /// Adds a [track] into the matching playlist locally (mock, client-only).
  /// Prevents duplicates and updates UI immediately without contacting backend.
  void addTrackLocally(int playlistId, Track track) {
    if (state.value == null) return;
    final updatedList = state.value!.map((p) {
      if (p.id == playlistId) {
        // avoid duplicates
        final already = p.tracks.any((t) => t.id == track.id);
        final newTracks = List<Track>.from(p.tracks);
        if (!already) newTracks.add(track);
        return Playlist(
          id: p.id,
          title: p.title,
          description: p.description,
          type: p.type,
          isPrivate: p.isPrivate,
          isLiked: p.isLiked,
          coverArt: p.coverArt,
          owner: p.owner,
          tracks: newTracks,
          totalDurationSeconds: p.totalDurationSeconds,
          trackCount: p.trackCount,
          playlistSlug: p.playlistSlug,
          firstTrackWaveformUrl: p.firstTrackWaveformUrl,
          secretToken: p.secretToken,
          access: p.access,
          createdAt: p.createdAt,
        );
      }
      return p;
    }).toList();

    state = AsyncData(updatedList);
  }

  /// Deletes a playlist and instantly updates the UI if the backend call succeeds.
  Future<Either<Failure, void>> deletePlaylist(int playlistId) async {
    final result = await _repository.deletePlaylist(playlistId);

    return result.fold((failure) => Left(failure), (_) {
      //  Remove it from the local state
      if (state.value != null) {
        final updatedList = state.value!
            .where((p) => p.id != playlistId)
            .toList();
        state = AsyncData(updatedList);
      }
      return const Right(null);
    });
  }

  /// Toggles privacy status and instantly updates the UI if the backend call succeeds
  Future<Either<Failure, Playlist>> togglePrivacy(Playlist playlist) async {
    final newPrivacyState = !playlist.isPrivate;

    // Create the metadata object your repository expects
    final metadataToUpdate = PlaylistMetadata(
      title: playlist.title,
      description: playlist.description ?? '',
      isPrivate: newPrivacyState,
    );

    final result = await _repository.updatePlaylist(
      playlist.id,
      metadataToUpdate,
    );

    return result.fold((failure) => Left(failure), (updatedPlaylist) {
      // Swap out the old playlist for the new one
      if (state.value != null) {
        final updatedList = state.value!.map((p) {
          return p.id == updatedPlaylist.id ? updatedPlaylist : p;
        }).toList();
        state = AsyncData(updatedList);
      }
      return Right(updatedPlaylist);
    });
  }

  /// Optimistically removes tracks from the list view count
  void removeTracksLocally(int playlistId, List<int> trackIdsToRemove) {
    if (state.value != null) {
      final updatedList = state.value!.map((p) {
        if (p.id == playlistId) {
          final newTracks = p.tracks
              .where((t) => !trackIdsToRemove.contains(t.id))
              .toList();
          return Playlist(
            id: p.id,
            title: p.title,
            description: p.description,
            type: p.type,
            isPrivate: p.isPrivate,
            isLiked: p.isLiked,
            coverArt: p.coverArt,
            owner: p.owner,
            tracks: newTracks,
            totalDurationSeconds: p.totalDurationSeconds,
            trackCount: p.trackCount,
            playlistSlug: p.playlistSlug,
            firstTrackWaveformUrl: p.firstTrackWaveformUrl,
            secretToken: p.secretToken,
            access: p.access,
            createdAt: p.createdAt,
          );
        }
        return p;
      }).toList();
      state = AsyncData(updatedList);
    }
  }

  /// Restores tracks to the list view count if the user hits "Undo"
  void restoreTracksLocally(int playlistId, List<Track> restoredTracks) {
    if (state.value != null) {
      final updatedList = state.value!.map((p) {
        if (p.id == playlistId) {
          final newTracks = List<Track>.from(p.tracks)..addAll(restoredTracks);
          return Playlist(
            id: p.id,
            title: p.title,
            description: p.description,
            type: p.type,
            isPrivate: p.isPrivate,
            isLiked: p.isLiked,
            coverArt: p.coverArt,
            owner: p.owner,
            tracks: newTracks,
            totalDurationSeconds: p.totalDurationSeconds,
            trackCount: p.trackCount,
            playlistSlug: p.playlistSlug,
            firstTrackWaveformUrl: p.firstTrackWaveformUrl,
            secretToken: p.secretToken,
            access: p.access,
            createdAt: p.createdAt,
          );
        }
        return p;
      }).toList();
      state = AsyncData(updatedList);
    }
  }

  /// Updates metadata (title/privacy) while preserving any local track deletions
  void updatePlaylistMetadataLocally(Playlist updatedPlaylist) {
    if (state.value != null) {
      final updatedList = state.value!.map((p) {
        if (p.id == updatedPlaylist.id) {
          return Playlist(
            id: updatedPlaylist.id,
            title: updatedPlaylist.title,
            description: updatedPlaylist.description,
            type: updatedPlaylist.type,
            isPrivate: updatedPlaylist.isPrivate,
            isLiked: updatedPlaylist.isLiked,
            coverArt: updatedPlaylist.coverArt,
            owner: updatedPlaylist.owner,
            tracks: p.tracks,
            totalDurationSeconds: updatedPlaylist.totalDurationSeconds,
            trackCount: updatedPlaylist.trackCount,
            playlistSlug: updatedPlaylist.playlistSlug,
            firstTrackWaveformUrl: updatedPlaylist.firstTrackWaveformUrl,
            secretToken: updatedPlaylist.secretToken,
            access: updatedPlaylist.access,
            createdAt: updatedPlaylist.createdAt,
          );
        }
        return p;
      }).toList();
      state = AsyncData(updatedList);
    }
  }
}
