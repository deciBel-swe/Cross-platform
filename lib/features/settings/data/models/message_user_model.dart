import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/message_user.dart';

part 'message_user_model.freezed.dart';
part 'message_user_model.g.dart';

@freezed
class MessageUserModel with _$MessageUserModel {
  const factory MessageUserModel({required int id, required String username}) =
      _MessageUserModel;

  factory MessageUserModel.fromJson(Map<String, dynamic> json) =>
      _$MessageUserModelFromJson(json);
}

extension MessageUserModelX on MessageUserModel {
  MessageUser toEntity() => MessageUser(id: id, username: username);
}
