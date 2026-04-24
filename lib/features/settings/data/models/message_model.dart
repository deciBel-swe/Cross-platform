import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/message.dart';
import '../../domain/entities/resource_type.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    String? conversationId,
    required int senderId,
    int? recipientId,
    required String content,
    @JsonEnum(alwaysCreate: true) ResourceType? resourceType,
    int? resourceId,
    @JsonKey(name: 'timestamp', fromJson: _parseCreatedAt)
    required DateTime createdAt,
    @Default(false) bool isRead,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

DateTime _parseCreatedAt(String value) {
  return DateTime.parse('${value}Z').toLocal();
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
