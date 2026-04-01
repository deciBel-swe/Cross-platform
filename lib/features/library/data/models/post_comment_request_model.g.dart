// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostCommentRequestModelImpl _$$PostCommentRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$PostCommentRequestModelImpl(
  body: json['body'] as String,
  timeStampseconds: (json['timestampSeconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$$PostCommentRequestModelImplToJson(
  _$PostCommentRequestModelImpl instance,
) => <String, dynamic>{
  'body': instance.body,
  'timestampSeconds': instance.timeStampseconds,
};
