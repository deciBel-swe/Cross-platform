import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/domain/entities/track.dart';
import '../../data/datasources/offline_local_data_source.dart';
import '../../domain/repositories/i_offline_repository.dart';

/// Represents the state of a collection (playlist or station) download.
class CollectionDownloadState {
  const CollectionDownloadState({
    this.progress = 0.0,
    this.isDownloading = false,
    this.isDone = false,
    this.error,
  });

  /// Download progress from 0.0 to 1.0.
  final double progress;
  final bool isDownloading;
  final bool isDone;
  final String? error;

  CollectionDownloadState copyWith({
    double? progress,
    bool? isDownloading,
    bool? isDone,
    String? error,
  }) {
    return CollectionDownloadState(
      progress: progress ?? this.progress,
      isDownloading: isDownloading ?? this.isDownloading,
      isDone: isDone ?? this.isDone,
      error: error,
    );
  }
}

/// Notifier that orchestrates batch downloading of a collection of tracks
/// (a playlist or a station). Reports progress from 0.0 → 1.0 and saves
/// collection metadata so the Downloads screen can show grouped views.
class CollectionDownloadNotifier
    extends StateNotifier<CollectionDownloadState> {
  CollectionDownloadNotifier(this._repository)
      : super(const CollectionDownloadState());

  final IOfflineRepository _repository;

  /// Downloads all [tracks] in sequence and persists [collectionInfo]
  /// so the Downloads screen can reconstruct the playlist/station view.
  Future<void> download({
    required List<Track> tracks,
    required OfflineCollectionInfo collectionInfo,
  }) async {
    if (state.isDownloading) {
      return;
    }

    state = const CollectionDownloadState(isDownloading: true, progress: 0.0);

    // Save collection metadata first so the Downloads screen shows it even
    // if the download is interrupted partway through.
    await _repository.saveCollectionMetadata(collectionInfo);

    final result = await _repository.downloadTracks(
      tracks,
      onProgress: (progress) {
        if (mounted) {
          state = state.copyWith(progress: progress);
        }
      },
    );

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        state = CollectionDownloadState(
          isDownloading: false,
          isDone: false,
          error: failure.message,
        );
      },
      (_) {
        state = const CollectionDownloadState(
          isDownloading: false,
          isDone: true,
          progress: 1.0,
        );
      },
    );
  }
}
