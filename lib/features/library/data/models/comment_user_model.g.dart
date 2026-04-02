// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentUserModelImpl _$$CommentUserModelImplFromJson(
  Map<String, dynamic> json,
) => _$CommentUserModelImpl(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$$CommentUserModelImplToJson(
  _$CommentUserModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'avatarUrl': instance.avatarUrl,
};
