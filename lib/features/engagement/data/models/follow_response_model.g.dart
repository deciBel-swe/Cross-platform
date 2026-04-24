// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FollowResponseModelImpl _$$FollowResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$FollowResponseModelImpl(
  message: json['message'] as String,
  isFollowing: json['isFollowing'] as bool,
);

Map<String, dynamic> _$$FollowResponseModelImplToJson(
  _$FollowResponseModelImpl instance,
) => <String, dynamic>{
  'message': instance.message,
  'isFollowing': instance.isFollowing,
};
