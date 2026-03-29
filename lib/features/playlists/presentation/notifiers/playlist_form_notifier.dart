import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/picker_service.dart';
import '../../../../core/storage/shared_prefs_service.dart';
import '../../domain/entities/playlist_metadata.dart';
import '../../domain/repositories/i_playlist_repository.dart';

final playlistRepositoryProvider = Provider<IPlaylistRepository>((ref) {
  return getIt<IPlaylistRepository>();
});

/// Provider for the Create/Update Playlist form state
final playlistFormProvider =
    AsyncNotifierProvider.autoDispose<PlaylistFormNotifier, PlaylistMetadata>(
      PlaylistFormNotifier.new,
    );

/// Manage the state of the playlist form and handles submission
class PlaylistFormNotifier extends AutoDisposeAsyncNotifier<PlaylistMetadata> {
  @override
  FutureOr<PlaylistMetadata> build() async {
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

  void updateTitle(String title) =>
      _updateState((state) => state.copyWith(title: title));

  void updateDescription(String desc) =>
      _updateState((state) => state.copyWith(description: desc));

  void togglePrivacy(bool isPrivate) async {
    // 1. Update the UI state instantly
    _updateState((state) => state.copyWith(isPrivate: isPrivate));

    // 2. Save it to local storage in the background
    final prefsService = ref.read(sharedPrefsServiceProvider);
    await prefsService.saveLastPrivacySettings(isPrivate);
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
    final result = await repository.createPlaylist(currentState);

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
        // TODO: add the library playlist Provider here when its finished.

        state = AsyncData(PlaylistMetadata(isPrivate: currentState.isPrivate));
        return true;
      },
    );
  }
}
