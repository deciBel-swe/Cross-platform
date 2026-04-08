import 'dart:io';

class PlaylistMetadata {
  const PlaylistMetadata({
    this.coverImage,
    this.title = '',
    this.description = '',
    this.isPrivate = true,
  });

  final File? coverImage;
  final String title;
  final String description;
  final bool isPrivate;

  // Create new instance with updated fields
  PlaylistMetadata copyWith({
    File? coverImage,
    String? title,
    String? description,
    bool? isPrivate,
  }) {
    return PlaylistMetadata(
      coverImage: coverImage ?? this.coverImage,
      title: title ?? this.title,
      description: description ?? this.description,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
