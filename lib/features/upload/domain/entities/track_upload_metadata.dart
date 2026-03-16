import 'dart:io';

class TrackUploadMetadata{
  final File? audioFile;
  final File? coverImage;
  final String title;
  final String genre;
  final String description;
  final List<String> tags;
  final DateTime? releaseDate;
  final bool isPrivate;
  final List<String> waveFormData;

  const TrackUploadMetadata({
    this.audioFile,
    this.coverImage,
    this.title = '',
    this.genre = '',
    this.description = '',
    this.tags = const [],
    this.releaseDate,
    this.isPrivate = false,
    this.waveFormData = const [],
  });

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
    List<String>? waveFormData,
  }) {
    return TrackUploadMetadata(
      audioFile: audioFile ?? this.audioFile,
      coverImage: coverImage ?? this.coverImage,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      releaseDate: releaseDate ?? this.releaseDate,
      isPrivate: isPrivate ?? this.isPrivate,
      waveFormData: waveFormData ?? this.waveFormData,
    );
  }
}