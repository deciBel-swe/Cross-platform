// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentReplyModelImpl _$$CommentReplyModelImplFromJson(
  Map<String, dynamic> json,
) => _$CommentReplyModelImpl(
  commentId: (json['id'] as num).toInt(),
  user: CommentUserModel.fromJson(json['user'] as Map<String, dynamic>),
  body: json['body'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$CommentReplyModelImplToJson(
  _$CommentReplyModelImpl instance,
) => <String, dynamic>{
  'id': instance.commentId,
  'user': instance.user,
  'body': instance.body,
  'createdAt': instance.createdAt?.toIso8601String(),
};
