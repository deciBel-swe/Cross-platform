// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_following_users_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedFollowingUsersModelImpl _$$PaginatedFollowingUsersModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedFollowingUsersModelImpl(
  content:
      (json['content'] as List<dynamic>?)
          ?.map((e) => FollowingUserModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  pageNumber: _readPageNumber(json, 'pageNumber') == null
      ? 0
      : _toInt(_readPageNumber(json, 'pageNumber')),
  pageSize: _readPageSize(json, 'pageSize') == null
      ? 20
      : _toInt(_readPageSize(json, 'pageSize')),
  totalElements: json['totalElements'] == null
      ? 0
      : _toInt(json['totalElements']),
  totalPages: json['totalPages'] == null ? 1 : _toInt(json['totalPages']),
  isLast: _readIsLast(json, 'isLast') == null
      ? true
      : _toBool(_readIsLast(json, 'isLast')),
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
