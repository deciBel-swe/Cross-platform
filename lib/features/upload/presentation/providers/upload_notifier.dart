import 'dart:async';

import 'package:flutter/foundation.dart';
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
    debugPrint('==============================');
    debugPrint('[UploadNotifier] build() called');

    final prefsService = ref.read(sharedPrefsServiceProvider);
    debugPrint('[UploadNotifier] sharedPrefsService read');

    final savedIsPrivate = await prefsService.getLastPrivacySettings();
    debugPrint('[UploadNotifier] savedIsPrivate: $savedIsPrivate');

    final pool = ref.read(genreListProvider);
    debugPrint('[UploadNotifier] genre pool length: ${pool.length}');

    _genreSuggestions = pool.take(3).toList();
    debugPrint('[UploadNotifier] genreSuggestions: $_genreSuggestions');

    final uploadId = const Uuid().v4();
    debugPrint('[UploadNotifier] initial uploadId: $uploadId');

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
    debugPrint('[UploadNotifier] updateTitle(): $title');
    _updateState((state) => state.copyWith(title: title));
  }

  List<String> get genreSuggestions => _genreSuggestions;

  void updateGenre(String genre) {
    debugPrint('[UploadNotifier] updateGenre(): $genre');

    final currentState = state.value;

    if (currentState == null) {
      debugPrint('[UploadNotifier] updateGenre ignored because state is null');
      return;
    }

    state = AsyncData(currentState.copyWith(genre: genre));
    debugPrint('[UploadNotifier] genre saved in state');

    if (genreSuggestions.contains(genre)) {
      debugPrint('[UploadNotifier] selected genre exists in suggestions');

      final pool = ref.read(genreListProvider);

      final available = pool
          .where((g) => !genreSuggestions.contains(g))
          .toList();

      debugPrint(
        '[UploadNotifier] available replacement genres: ${available.length}',
      );

      if (available.isNotEmpty) {
        final index = genreSuggestions.indexOf(genre);
        genreSuggestions[index] = available.first;

        state = AsyncData(currentState.copyWith(genre: genre));

        debugPrint(
          '[UploadNotifier] genreSuggestions updated: $_genreSuggestions',
        );
      }
    }
  }

  void updateDescription(String desc) {
    debugPrint('[UploadNotifier] updateDescription(): length=${desc.length}');
    _updateState((state) => state.copyWith(description: desc));
  }

  void updateAccess(String access) {
    debugPrint('[UploadNotifier] updateAccess(): $access');
    _updateState((state) => state.copyWith(access: access));
  }

  void togglePrivacy(bool isPrivate) async {
    debugPrint('[UploadNotifier] togglePrivacy(): $isPrivate');

    final currentState = state.value;

    if (currentState != null) {
      state = AsyncData(currentState.copyWith(isPrivate: isPrivate));
      debugPrint('[UploadNotifier] privacy updated in state');
    } else {
      debugPrint(
        '[UploadNotifier] privacy state update skipped because currentState is null',
      );
    }

    final prefsService = ref.read(sharedPrefsServiceProvider);
    await prefsService.saveLastPrivacySettings(isPrivate);

    debugPrint('[UploadNotifier] privacy saved to prefs');
  }

  void updateReleaseDate(DateTime date) {
    debugPrint('[UploadNotifier] updateReleaseDate(): $date');
    _updateState((state) => state.copyWith(releaseDate: date));
  }

  void clearReleaseDate() {
    debugPrint('[UploadNotifier] clearReleaseDate() called');

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

      debugPrint('[UploadNotifier] releaseDate cleared');
    } else {
      debugPrint(
        '[UploadNotifier] clearReleaseDate skipped because currentState is null',
      );
    }
  }

  void addTag(String tag) {
    debugPrint('[UploadNotifier] addTag() called: $tag');

    final currentState = state.value;

    final sanitizedTag = tag
        .trim()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^\w]'), '');

    debugPrint('[UploadNotifier] sanitizedTag: $sanitizedTag');

    if (currentState == null) {
      debugPrint(
        '[UploadNotifier] addTag ignored because currentState is null',
      );
      return;
    }

    debugPrint(
      '[UploadNotifier] current tags length: ${currentState.tags.length}',
    );

    if (currentState.tags.length < 10 &&
        sanitizedTag.length < 21 &&
        sanitizedTag.length > 2 &&
        sanitizedTag.isNotEmpty) {
      final newTags = List<String>.from(currentState.tags)..add(sanitizedTag);
      _updateState((state) => state.copyWith(tags: newTags));

      debugPrint('[UploadNotifier] tag added');
      debugPrint('[UploadNotifier] new tags: $newTags');
    } else {
      debugPrint('[UploadNotifier] tag rejected by validation');
    }
  }

  void removeTag(String tag) {
    debugPrint('[UploadNotifier] removeTag() called: $tag');

    final currentState = state.value;

    if (currentState != null) {
      final newTags = List<String>.from(currentState.tags)..remove(tag);
      _updateState((state) => state.copyWith(tags: newTags));

      debugPrint('[UploadNotifier] tag removed');
      debugPrint('[UploadNotifier] new tags: $newTags');
    } else {
      debugPrint(
        '[UploadNotifier] removeTag ignored because currentState is null',
      );
    }
  }

  Future<void> pickAudioFile() async {
    debugPrint('==============================');
    debugPrint('[UploadNotifier] pickAudioFile() called');

    final pickerService = ref.read(pickerServiceProvider);
    debugPrint('[UploadNotifier] pickerService read');

    final file = await pickerService.pickAudioFile();

    if (file == null) {
      debugPrint('[UploadNotifier] audio picking cancelled / file is null');
      return;
    }

    debugPrint('[UploadNotifier] audio file selected');
    debugPrint('[UploadNotifier] audio path: ${file.path}');

    try {
      final audioSizeInMB = file.lengthSync() / (1024 * 1024);
      debugPrint('[UploadNotifier] audio size MB: $audioSizeInMB');

      final headerBytes = await file.openRead(0, 16).first;
      final mimeType = lookupMimeType('', headerBytes: headerBytes);

      debugPrint('[UploadNotifier] audio mimeType: $mimeType');

      const allowedAudioMimeTypes = ['audio/mpeg', 'audio/wav', 'audio/x-wav'];

      if (mimeType == null || !allowedAudioMimeTypes.contains(mimeType)) {
        debugPrint('[UploadNotifier] invalid audio mime type');

        state = AsyncValue<TrackUploadMetadata>.error(
          'Security Alert: This file is not a valid audio format, FAKE EXTENSION. Please upload a real MP3/WAV file.,',
          StackTrace.current,
        ).copyWithPrevious(state);

        return;
      }

      if (audioSizeInMB > 20) {
        debugPrint('[UploadNotifier] audio file too large');

        state = AsyncValue<TrackUploadMetadata>.error(
          'Audio file exceeds 20MB limit.',
          StackTrace.current,
        ).copyWithPrevious(state);

        return;
      }

      debugPrint('[UploadNotifier] reading audio duration');

      final duration = await pickerService.getAudioDuration(file.path);

      debugPrint('[UploadNotifier] audio duration: $duration');

      if (duration == null || duration.inSeconds < 1) {
        debugPrint('[UploadNotifier] invalid audio duration');

        state = AsyncValue<TrackUploadMetadata>.error(
          'Audio file must be at least 1 second long.',
          StackTrace.current,
        ).copyWithPrevious(state);

        return;
      }

      final currentState = state.value;

      if (currentState == null) {
        debugPrint('[UploadNotifier] currentState is null after picking audio');
        return;
      }

      final metadata = currentState.copyWith(audioFile: file);
      state = AsyncData(metadata);

      debugPrint('[UploadNotifier] audioFile saved in state');
      debugPrint('[UploadNotifier] current uploadId: ${metadata.uploadId}');
      debugPrint('[UploadNotifier] current title: ${metadata.title}');
      debugPrint('[UploadNotifier] current genre: ${metadata.genre}');
    } catch (error, stackTrace) {
      debugPrint('[UploadNotifier] pickAudioFile failed: $error');
      debugPrint('[UploadNotifier] stackTrace: $stackTrace');

      state = AsyncValue<TrackUploadMetadata>.error(
        error.toString(),
        StackTrace.current,
      ).copyWithPrevious(state);
    }
  }

  Future<void> pickCoverImage() async {
    debugPrint('==============================');
    debugPrint('[UploadNotifier] pickCoverImage() called');

    final pickerService = ref.read(pickerServiceProvider);
    debugPrint('[UploadNotifier] pickerService read');

    final image = await pickerService.pickCoverImage();

    if (image == null) {
      debugPrint('[UploadNotifier] image picking cancelled / image is null');
      return;
    }

    debugPrint('[UploadNotifier] cover image selected');
    debugPrint('[UploadNotifier] image path: ${image.path}');

    try {
      final imageSize = image.lengthSync() / (1024 * 1024);
      debugPrint('[UploadNotifier] image size MB: $imageSize');

      final headerBytes = await image.openRead(0, 16).first;
      final mimeType = lookupMimeType('', headerBytes: headerBytes);

      debugPrint('[UploadNotifier] image mimeType: $mimeType');

      const allowedImageMimeTypes = ['image/jpeg', 'image/png'];

      if (mimeType == null || !allowedImageMimeTypes.contains(mimeType)) {
        debugPrint('[UploadNotifier] invalid image mime type');

        state = AsyncValue<TrackUploadMetadata>.error(
          'Security Alert: This file is not a valid image format, FAKE EXTENSION. Please upload a real JPG or PNG file.',
          StackTrace.current,
        ).copyWithPrevious(state);

        return;
      }

      if (imageSize > 20) {
        debugPrint('[UploadNotifier] image file too large');

        state = AsyncValue<TrackUploadMetadata>.error(
          'Image file exceeds 20MB limit.',
          StackTrace.current,
        ).copyWithPrevious(state);

        return;
      }

      _updateState((state) => state.copyWith(coverImage: image));

      debugPrint('[UploadNotifier] coverImage saved in state');
    } catch (error, stackTrace) {
      debugPrint('[UploadNotifier] pickCoverImage failed: $error');
      debugPrint('[UploadNotifier] stackTrace: $stackTrace');

      state = AsyncValue<TrackUploadMetadata>.error(
        error.toString(),
        StackTrace.current,
      ).copyWithPrevious(state);
    }
  }

  Future<bool> submitTrack() async {
    debugPrint('==============================');
    debugPrint('[UploadNotifier] submitTrack() called');

    final currentState = state.value;

    if (currentState == null) {
      debugPrint('[UploadNotifier] currentState is null');
      return false;
    }

    debugPrint('[UploadNotifier] current uploadId: ${currentState.uploadId}');
    debugPrint('[UploadNotifier] current title: ${currentState.title}');
    debugPrint('[UploadNotifier] current genre: ${currentState.genre}');
    debugPrint(
      '[UploadNotifier] current description length: ${currentState.description.length}',
    );
    debugPrint('[UploadNotifier] current tags: ${currentState.tags}');
    debugPrint('[UploadNotifier] current isPrivate: ${currentState.isPrivate}');
    debugPrint('[UploadNotifier] current access: ${currentState.access}');
    debugPrint(
      '[UploadNotifier] has audioFile: ${currentState.audioFile != null}',
    );
    debugPrint(
      '[UploadNotifier] has coverImage: ${currentState.coverImage != null}',
    );
    debugPrint('[UploadNotifier] releaseDate: ${currentState.releaseDate}');

    if (currentState.audioFile == null) {
      debugPrint('[UploadNotifier] audioFile is null');
      return false;
    }

    debugPrint('[UploadNotifier] audio file exists');
    debugPrint('[UploadNotifier] audio path: ${currentState.audioFile!.path}');

    List<double> waveFormData = [];

    try {
      debugPrint('[UploadNotifier] extracting waveform');

      final waveformService = ref.read(waveformExtractionServiceProvider);
      debugPrint('[UploadNotifier] waveformService read');

      waveFormData = await waveformService.extractWaveform(
        currentState.audioFile!.path,
        noOfSamples: 100,
      );

      debugPrint('[UploadNotifier] waveform extracted');
      debugPrint('[UploadNotifier] waveform length: ${waveFormData.length}');

      if (waveFormData.isNotEmpty) {
        debugPrint(
          '[UploadNotifier] waveform first value: ${waveFormData.first}',
        );
        debugPrint(
          '[UploadNotifier] waveform last value: ${waveFormData.last}',
        );
      }
    } catch (e, st) {
      debugPrint('[UploadNotifier] waveform extraction failed: $e');
      debugPrint('[UploadNotifier] stackTrace: $st');
      waveFormData = [];
    }

    if (waveFormData.isEmpty) {
      debugPrint('[UploadNotifier] waveform is empty, stopping upload');

      state = AsyncValue<TrackUploadMetadata>.error(
        'Could not extract waveform data from this audio file.',
        StackTrace.current,
      ).copyWithPrevious(state);

      return false;
    }

    debugPrint('[UploadNotifier] setting upload form to loading');

    state = const AsyncLoading<TrackUploadMetadata>().copyWithPrevious(state);

    final repository = ref.read(uploadRepositoryProvider);
    debugPrint('[UploadNotifier] uploadRepository read');

    final metadataToUpload = currentState.copyWith(waveFormData: waveFormData);

    debugPrint(
      '[UploadNotifier] metadataToUpload uploadId: ${metadataToUpload.uploadId}',
    );
    debugPrint(
      '[UploadNotifier] metadataToUpload title: ${metadataToUpload.title}',
    );
    debugPrint(
      '[UploadNotifier] metadataToUpload genre: ${metadataToUpload.genre}',
    );
    debugPrint(
      '[UploadNotifier] metadataToUpload access: ${metadataToUpload.access}',
    );
    debugPrint(
      '[UploadNotifier] metadataToUpload waveform length: ${metadataToUpload.waveFormData.length}',
    );

    // Subscribe BEFORE sending the upload request.
    // This prevents missing fast backend WebSocket messages.
    ref
        .read(uploadSessionsProvider.notifier)
        .watchUploadStatusBeforeTrack(uploadId: metadataToUpload.uploadId);

    debugPrint(
      '[UploadNotifier] pre-subscribed to upload status: ${metadataToUpload.uploadId}',
    );

    debugPrint('[UploadNotifier] calling repository.uploadTrack()');

    final result = await repository.uploadTrack(metadataToUpload);

    debugPrint('[UploadNotifier] uploadTrack() returned result');

    return result.fold(
      (failure) {
        debugPrint('[UploadNotifier] upload failed');
        debugPrint('[UploadNotifier] failure: ${failure.message}');

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
        debugPrint('[UploadNotifier] upload succeeded');
        debugPrint('[UploadNotifier] backend track id: ${track.id}');
        debugPrint('[UploadNotifier] backend track title: ${track.title}');
        debugPrint('[UploadNotifier] backend track state: ${track.state}');
        debugPrint(
          '[UploadNotifier] backend track isPlayable: ${track.isPlayable}',
        );
        debugPrint(
          '[UploadNotifier] backend track normalizedTrackUrl: ${track.normalizedTrackUrl}',
        );
        debugPrint('[UploadNotifier] calling trackUpload()');
        debugPrint('[UploadNotifier] uploadId: ${metadataToUpload.uploadId}');

        ref
            .read(uploadSessionsProvider.notifier)
            .trackUpload(uploadId: metadataToUpload.uploadId, track: track);

        debugPrint('[UploadNotifier] trackUpload() called');

        ref.read(uploadsProvider.notifier).addTrack(track);

        debugPrint('[UploadNotifier] track added to uploadsProvider');

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

        debugPrint('[UploadNotifier] upload form reset');
        debugPrint('[UploadNotifier] next uploadId: $nextUploadId');

        return true;
      },
    );
  }

  void _updateState(TrackUploadMetadata Function(TrackUploadMetadata) update) {
    debugPrint('[UploadNotifier] _updateState() called');

    if (state.value != null) {
      state = AsyncData(update(state.value!));
      debugPrint('[UploadNotifier] state updated');
    } else {
      debugPrint(
        '[UploadNotifier] _updateState ignored because state.value is null',
      );
    }
  }
}
