import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/conversation.dart';
import 'message_user_model.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required int id,
    required MessageUserModel user1,
    required MessageUserModel user2,
    @Default(0) int unreadCount,
    required DateTime lastMessageAt,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
}

extension ConversationModelX on ConversationModel {
  Conversation toEntity() => Conversation(
    id: id,
    user1: user1.toEntity(),
    user2: user2.toEntity(),
    unreadCount: unreadCount,
    lastMessageAt: lastMessageAt,
  );
}
