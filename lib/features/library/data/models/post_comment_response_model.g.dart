// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostCommentResponseModelImpl _$$PostCommentResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$PostCommentResponseModelImpl(
  commentId: (json['id'] as num).toInt(),
  replycount: (json['replycount'] as num?)?.toInt() ?? 0,
  user: CommentUserModel.fromJson(json['user'] as Map<String, dynamic>),
  body: json['body'] as String,
  timestampSeconds: (json['timestampSeconds'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$PostCommentResponseModelImplToJson(
  _$PostCommentResponseModelImpl instance,
) => <String, dynamic>{
  'id': instance.commentId,
  'replycount': instance.replycount,
  'user': instance.user,
  'body': instance.body,
  'timestampSeconds': instance.timestampSeconds,
  'createdAt': instance.createdAt.toIso8601String(),
};
