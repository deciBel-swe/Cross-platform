// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String?,
      senderId: (json['senderId'] as num).toInt(),
      recipientId: (json['recipientId'] as num?)?.toInt(),
      content: json['content'] as String,
      resourceType: $enumDecodeNullable(
        _$ResourceTypeEnumMap,
        json['resourceType'],
      ),
      resourceId: (json['resourceId'] as num?)?.toInt(),
      createdAt: _parseCreatedAt(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'recipientId': instance.recipientId,
      'content': instance.content,
      'resourceType': _$ResourceTypeEnumMap[instance.resourceType],
      'resourceId': instance.resourceId,
      'timestamp': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
    };

const _$ResourceTypeEnumMap = {
  ResourceType.track: 'track',
  ResourceType.playlist: 'playlist',
};
