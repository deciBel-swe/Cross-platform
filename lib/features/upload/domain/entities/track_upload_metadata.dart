import 'dart:io';

class TrackUploadMetadata {
  const TrackUploadMetadata({
    this.audioFile,
    this.coverImage,
    this.title = '',
    this.genre = '',
    this.description = '',
    this.tags = const <String>[],
    this.releaseDate,
    this.isPrivate = false,
    this.waveFormData = const <double>[],
    this.uploadId = '',
    this.access = 'PLAYABLE',
  });

  final File? audioFile;
  final File? coverImage;
  final String title;
  final String genre;
  final String description;
  final List<String> tags;
  final DateTime? releaseDate;
  final bool isPrivate;
  final List<double> waveFormData;
  final String uploadId;
  final String access;

  // Create new instance with updated fields
  TrackUploadMetadata copyWith({
    File? audioFile,
    String? title,
    String? genre,
    bool? isPrivate,
    File? coverImage,
    String? description,
    List<String>? tags,
    DateTime? releaseDate,
    List<double>? waveFormData,
    String? uploadId,
    String? access,
  }) {
    return TrackUploadMetadata(
      audioFile: audioFile ?? this.audioFile,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      isPrivate: isPrivate ?? this.isPrivate,
      coverImage: coverImage ?? this.coverImage,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      releaseDate: releaseDate ?? this.releaseDate,
      waveFormData: waveFormData ?? this.waveFormData,
      uploadId: uploadId ?? this.uploadId,
      access: access ?? this.access,
    );
  }
}
