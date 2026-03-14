import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/storage/shared_prefs_service.dart';
import '../../domain/entities/track_upload_metadata.dart';
import '../../domain/repositories/i_upload_repository.dart';
import '../../../../core/di/injection.dart';

// 1. Bridge GitIt (Dependency Injection) to Riverpod (State Management)
final uploadRepositoryProvider = Provider<IUploadRepository>((ref) {
  return getIt<IUploadRepository>();
});

// 2. Provide the notifier to the UI
final uploadNotifierProvider =
    AsyncNotifierProvider<UploadNotifier, TrackUploadMetadata>(
      // Create a Riverpod provider for UploadNotifier to manage state of (TrackUploadMetadata)
      UploadNotifier.new,
    );

// 3. The Notifier which containing the form logic "Upload Form Controller"
class UploadNotifier extends AsyncNotifier<TrackUploadMetadata> {
  @override
  FutureOr<TrackUploadMetadata> build() async {
    // 1. Read the service via Riverpod
    final prefsService = ref.read(sharedPrefsServiceProvider);

    // 2. Fetch the saved setting
    final savedIsPrivate = await prefsService.getLastPrivacySettings();

    return TrackUploadMetadata(
      audioFile: null,
      title: '',
      genre: '',
      isPrivate: savedIsPrivate,
      coverImage: null,
      description: '',
      tags: [],
      releasedDate: null,
    );
  }

  // Update the fields of the form. Entity is immutable so use copyWith
  void updateTitle(String title) =>
      _updateState((state) => state.copyWith(title: title));
  void updateGenre(String genre) =>
      _updateState((state) => state.copyWith(genre: genre));
  void updateDescription(String desc) =>
      _updateState((state) => state.copyWith(description: desc));
  void togglePrivacy(bool isPrivate) async {
    // 1. Update the UI state instantly
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(isPrivate: isPrivate));
    }

    // 2. Save it to local storage cleanly in the background
    final prefsService = ref.read(sharedPrefsServiceProvider);
    await prefsService.saveLastPrivacySettings(isPrivate);
  }

  void updateReleaseDate(DateTime date) =>
      _updateState((state) => state.copyWith(releaseDate: date));
  void clearReleaseDate() {
    final currentState = state.value;
    if (currentState != null) {
      // create a new instance to force releaseDate back to null
      state = AsyncData(
        TrackUploadMetadata(
          audioFile: currentState.audioFile,
          coverImage: currentState.coverImage,
          title: currentState.title,
          genre: currentState.genre,
          description: currentState.description,
          tags: currentState.tags,
          isPrivate: currentState.isPrivate,
          releasedDate: null,
        ),
      );
    }
  }

  // Managing Tags
  void addTag(String tag) {
    final currentState = state.value;
    // Check if state exit, max 10 tags, and tag is not empty
    if (currentState != null &&
        currentState.tags.length < 10 &&
        tag.isNotEmpty) {
      final newTags = List<String>.from(currentState.tags)..add(tag);
      _updateState((state) => state.copyWith(tags: newTags));
    }
  }

  void removeTag(String tag) {
    final currentState = state.value;
    if (currentState != null) {
      // Create new list and add the tag, and avoid mutating the original list
      final newTags = List<String>.from(currentState.tags)..remove(tag);
      _updateState((state) => state.copyWith(tags: newTags));
    }
  }

  // File picker
  Future<void> pickAudioFile() async {
    // Opens file explorer allowing only audio files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
    );
    if (result != null) {
      final file = File(result.files.single.path!);
      final sizeInMB = file.lengthSync() / (1024 * 1024);
      final extension = file.path.split('.').last.toLowerCase();

      if (extension != 'mp3' && extension != 'wav') {
        if (state.value != null) {
          state = AsyncValue<TrackUploadMetadata>.error(
            "Unsupported format. Please use MP3, WAV.",
            StackTrace.current,
          ).copyWithPrevious(AsyncData(state.value!));
        }
        return;
      }

      if (sizeInMB > 500) {
        if (state.value != null) {
          state = AsyncValue<TrackUploadMetadata>.error(
            "File exceed 500MB limit.",
            StackTrace.current,
          ).copyWithPrevious(AsyncData(state.value!));
        }
        return;
      }

      final metadata = state.value!.copyWith(audioFile: file);
      state = AsyncData(metadata);
    }
  }

  Future<void> pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    // Open the phone gallery to pick the cover image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _updateState((state) => state.copyWith(coverImage: File(image.path)));
    }
  }

  // Form Submission
  Future<bool> submitTrack() async {
    // Getting the current state and check is it null or not for safety
    final currentState = state.value;
    if (currentState == null) return false;

    // Set the loading state
    state = const AsyncLoading();

    // Getting the repository instance to the Riverpod
    final repository = ref.read(uploadRepositoryProvider);

    // Calling the upload API to send the metadata and files to the backend
    final result = await repository.uploadTrack(currentState);

    return result.fold(
      // If fail, then update the UI with the error
      (failure) {
        //Why I added this
        // because in your first code deletes the error immediately to save the data.
        // so the user will not see the error message.
        // So I added .copyWithPrevious(AsyncData(currentState)); to preserve the data that was entered in the form before the error occurred.
        // and also hold the error at same time
        state = AsyncValue<TrackUploadMetadata>.error(
          failure.message,
          StackTrace.current,
        ).copyWithPrevious(AsyncData(currentState));
        return false;
      },
      // if success, then update the form with a new empty instance
      (success) {
        state = const AsyncData(TrackUploadMetadata());
        return true;
      },
    );
  }

  // making helper update method to make it generic
  void _updateState(TrackUploadMetadata Function(TrackUploadMetadata) update) {
    if (state.value != null) {
      state = AsyncData(update(state.value!));
    }
  }
}
