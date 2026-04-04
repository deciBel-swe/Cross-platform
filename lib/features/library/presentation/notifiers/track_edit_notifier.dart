import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/picker_service.dart';
import '../../../library_profile/presentation/providers/track_repository_provider.dart';
import '../../domain/entities/track_edit_request.dart';
import '../state/track_edit_state.dart';

class TrackEditNotifier
    extends AutoDisposeFamilyAsyncNotifier<TrackEditState, int> {
  @override
  Future<TrackEditState> build(int trackId) async {
    final repository = ref.read(trackRepositoryProvider);
    try {
      final trackResult = await repository
          .fetchTrackById(trackId)
          .timeout(const Duration(seconds: 12));

      return trackResult.fold(
        (failure) => throw Exception(failure.message),
        (track) => TrackEditState(
          title: track.title,
          genre: track.genre,
          description: '',
          tags: track.tags,
          releaseDate: track.releaseDate,
          isPrivate: false,
          currentCoverUrl: track.coverUrl,
        ),
      );
    } on TimeoutException {
      throw Exception('Timed out while loading track details.');
    }
  }

  void updateTitle(String value) {
    _updateState((state) => state.copyWith(title: value));
  }

  void updateGenre(String value) {
    _updateState((state) => state.copyWith(genre: value));
  }

  void updateDescription(String value) {
    _updateState((state) => state.copyWith(description: value));
  }

  void updateIsPrivate(bool value) {
    _updateState((state) => state.copyWith(isPrivate: value));
  }

  void updateReleaseDate(DateTime value) {
    _updateState((state) => state.copyWith(releaseDate: value));
  }

  void clearReleaseDate() {
    _updateState((state) => state.copyWith(clearReleaseDate: true));
  }

  void updateTagsFromInput(String value) {
    final tags = value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .map((item) => item.replaceAll(RegExp(r'\s+'), '_'))
        .map((item) => item.replaceAll(RegExp(r'[^\w]'), ''))
        .where((item) => item.isNotEmpty)
        .take(10)
        .toList(growable: false);

    _updateState((state) => state.copyWith(tags: tags));
  }

  Future<void> pickCoverImage() async {
    final picker = ref.read(pickerServiceProvider);
    final file = await picker.pickCoverImage();
    if (file == null) {
      return;
    }

    _updateState(
      (state) => state.copyWith(
        newCoverImage: file,
        removeCover: false,
        clearCurrentCoverUrl: true,
      ),
    );
  }

  void markCoverForRemoval() {
    _updateState(
      (state) => state.copyWith(
        removeCover: true,
        clearCurrentCoverUrl: true,
        clearNewCoverImage: true,
      ),
    );
  }

  Future<bool> submit(int trackId) async {
    final current = state.valueOrNull;
    if (current == null) {
      return false;
    }

    _updateState((s) => s.copyWith(isSubmitting: true));
    final repository = ref.read(trackRepositoryProvider);

    if (current.removeCover && current.newCoverImage == null) {
      final deleteResult = await repository.deleteTrackCover(trackId);
      final deleteFailed = deleteResult.fold((_) => true, (_) => false);
      if (deleteFailed) {
        _updateState((s) => s.copyWith(isSubmitting: false));
        return false;
      }
    }

    final updateResult = await repository.updateTrackMetadata(
      trackId: trackId,
      request: TrackEditRequest(
        title: current.title.trim(),
        genre: current.genre.trim(),
        description: current.description.trim(),
        tags: current.tags,
        releaseDate: current.releaseDate,
        isPrivate: current.isPrivate,
        coverImage: current.newCoverImage,
      ),
    );

    return updateResult.fold(
      (_) {
        _updateState((s) => s.copyWith(isSubmitting: false));
        return false;
      },
      (_) {
        _updateState((s) => s.copyWith(isSubmitting: false));
        return true;
      },
    );
  }

  void _updateState(TrackEditState Function(TrackEditState state) update) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    state = AsyncData(update(current));
  }
}
