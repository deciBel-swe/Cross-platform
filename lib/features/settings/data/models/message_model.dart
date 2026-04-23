import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/message.dart';
import '../../domain/entities/resource_type.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required int id,
    required int conversationId,
    required int senderId,
    required String content,
    @JsonEnum(alwaysCreate: true) ResourceType? resourceType,
    int? resourceId,
    required DateTime createdAt,
    @Default(false) bool isRead,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

extension MessageModelX on MessageModel {
  Message toEntity() => Message(
    id: id,
    conversationId: conversationId,
    senderId: senderId,
    content: content,
    resourceType: resourceType,
    resourceId: resourceId,
    createdAt: createdAt,
    isRead: isRead,
  );
}
