import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/router/route_paths.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/playlist.dart';
import '../providers/user_playlists_provider.dart';

/// A StateProvider to hold the temporary dragged order before hitting Save
final pendingTracksProvider = StateProvider.autoDispose<List<int>?>(
  (ref) => null,
);

class PlaylistDetailsNotifier
    extends AutoDisposeFamilyAsyncNotifier<Playlist, int>
    with WidgetsBindingObserver {
  Timer? _deletionTimer;
  final List<Track> _pendingDeletions = [];

  KeepAliveLink? _keepAliveLink;

  @override
  Future<Playlist> build(int arg) async {
    // 1. Listen for App Backgrounding
    WidgetsBinding.instance.addObserver(this);

    // 2. Listen for Screen Pops (User hits back button)
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
    });

    final repository = ref.watch(playlistRepositoryProvider);

    final result = await repository.getPlaylistDetails(arg);

    return result.fold((failure) {
      if (failure is NetworkFailure) {
        final cachedPlaylists = ref.read(userPlaylistsProvider).valueOrNull;
        if (cachedPlaylists != null) {
          for (final playlist in cachedPlaylists) {
            if (playlist.id == arg) {
              return playlist;
            }
          }
        }
      }
      throw Exception(failure.message);
    }, (playlist) => playlist);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _flushDeletions(); // Fire immediately if app goes to background
    }
  }

  void scheduleDeletions(List<Track> tracksToDelete) {
    if (tracksToDelete.isEmpty) return;

    _keepAliveLink ??= ref.keepAlive();

    _pendingDeletions.addAll(tracksToDelete);

    final idsToRemove = tracksToDelete.map((t) => t.id).toList();
    ref
        .read(userPlaylistsProvider.notifier)
        .removeTracksLocally(arg, idsToRemove);

    // Optimistically update the UI to hide deleted tracks instantly
    if (state.value != null) {
      final p = state.value!;
      final newTracks = p.tracks
          .where((t) => !_pendingDeletions.any((d) => d.id == t.id))
          .toList();
      state = AsyncData(p.copyWith(tracks: newTracks));
    }

    // Start the 5-second countdown
    _deletionTimer?.cancel();
    _deletionTimer = Timer(const Duration(seconds: 5), () {
      _flushDeletions();
    });
  }

  void undoDeletions() {
    _deletionTimer?.cancel();

    ref
        .read(userPlaylistsProvider.notifier)
        .restoreTracksLocally(arg, _pendingDeletions);

    _pendingDeletions.clear();

    // Remove KeepAlive so memory can be cleaned up if the user left the screen
    _keepAliveLink?.close();
    _keepAliveLink = null;

    ref.invalidateSelf(); // Instantly fetch the original tracks back from the backend
  }

  void updatePlaylistLocally(Playlist updatedPlaylist) {
    final current = state.valueOrNull;
    if (current == null || current.id != updatedPlaylist.id) {
      state = AsyncData(updatedPlaylist);
      return;
    }

    state = AsyncData(
      current.copyWith(
        title: updatedPlaylist.title,
        description: updatedPlaylist.description,
        isPrivate: updatedPlaylist.isPrivate,
        isLiked: updatedPlaylist.isLiked,
        coverArt: updatedPlaylist.coverArt,
        owner: updatedPlaylist.owner ?? current.owner,
        tracks: updatedPlaylist.tracks.isNotEmpty
            ? updatedPlaylist.tracks
            : current.tracks,
        totalDurationSeconds: updatedPlaylist.totalDurationSeconds,
        trackCount: updatedPlaylist.trackCount,
        playlistSlug: updatedPlaylist.playlistSlug,
        firstTrackWaveformUrl: updatedPlaylist.firstTrackWaveformUrl,
        secretToken: updatedPlaylist.secretToken,
        access: updatedPlaylist.access,
        createdAt: updatedPlaylist.createdAt ?? current.createdAt,
      ),
    );
  }

  void _flushDeletions() {
    if (_pendingDeletions.isNotEmpty) {
      _deletionTimer?.cancel();
      // Use ref.read to execute safely in the background
      final repo = ref.read(playlistRepositoryProvider);
      for (final t in _pendingDeletions) {
        repo.removeTrackFromPlaylist(arg, t.id);
      }
      _pendingDeletions.clear();
    }

    // Remove KeepAlive once the backend sync is safely done
    _keepAliveLink?.close();
    _keepAliveLink = null;
  }

  Future<Either<Failure, String>> fetchSecretLink() async {
    final repository = ref.read(playlistRepositoryProvider);

    final result = await repository.getPlaylistSecretLink(arg);

    return result.fold((failure) => Left(failure), (token) {
      final fullLink =
          'https://decibel.foo${RoutePaths.deepLinkSecretPlaylist(token)}';

      return Right(fullLink);
    });
  }

  final playlistDetailsProvider = AsyncNotifierProvider.autoDispose
      .family<PlaylistDetailsNotifier, Playlist, int>(
        PlaylistDetailsNotifier.new,
      );
}
