import '../../domain/entities/repost_history.dart';

class RepostHistoryItemModel {
  const RepostHistoryItemModel({
    required this.type,
    required this.id,
    required this.title,
    this.coverUrl,
  });

  static RepostHistoryItemModel? tryFromJson(Map<String, dynamic> json) {
    final type = (json['type'] as String? ?? '').trim().toUpperCase();
    final id = _asInt(json['id']);
    if (id == null || id <= 0 || (type != 'TRACK' && type != 'PLAYLIST')) {
      return null;
    }

    return RepostHistoryItemModel(
      type: type,
      id: id,
      title: _asString(json['title']) ?? 'Untitled',
      coverUrl:
          _asString(json['coverUrl']) ??
          _asString(json['coverArtUrl']) ??
          _asString(json['cover_url']) ??
          _asString(json['cover url']),
    );
  }

  final String type;
  final int id;
  final String title;
  final String? coverUrl;

  RepostHistoryItem toEntity() {
    return RepostHistoryItem(
      type: type == 'PLAYLIST'
          ? RepostHistoryItemType.playlist
          : RepostHistoryItemType.track,
      id: id,
      title: title,
      coverUrl: coverUrl,
    );
  }
}

class PaginatedRepostHistoryModel {
  const PaginatedRepostHistoryModel({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  });

  factory PaginatedRepostHistoryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final source = data is Map<Object?, Object?>
        ? Map<String, dynamic>.from(data)
        : json;
    final content = source['content'];
    final contentItems = content is List
        ? content
              .whereType<Map<Object?, Object?>>()
              .map(
                (item) => RepostHistoryItemModel.tryFromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .whereType<RepostHistoryItemModel>()
              .toList()
        : const <RepostHistoryItemModel>[];

    return PaginatedRepostHistoryModel(
      content: contentItems,
      pageNumber: _asInt(source['pageNumber']) ?? _asInt(source['number']) ?? 0,
      pageSize: _asInt(source['pageSize']) ?? _asInt(source['size']) ?? 20,
      totalElements: _asInt(source['totalElements']) ?? contentItems.length,
      totalPages: _asInt(source['totalPages']) ?? 1,
      isLast: source['isLast'] as bool? ?? source['last'] as bool? ?? true,
    );
  }

  final List<RepostHistoryItemModel> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;

  PaginatedRepostHistory toEntity() {
    return PaginatedRepostHistory(
      content: content.map((item) => item.toEntity()).toList(),
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalElements: totalElements,
      totalPages: totalPages,
      isLast: isLast,
    );
  }
}

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

String? _asString(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}
