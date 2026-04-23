// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationModelImpl _$$ConversationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationModelImpl(
  id: (json['id'] as num).toInt(),
  user1: MessageUserModel.fromJson(json['user1'] as Map<String, dynamic>),
  user2: MessageUserModel.fromJson(json['user2'] as Map<String, dynamic>),
  unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
  lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
);

Map<String, dynamic> _$$ConversationModelImplToJson(
  _$ConversationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user1': instance.user1,
  'user2': instance.user2,
  'unreadCount': instance.unreadCount,
  'lastMessageAt': instance.lastMessageAt.toIso8601String(),
};
