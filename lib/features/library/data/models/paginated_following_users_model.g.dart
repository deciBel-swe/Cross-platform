// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_following_users_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedFollowingUsersModelImpl _$$PaginatedFollowingUsersModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedFollowingUsersModelImpl(
  content: (json['content'] as List<dynamic>)
      .map((e) => FollowingUserModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalElements: (json['totalElements'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  isLast: json['isLast'] as bool,
);

Map<String, dynamic> _$$PaginatedFollowingUsersModelImplToJson(
  _$PaginatedFollowingUsersModelImpl instance,
) => <String, dynamic>{
  'content': instance.content,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'isLast': instance.isLast,
};
