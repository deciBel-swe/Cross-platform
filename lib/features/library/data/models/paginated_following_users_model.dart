import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/paginated_following_users.dart';
import 'following_user_model.dart';

part 'paginated_following_users_model.freezed.dart';
part 'paginated_following_users_model.g.dart';

@freezed
class PaginatedFollowingUsersModel with _$PaginatedFollowingUsersModel {
  const factory PaginatedFollowingUsersModel({
    required List<FollowingUserModel> content,
    required int pageNumber,
    required int pageSize,
    required int totalElements,
    required int totalPages,
    required bool isLast,
  }) = _PaginatedFollowingUsersModel;

  factory PaginatedFollowingUsersModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PaginatedFollowingUsersModelFromJson(json);
}

extension PaginatedFollowingUsersMapper on PaginatedFollowingUsersModel {
  PaginatedFollowingUsers toEntity() {
    return PaginatedFollowingUsers(
      content: content.map((e) => e.toEntity()).toList(),
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      totalPages: totalPages,
      isLast: isLast,
    );
  }
}