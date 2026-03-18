import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/picker_service.dart';
import '../../../../core/services/waveform_extraction_service.dart';
import '../../../../core/storage/shared_prefs_service.dart';
import '../../domain/entities/track_upload_metadata.dart';
import '../../domain/repositories/i_upload_repository.dart';

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

final genreListProvider = StateProvider<List<String>>((ref) {
  // Mocked backend data
  return [
    "Qur'an",
    'Alternative Rock',
    'Ambient',
    'Classical',
    'Country',
    'Dance & EDM',
    'Dancehall',
    'Deep House',
    'Disco',
    'Drum & Bass',
    'Dubstep',
    'Electronic',
    'Folk & Singer-Songwriter',
    'Hip-hop & Rap',
    'House',
  ];
});

// 3. The Notifier which containing the form logic "Upload Form Controller"
class UploadNotifier extends AsyncNotifier<TrackUploadMetadata> {
  // Keep Track of 3 genre suggestions.
  List<String> _genreSuggestions = [];

  @override
  FutureOr<TrackUploadMetadata> build() async {
    // 1. Read the service via Riverpod
    final prefsService = ref.read(sharedPrefsServiceProvider);

    // 2. Fetch the saved setting
    final savedIsPrivate = await prefsService.getLastPrivacySettings();

    final pool = ref.read(genreListProvider);
    _genreSuggestions = pool.take(3).toList();

    return TrackUploadMetadata(
      audioFile: null,
      title: '',
      genre: '',
      isPrivate: savedIsPrivate,
      coverImage: null,
      description: '',
      tags: [],
      releaseDate: null,
    );
  }

  // Update the fields of the form. Entity is immutable so use copyWith
  void updateTitle(String title) =>
      _updateState((state) => state.copyWith(title: title));

  // Getter for the UI to see which chips to show
  List<String> get genreSuggestions => _genreSuggestions;
  void updateGenre(String genre) {
    final currentState = state.value;
    if (currentState == null) return;

    // 1. Update the actual metadata
    state = AsyncData(currentState.copyWith(genre: genre));

    // 2. Rotation Logic: If the picked genre was a chip, swap it
    if (genreSuggestions.contains(genre)) {
      final pool = ref.read(genreListProvider);

      // Find genres in pool not currently displayed
      final available = pool
          .where((g) => !genreSuggestions.contains(g))
          .toList();

      if (available.isNotEmpty) {
        final index = genreSuggestions.indexOf(genre);
        genreSuggestions[index] = available.first;
        // Trigger a UI refresh by re-emitting the state
        state = AsyncData(currentState.copyWith(genre: genre));
      }
    }
  }

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
          releaseDate: null,
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
    // Reading the injected service
    final pickerService = ref.read(pickerServiceProvider);

    final file = await pickerService.pickAudioFile();
    if (file != null) {
      final extension = file.path.split('.').last.toLowerCase();
      final sizeInMB = file.lengthSync() / (1024 * 1024);

      // Fallback in case the OS picker ignores the filter
      if (extension != 'mp3' && extension != 'wav') {
        state = AsyncValue<TrackUploadMetadata>.error(
          "Unsupported format. Please use MP3, WAV.",
          StackTrace.current,
        ).copyWithPrevious(state);
        return;
      }

      // Check if the user didn't cancel the upload
      if (sizeInMB > 500) {
        state = AsyncValue<TrackUploadMetadata>.error(
          "File exceeds 500MB limit.",
          StackTrace.current,
        ).copyWithPrevious(state);
        return;
      }

      List<double> waveFormData = [];
      try {
        final waveformService = ref.read(waveformExtractionServiceProvider);
        waveFormData = await waveformService.extractWaveform(file.path);
      } catch (e) {
        waveFormData = [];
      }

      final metadata = state.value!.copyWith(
        audioFile: file,
        waveFormData: waveFormData,
      );
      state = AsyncData(metadata);
    }
  }

  Future<void> pickCoverImage() async {
    // Reade the injection service
    final pickerService = ref.read(pickerServiceProvider);

    final image = await pickerService.pickCoverImage();
    if (image != null) {
      _updateState((state) => state.copyWith(coverImage: image));
    }
  }

  // Form Submission
  Future<bool> submitTrack() async {
    // Getting the current state and check is it null or not for safety
    final currentState = state.value;
    if (currentState == null) return false;

    // Set the loading state
    state = const AsyncLoading<TrackUploadMetadata>().copyWithPrevious(state);

    // Getting the repository instance to the Riverpod
    final repository = ref.read(uploadRepositoryProvider);

    // Calling the upload API to send the metadata and files to the backend
    final result = await repository.uploadTrack(currentState);

    return result.fold(
      // If fail, then update the UI with the error
      (failure) {
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
