import 'dart:io';

class TrackEditRequest {
  const TrackEditRequest({
    required this.title,
    required this.genre,
    required this.description,
    required this.tags,
    required this.releaseDate,
    required this.isPrivate,
    required this.access,
    this.coverImage,
  });

  final String title;
  final String genre;
  final String description;
  final List<String> tags;
  final DateTime? releaseDate;
  final bool isPrivate;
  final String access;
  final File? coverImage;
}
