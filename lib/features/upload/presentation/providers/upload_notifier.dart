import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/picker_service.dart';
import '../../../../core/services/waveform_extraction_service.dart';
import '../../../../core/storage/shared_prefs_service.dart';
import '../../../../core/utils/genre_constants.dart';
import '../../../library_profile/presentation/providers/uploads_provider.dart';
import '../../domain/entities/track_upload_metadata.dart';
import 'upload_repository_provider.dart';
import 'upload_sessions_provider.dart';

export 'upload_repository_provider.dart' show uploadRepositoryProvider;

final uploadNotifierProvider =
    AsyncNotifierProvider<UploadNotifier, TrackUploadMetadata>(
      UploadNotifier.new,
    );

final genreListProvider = StateProvider<List<String>>((ref) {
  return GenreConstants.genres;
});

class UploadNotifier extends AsyncNotifier<TrackUploadMetadata> {
  List<String> _genreSuggestions = [];

  @override
  FutureOr<TrackUploadMetadata> build() async {
    final prefsService = ref.read(sharedPrefsServiceProvider);
    final savedIsPrivate = await prefsService.getLastPrivacySettings();
    final pool = ref.read(genreListProvider);
    _genreSuggestions = pool.take(3).toList();
    final uploadId = const Uuid().v4();
    return TrackUploadMetadata(
      audioFile: null,
      title: '',
      genre: '',
      isPrivate: savedIsPrivate,
      coverImage: null,
      description: '',
      tags: [],
      releaseDate: null,
      uploadId: uploadId,
      access: 'PLAYABLE',
    );
  }

  void updateTitle(String title) {
    _updateState((state) => state.copyWith(title: title));
  }

  List<String> get genreSuggestions => _genreSuggestions;

  void updateGenre(String genre) {
    final currentState = state.value;

    if (currentState == null) {
      return;
    }

    state = AsyncData(currentState.copyWith(genre: genre));
    if (genreSuggestions.contains(genre)) {
      final pool = ref.read(genreListProvider);

      final available = pool
          .where((g) => !genreSuggestions.contains(g))
          .toList();

      if (available.isNotEmpty) {
        final index = genreSuggestions.indexOf(genre);
        genreSuggestions[index] = available.first;

        state = AsyncData(currentState.copyWith(genre: genre));

      }
    }
  }

  void updateDescription(String desc) {
    _updateState((state) => state.copyWith(description: desc));
  }

  void updateAccess(String access) {
    _updateState((state) => state.copyWith(access: access));
  }

  void togglePrivacy(bool isPrivate) async {
    final currentState = state.value;

    if (currentState != null) {
      state = AsyncData(currentState.copyWith(isPrivate: isPrivate));
    } else {
    }

    final prefsService = ref.read(sharedPrefsServiceProvider);
    await prefsService.saveLastPrivacySettings(isPrivate);

  }

  void updateReleaseDate(DateTime date) {
    _updateState((state) => state.copyWith(releaseDate: date));
  }

  void clearReleaseDate() {
    final currentState = state.value;

    if (currentState != null) {
      state = AsyncData(
        TrackUploadMetadata(
          audioFile: currentState.audioFile,
          coverImage: currentState.coverImage,
          title: currentState.title,
          genre: currentState.genre,
          description: currentState.description,
          tags: currentState.tags,
          isPrivate: currentState.isPrivate,
          uploadId: currentState.uploadId,
          access: currentState.access,
          releaseDate: null,
        ),
      );

    } else {
    }
  }

  void addTag(String tag) {
    final currentState = state.value;

    final sanitizedTag = tag
        .trim()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^\w]'), '');

    if (currentState == null) {
      return;
    }

