// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostCommentResponseModelImpl _$$PostCommentResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$PostCommentResponseModelImpl(
  id: (json['id'] as num).toInt(),
  user: CommentUserModel.fromJson(json['user'] as Map<String, dynamic>),
  body: json['body'] as String,
  timestampSeconds: (json['timestampSeconds'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$PostCommentResponseModelImplToJson(
  _$PostCommentResponseModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user': instance.user,
  'body': instance.body,
  'timestampSeconds': instance.timestampSeconds,
  'createdAt': instance.createdAt.toIso8601String(),
};
