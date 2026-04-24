import '../../../library/domain/entities/track.dart';

enum TrackUploadState { uploading, processing, finished, failed }

class TrackUploadStatus {
  const TrackUploadStatus({
    required this.state,
    this.trackId,
    required this.progressPercentage,
    this.stepName,
    this.errorMessage,
    this.trackResponse,
  });

  final TrackUploadState state;
  final int? trackId;
  final int progressPercentage;
  final String? stepName;
  final String? errorMessage;
  final Track? trackResponse;

  bool get isActive =>
      state == TrackUploadState.uploading ||
      state == TrackUploadState.processing;

  bool get isTerminal =>
      state == TrackUploadState.finished || state == TrackUploadState.failed;
}
