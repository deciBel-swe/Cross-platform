import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/artist.dart';

part 'artist_model.freezed.dart';
part 'artist_model.g.dart';

@freezed
class ArtistModel with _$ArtistModel {
  const factory ArtistModel({
    required int id,
    required String username,
    String? displayName,
    String? avatarUrl,
    String? location,
    String? bio,
  }) = _ArtistModel;

  factory ArtistModel.fromJson(Map<String, dynamic> json) =>
      _$ArtistModelFromJson(json);
}

extension ArtistModelX on ArtistModel {
  Artist toEntity() {
    return Artist(
      id: id,
      username: username,
      displayName: displayName,
      avatarUrl: avatarUrl,
      location: location,
      bio: bio,
    );
  }

  static ArtistModel fromEntity(Artist artist) {
    return ArtistModel(
      id: artist.id,
      username: artist.username,
      displayName: artist.displayName,
      avatarUrl: artist.avatarUrl,
      location: artist.location,
      bio: artist.bio,
    );
  }
}
