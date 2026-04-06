// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_blocked_users_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedBlockedUsersModelImpl _$$PaginatedBlockedUsersModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedBlockedUsersModelImpl(
  content: (json['content'] as List<dynamic>)
      .map((e) => BlockedUserModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalElements: (json['totalElements'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  isLast: json['isLast'] as bool,
);

Map<String, dynamic> _$$PaginatedBlockedUsersModelImplToJson(
  _$PaginatedBlockedUsersModelImpl instance,
) => <String, dynamic>{
  'content': instance.content,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'isLast': instance.isLast,
};
