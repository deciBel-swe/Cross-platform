import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/paginated_blocked_users.dart';
import 'blocked_user_model.dart';

part 'paginated_blocked_users_model.freezed.dart';
part 'paginated_blocked_users_model.g.dart';

@freezed
class PaginatedBlockedUsersModel with _$PaginatedBlockedUsersModel {
  const factory PaginatedBlockedUsersModel({
    required List<BlockedUserModel> content,
    required int pageNumber,
    required int pageSize,
    required int totalElements,
    required int totalPages,
    required bool isLast,
  }) = _PaginatedBlockedUsersModel;

  factory PaginatedBlockedUsersModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawContent = json['content'];
    final List<BlockedUserModel> parsedContent =
        (rawContent is List<dynamic> ? rawContent : const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(BlockedUserModel.fromJson)
            .toList();

    return PaginatedBlockedUsersModel(
      content: parsedContent,
      pageNumber: (json['pageNumber'] ?? json['number'] ?? 0) as int,
      pageSize: (json['pageSize'] ?? json['size'] ?? 20) as int,
      totalElements: (json['totalElements'] ?? 0) as int,
      totalPages: (json['totalPages'] ?? 1) as int,
      isLast: (json['isLast'] ?? json['last'] ?? true) as bool,
    );
  }
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
