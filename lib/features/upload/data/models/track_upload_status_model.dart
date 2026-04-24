import '../../../library/data/models/track_model.dart';
import '../../domain/entities/track_upload_status.dart';

class TrackUploadStatusModel {
  const TrackUploadStatusModel({
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
  final TrackModel? trackResponse;

  factory TrackUploadStatusModel.fromJson(Map<String, dynamic> json) {
    final state = _parseState(json['trackState']);
    if (state == null) {
      throw const FormatException('Invalid track upload state payload');
    }

    final progress = _parseInt(json['progressPercentage']) ?? 0;
    final trackResponseJson = json['trackResponse'];

    return TrackUploadStatusModel(
      state: state,
      trackId: _parseInt(json['trackId']),
      progressPercentage: progress.clamp(0, 100),
      stepName: _normalizeString(json['stepName']),
      errorMessage: _normalizeString(json['errorMessage']),
      trackResponse: trackResponseJson is Map<String, dynamic>
          ? TrackModel.fromJson(trackResponseJson)
          : null,
    );
  }

  TrackUploadStatus toEntity() {
    return TrackUploadStatus(
      state: state,
      trackId: trackId,
      progressPercentage: progressPercentage,
      stepName: stepName,
      errorMessage: errorMessage,
      trackResponse: trackResponse?.toEntity(),
    );
  }

  static TrackUploadState? _parseState(Object? value) {
    final normalized = value?.toString().trim().toUpperCase();
    return switch (normalized) {
      'UPLOADING' => TrackUploadState.uploading,
      'PROCESSING' => TrackUploadState.processing,
      'FINISHED' => TrackUploadState.finished,
      'FAILED' => TrackUploadState.failed,
      _ => null,
    };
  }

  static int? _parseInt(Object? value) {
    return switch (value) {
      int parsed => parsed,
      num parsed => parsed.toInt(),
      String parsed => int.tryParse(parsed),
      _ => null,
    };
  }

  static String? _normalizeString(Object? value) {
    final normalized = value?.toString().trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
  }
}
