import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/picker_service.dart';
import '../../../../core/storage/shared_prefs_service.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/playlist_metadata.dart';
import '../providers/user_playlists_provider.dart';

/// Provider for the Create/Update Playlist form state
final playlistFormProvider = AsyncNotifierProvider.autoDispose
    .family<PlaylistFormNotifier, PlaylistMetadata, Playlist?>(
      PlaylistFormNotifier.new,
    );

/// Manage the state of the playlist form and handles submission
class PlaylistFormNotifier
    extends AutoDisposeFamilyAsyncNotifier<PlaylistMetadata, Playlist?> {
  @override
  FutureOr<PlaylistMetadata> build(Playlist? arg) async {
    // EDIT MODE: If a playlist was passed in, pre-fill the form
    if (arg != null) {
      return PlaylistMetadata(
        title: arg.title,
        description: arg.description ?? '',
        isPrivate: arg.isPrivate,
        coverImage: null,
      );
    }
    // CREATE MODE: Initialize an empty form
    final prefService = ref.read(sharedPrefsServiceProvider);
    final savedIsPrivate = await prefService.getLastPrivacySettings();

    return PlaylistMetadata(
      coverImage: null,
      title: '',
      description: '',
      isPrivate: savedIsPrivate,
    );
  }

  // Helper method to keep state mutations clean
  void _updateState(PlaylistMetadata Function(PlaylistMetadata) update) {
    if (state.value != null) {
      state = AsyncData(update(state.value!));
    }
  }

  void updateTitle(String title) {
    if (title.length > 100) {
      state = AsyncValue<PlaylistMetadata>.error(
        "Playlist Title Can't exceed 100 characters",
        StackTrace.current,
      ).copyWithPrevious(state);
      return;
    }

    _updateState((state) => state.copyWith(title: title));
  }

  void updateDescription(String desc) =>
      _updateState((state) => state.copyWith(description: desc));

  void togglePrivacy(bool isPrivate) async {
    // 1. Update the UI state instantly
    _updateState((state) => state.copyWith(isPrivate: isPrivate));

    // 2. Save it to local storage in the background
    // Only save to defaults if we are in Create mode (not editing an existing playlist)
    // ignore: dead_code, unnecessary_null_comparison
    if (arg == null) {
      final prefsService = ref.read(sharedPrefsServiceProvider);
      await prefsService.saveLastPrivacySettings(isPrivate);
    }
  }

  Future<void> pickCoverImage() async {
    // Reade the injection service
    final pickerService = ref.read(pickerServiceProvider);

    final image = await pickerService.pickCoverImage();
    if (image != null) {
      // Read the first bytes (Magic Bits)
      final imageSize = image.lengthSync() / (1024 * 1024);

      final headerBytes = await image.openRead(0, 16).first;

      final mimeType = lookupMimeType('', headerBytes: headerBytes);

      const allowedImageMimeTypes = ['image/jpeg', 'image/png'];

      if (mimeType == null || !allowedImageMimeTypes.contains(mimeType)) {
        state = AsyncValue<PlaylistMetadata>.error(
          "Security Alert: This file is not a valid image format, FAKE EXTENSION. Please upload a real JPG or PNG file.",
          StackTrace.current,
        ).copyWithPrevious(state);
        return;
      }

      // Check if the user didn't cancel the upload
      if (imageSize > 20) {
        state = AsyncValue<PlaylistMetadata>.error(
          "Image file exceeds 20MB limit.",
          StackTrace.current,
        ).copyWithPrevious(state);
        return;
      }

      _updateState((state) => state.copyWith(coverImage: image));
    }
  }

  bool get isValid {
    final currentState = state.value;
    return currentState != null && currentState.title.trim().isNotEmpty;
  }

  Future<bool> submitPlaylist() async {
    final currentState = state.value;
    if (currentState == null || !isValid) return false;

    // 1. Trigger the loading state in the UI while keeping the previous data visible
    state = const AsyncLoading<PlaylistMetadata>().copyWithPrevious(state);

    final repository = ref.read(playlistRepositoryProvider);

    // 2. Send the draft to the backend
    Either<Failure, Playlist> result;

    //Decide whether to Create or Update based on the parameter
    // ignore: unnecessary_null_comparison
    if (arg != null) {
      result = await repository.updatePlaylist(arg!.id, currentState);
      // ignore: dead_code
    } else {
      result = await repository.createPlaylist(currentState);
    }

    // 3. Handle the Either response cleanly using fold
    return result.fold(
      (failure) {
        // Revert the loading state and show the error message
        state = AsyncValue<PlaylistMetadata>.error(
          failure.message,
          StackTrace.current,
        ).copyWithPrevious(state);
        return false;
      },
      (newPlaylist) {
        ref.invalidate(userPlaylistsProvider);

        // If editing an existing one, just update the metadata locally
        if (arg == null) {
          ref.invalidate(userPlaylistsProvider);
        } else {
          ref
              .read(userPlaylistsProvider.notifier)
              .updatePlaylistMetadataLocally(newPlaylist);
        }

        state = AsyncData(
          PlaylistMetadata(
            title: '',
            description: '',
            coverImage: null,
            isPrivate: currentState.isPrivate,
          ),
        );
        return true;
      },
    );
  }

  /// Checks if the current form state differs from the initial playlist data
  bool get hasChanges {
    final currentState = state.value;
    if (currentState == null || arg == null) return false;

    return currentState.title != arg!.title ||
        currentState.description != (arg!.description ?? '') ||
        currentState.isPrivate != arg!.isPrivate ||
        currentState.coverImage != null;
  }
}
