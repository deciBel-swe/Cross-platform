import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist_model.freezed.dart';
part 'artist_model.g.dart';

@freezed
class ArtistModel with _$ArtistModel {
  const factory ArtistModel({required int id, required String username}) =
      _ArtistModel;

  factory ArtistModel.fromJson(Map<String, dynamic> json) =>
      _$ArtistModelFromJson(json);
}
