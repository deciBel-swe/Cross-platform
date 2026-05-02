import 'dart:io';

class TrackEditState {
  const TrackEditState({
    required this.title,
    required this.genre,
    required this.description,
    required this.tags,
    required this.releaseDate,
    required this.isPrivate,
    required this.currentCoverUrl,
    required this.access,
    this.newCoverImage,
    this.removeCover = false,
    this.isSubmitting = false,
  });

  final String title;
  final String genre;
  final String description;
  final List<String> tags;
  final DateTime? releaseDate;
  final bool isPrivate;
  final String? currentCoverUrl;
  final String access;
  final File? newCoverImage;
  final bool removeCover;
  final bool isSubmitting;

  TrackEditState copyWith({
    String? title,
    String? genre,
    String? description,
    List<String>? tags,
    DateTime? releaseDate,
    bool clearReleaseDate = false,
    bool? isPrivate,
    String? currentCoverUrl,
    bool clearCurrentCoverUrl = false,
    String? access,
    File? newCoverImage,
    bool clearNewCoverImage = false,
    bool? removeCover,
    bool? isSubmitting,
  }) {
    return TrackEditState(
      title: title ?? this.title,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      releaseDate: clearReleaseDate ? null : (releaseDate ?? this.releaseDate),
      isPrivate: isPrivate ?? this.isPrivate,
      currentCoverUrl: clearCurrentCoverUrl
          ? null
          : (currentCoverUrl ?? this.currentCoverUrl),
      access: access ?? this.access,
      newCoverImage: clearNewCoverImage
          ? null
          : (newCoverImage ?? this.newCoverImage),
      removeCover: removeCover ?? this.removeCover,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
