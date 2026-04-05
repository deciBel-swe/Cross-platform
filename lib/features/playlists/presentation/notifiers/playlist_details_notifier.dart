import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/playlist.dart';
import 'playlist_form_notifier.dart';

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

    return result.fold(
      (failure) => throw Exception(failure.message),
      (playlist) => playlist,
    );
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

    // Optimistically update the UI to hide deleted tracks instantly
    if (state.value != null) {
      final p = state.value!;
      final newTracks = p.tracks
          .where((t) => !_pendingDeletions.any((d) => d.id == t.id))
          .toList();
      state = AsyncData(
        Playlist(
          id: p.id,
          title: p.title,
          description: p.description,
          type: p.type,
          isPrivate: p.isPrivate,
          isLiked: p.isLiked,
          coverArt: p.coverArt,
          owner: p.owner,
          tracks: newTracks,
        ),
      );
    }

    // Start the 5-second countdown
    _deletionTimer?.cancel();
    _deletionTimer = Timer(const Duration(seconds: 5), () {
      _flushDeletions();
    });
  }

  void undoDeletions() {
    _deletionTimer?.cancel();
    _pendingDeletions.clear();

    // Remove KeepAlive so memory can be cleaned up if the user left the screen
    _keepAliveLink?.close();
    _keepAliveLink = null;

    ref.invalidateSelf(); // Instantly fetch the original tracks back from the backend
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

    return await repository.getPlaylistSecretLink(arg);
  }
}

final playlistDetailsProvider = AsyncNotifierProvider.autoDispose
    .family<PlaylistDetailsNotifier, Playlist, int>(
      PlaylistDetailsNotifier.new,
    );
