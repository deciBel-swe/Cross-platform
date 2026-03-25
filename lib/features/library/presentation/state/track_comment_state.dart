import '../../domain/entities/comment.dart';

class TrackCommentsState {
  const TrackCommentsState({
    this.comments = const [],
    this.selectedTimestampSeconds,
    this.isSubmitting = false,
  });
  final List<Comment> comments;
  final int? selectedTimestampSeconds;
  final bool isSubmitting;

  TrackCommentsState copyWith({
    List<Comment>? comments,
    int? selectedTimestampSeconds,
    bool? isSubmitting,
  }) {
    return TrackCommentsState(
      comments: comments ?? this.comments,
      selectedTimestampSeconds:
          selectedTimestampSeconds ?? this.selectedTimestampSeconds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
