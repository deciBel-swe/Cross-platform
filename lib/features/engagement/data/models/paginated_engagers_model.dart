import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/paginated_engagers.dart';
import 'track_engager_model.dart';

part 'paginated_engagers_model.freezed.dart';
part 'paginated_engagers_model.g.dart';

@freezed
class PaginatedEngagersModel with _$PaginatedEngagersModel {
  const factory PaginatedEngagersModel({
    @Default(<TrackEngagerModel>[]) List<TrackEngagerModel> content,
    required int pageNumber,
    required int pageSize,
    required int totalElements,
    required int totalPages,
    required bool isLast,
  }) = _PaginatedEngagersModel;

  factory PaginatedEngagersModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedEngagersModelFromJson(json);
}

extension PaginatedEngagersModelX on PaginatedEngagersModel {
  PaginatedEngagers toEntity() {
    return PaginatedEngagers(
      content: content.map((model) => model.toEntity()).toList(),
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      totalPages: totalPages,
      isLast: isLast,
    );
  }
}
