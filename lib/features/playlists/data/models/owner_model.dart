import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/playlist.dart';
part 'owner_model.freezed.dart';
part 'owner_model.g.dart';

@freezed
class OwnerModel with _$OwnerModel {
  const factory OwnerModel({
    required int id,
    required String username,
    String? displayName,
    String? avatarUrl,
  }) = _OwnerModel;

  factory OwnerModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerModelFromJson(json);
}

extension OwnerModelX on OwnerModel {
  PlaylistOwner toEntity() => PlaylistOwner(
    id: id,
    username: username,
    displayName: displayName,
    avatarUrl: avatarUrl,
  );
}
