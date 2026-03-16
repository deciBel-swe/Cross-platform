import 'dart:io';

class TrackUploadMetadata {

  const TrackUploadMetadata({
    this.audioFile,
    this.coverImage,
    this.title = '',
    this.genre = '',
    this.description = '',
    this.tags = const [],
    this.releasedDate,
    this.isPrivate = false,
  });
  final File? audioFile;
  final File? coverImage;
  final String title;
  final String genre;
  final String description;
  final List<String> tags;
  final DateTime? releasedDate;
  final bool isPrivate;

  // Create new instance with updated fields
  TrackUploadMetadata copyWith({
    File? audioFile,
    File? coverImage,
    String? title,
    String? genre,
    String? description,
    List<String>? tags,
    DateTime? releaseDate,
    bool? isPrivate,
  }) {
    return TrackUploadMetadata(
      audioFile: audioFile ?? this.audioFile,
      coverImage: coverImage ?? this.coverImage,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      releasedDate: releaseDate ?? releasedDate,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