    if (currentState.tags.length < 10 &&
        sanitizedTag.length < 21 &&
        sanitizedTag.length > 2 &&
        sanitizedTag.isNotEmpty) {
      final newTags = List<String>.from(currentState.tags)..add(sanitizedTag);
      _updateState((state) => state.copyWith(tags: newTags));

    } else {
    }
  }

  void removeTag(String tag) {
    final currentState = state.value;

    if (currentState != null) {
      final newTags = List<String>.from(currentState.tags)..remove(tag);
      _updateState((state) => state.copyWith(tags: newTags));

    } else {
    }
  }

  Future<void> pickAudioFile() async {
    final pickerService = ref.read(pickerServiceProvider);
    final file = await pickerService.pickAudioFile();

    if (file == null) {
      return;
    }

    try {
      final audioSizeInMB = file.lengthSync() / (1024 * 1024);
      final headerBytes = await file.openRead(0, 16).first;
      final mimeType = lookupMimeType('', headerBytes: headerBytes);

      const allowedAudioMimeTypes = ['audio/mpeg', 'audio/wav', 'audio/x-wav'];

      if (mimeType == null || !allowedAudioMimeTypes.contains(mimeType)) {
        state = AsyncValue<TrackUploadMetadata>.error(
          'Security Alert: This file is not a valid audio format, FAKE EXTENSION. Please upload a real MP3/WAV file.,',
          StackTrace.current,
        ).copyWithPrevious(state);

        return;
      }

      if (audioSizeInMB > 20) {
        state = AsyncValue<TrackUploadMetadata>.error(
          'Audio file exceeds 20MB limit.',
          StackTrace.current,
        ).copyWithPrevious(state);

        return;
      }

      final duration = await pickerService.getAudioDuration(file.path);

      if (duration == null || duration.inSeconds < 1) {
        state = AsyncValue<TrackUploadMetadata>.error(
          'Audio file must be at least 1 second long.',
          StackTrace.current,
        ).copyWithPrevious(state);

        return;
      }

      final currentState = state.value;

      if (currentState == null) {
        return;
      }

      final metadata = currentState.copyWith(audioFile: file);
      state = AsyncData(metadata);

    } catch (error) {
      state = AsyncValue<TrackUploadMetadata>.error(
        error.toString(),
        StackTrace.current,
      ).copyWithPrevious(state);
    }
  }

  Future<void> pickCoverImage() async {
    final pickerService = ref.read(pickerServiceProvider);
    final image = await pickerService.pickCoverImage();

    if (image == null) {
      return;
    }

    try {
      final imageSize = image.lengthSync() / (1024 * 1024);
      final headerBytes = await image.openRead(0, 16).first;
      final mimeType = lookupMimeType('', headerBytes: headerBytes);

      const allowedImageMimeTypes = ['image/jpeg', 'image/png'];

      if (mimeType == null || !allowedImageMimeTypes.contains(mimeType)) {
        state = AsyncValue<TrackUploadMetadata>.error(
          'Security Alert: This file is not a valid image format, FAKE EXTENSION. Please upload a real JPG or PNG file.',
          StackTrace.current,
        ).copyWithPrevious(state);

        return;
      }

      if (imageSize > 20) {
        state = AsyncValue<TrackUploadMetadata>.error(
          'Image file exceeds 20MB limit.',
          StackTrace.current,
        ).copyWithPrevious(state);

        return;
      }

      _updateState((state) => state.copyWith(coverImage: image));

    } catch (error) {
      state = AsyncValue<TrackUploadMetadata>.error(
        error.toString(),
        StackTrace.current,
      ).copyWithPrevious(state);
    }
  }

  Future<bool> submitTrack() async {
    final currentState = state.value;

    if (currentState == null) {
      return false;
    }

    if (currentState.audioFile == null) {
      return false;
    }

    List<double> waveFormData = [];

    try {
      final waveformService = ref.read(waveformExtractionServiceProvider);
      waveFormData = await waveformService.extractWaveform(
        currentState.audioFile!.path,
        noOfSamples: 100,
      );

      if (waveFormData.isNotEmpty) {
      }
    } catch (e) {
      waveFormData = [];
    }

    if (waveFormData.isEmpty) {
      state = AsyncValue<TrackUploadMetadata>.error(
        'Could not extract waveform data from this audio file.',
        StackTrace.current,
      ).copyWithPrevious(state);

      return false;
    }

    state = const AsyncLoading<TrackUploadMetadata>().copyWithPrevious(state);

    final repository = ref.read(uploadRepositoryProvider);
    final metadataToUpload = currentState.copyWith(waveFormData: waveFormData);

    // Subscribe BEFORE sending the upload request.
    // This prevents missing fast backend WebSocket messages.
    ref
        .read(uploadSessionsProvider.notifier)
        .watchUploadStatusBeforeTrack(uploadId: metadataToUpload.uploadId);

    final result = await repository.uploadTrack(metadataToUpload);

    return result.fold(
      (failure) {
        ref
            .read(uploadSessionsProvider.notifier)
            .cancelUploadStatusWatch(metadataToUpload.uploadId);

        state = AsyncValue<TrackUploadMetadata>.error(
          failure.message,
          StackTrace.current,
        ).copyWithPrevious(state);

        return false;
      },
      (track) {
        ref
            .read(uploadSessionsProvider.notifier)
            .trackUpload(uploadId: metadataToUpload.uploadId, track: track);

        ref.read(uploadsProvider.notifier).addTrack(track);

        final nextUploadId = const Uuid().v4();

        state = AsyncData(
          TrackUploadMetadata(
            audioFile: null,
            coverImage: null,
            title: '',
            genre: '',
            description: '',
            tags: [],
            isPrivate: currentState.isPrivate,
            releaseDate: null,
            uploadId: nextUploadId,
            access: 'PLAYABLE',
          ),
        );

        return true;
      },
    );
  }

  void _updateState(TrackUploadMetadata Function(TrackUploadMetadata) update) {
    if (state.value != null) {
      state = AsyncData(update(state.value!));
    } else {
    }
  }
}
