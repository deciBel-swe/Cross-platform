import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadProgressState {
  const UploadProgressState({
    this.isUploading = false,
    this.isProcessing = false,
    this.progressPercent = 0.0,
  });

  final bool isUploading;
  final bool isProcessing;
  final double progressPercent; // 0.0 to 100.0

  UploadProgressState copyWith({
    bool? isUploading,
    bool? isProcessing,
    double? progressPercent,
  }) {
    return UploadProgressState(
      isUploading: isUploading ?? this.isUploading,
      isProcessing: isProcessing ?? this.isProcessing,
      progressPercent: progressPercent ?? this.progressPercent,
    );
  }
}

class GlobalUploadProgressNotifier extends Notifier<UploadProgressState> {
  @override
  UploadProgressState build() {
    return const UploadProgressState();
  }

  void startUpload() {
    state = const UploadProgressState(isUploading: true, progressPercent: 0.0);
  }

  void updateUploadProgress(double percent) {
    if (state.isUploading) {
      state = state.copyWith(progressPercent: percent);
    }
  }

  void startProcessing() {
    // Phase 2: Wait for backend processing via WebSocket
    state = state.copyWith(
      isUploading: false,
      isProcessing: true,
      progressPercent: 0.0,
    );
  }

  void updateProcessingProgress(double percent) {
    if (state.isProcessing) {
      state = state.copyWith(progressPercent: percent);
    }
  }

  void finish() {
    state = const UploadProgressState();
  }

  void error() {
    state = const UploadProgressState();
  }
}

final globalUploadProgressProvider =
    NotifierProvider<GlobalUploadProgressNotifier, UploadProgressState>(
      GlobalUploadProgressNotifier.new,
    );
