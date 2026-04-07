import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/paginated_blocked_users.dart';
import 'blocked_user_model.dart';

part 'paginated_blocked_users_model.freezed.dart';
part 'paginated_blocked_users_model.g.dart';

@freezed
class PaginatedBlockedUsersModel with _$PaginatedBlockedUsersModel {
  const factory PaginatedBlockedUsersModel({
    @JsonKey(defaultValue: <BlockedUserModel>[])
    required List<BlockedUserModel> content,
    @JsonKey(readValue: _readPageNumber, fromJson: _toInt, defaultValue: 0)
    required int pageNumber,
    @JsonKey(readValue: _readPageSize, fromJson: _toInt, defaultValue: 20)
    required int pageSize,
    @JsonKey(fromJson: _toInt, defaultValue: 0) required int totalElements,
    @JsonKey(fromJson: _toInt, defaultValue: 1) required int totalPages,
    @JsonKey(readValue: _readIsLast, fromJson: _toBool, defaultValue: true)
    required bool isLast,
  }) = _PaginatedBlockedUsersModel;

  factory PaginatedBlockedUsersModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedBlockedUsersModelFromJson(json);
}

Object? _readPageNumber(Map json, String key) =>
    json['pageNumber'] ?? json['number'];
Object? _readPageSize(Map json, String key) => json['pageSize'] ?? json['size'];
Object? _readIsLast(Map json, String key) => json['isLast'] ?? json['last'];

int _toInt(Object? value) => (value as num?)?.toInt() ?? 0;

bool _toBool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) return value.toLowerCase() == 'true';
  return false;
}

extension PaginatedBlockedUsersModelMapper on PaginatedBlockedUsersModel {
  PaginatedBlockedUsers toEntity() {
    return PaginatedBlockedUsers(
      content: content.map((e) => e.toEntity()).toList(),
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      totalPages: totalPages,
      isLast: isLast,
    );
  }
}
