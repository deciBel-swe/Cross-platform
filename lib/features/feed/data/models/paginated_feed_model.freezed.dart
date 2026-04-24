// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_feed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginatedFeedModel _$PaginatedFeedModelFromJson(Map<String, dynamic> json) {
  return _PaginatedFeedModel.fromJson(json);
}

/// @nodoc
mixin _$PaginatedFeedModel {
  @JsonKey(fromJson: _tracksFromJson, toJson: _tracksToJson)
  List<FeedTrackModel> get content => throw _privateConstructorUsedError;
  int get pageNumber => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get isLast => throw _privateConstructorUsedError;

  /// Serializes this PaginatedFeedModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedFeedModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedFeedModelCopyWith<PaginatedFeedModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedFeedModelCopyWith<$Res> {
  factory $PaginatedFeedModelCopyWith(
    PaginatedFeedModel value,
    $Res Function(PaginatedFeedModel) then,
  ) = _$PaginatedFeedModelCopyWithImpl<$Res, PaginatedFeedModel>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _tracksFromJson, toJson: _tracksToJson)
    List<FeedTrackModel> content,
    int pageNumber,
    int pageSize,
    int totalElements,
    int totalPages,
    bool isLast,
  });
}

/// @nodoc
class _$PaginatedFeedModelCopyWithImpl<$Res, $Val extends PaginatedFeedModel>
    implements $PaginatedFeedModelCopyWith<$Res> {
  _$PaginatedFeedModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedFeedModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? pageNumber = null,
    Object? pageSize = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? isLast = null,
  }) {
    return _then(
      _value.copyWith(
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as List<FeedTrackModel>,
            pageNumber: null == pageNumber
                ? _value.pageNumber
                : pageNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            pageSize: null == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                      as int,
            totalElements: null == totalElements
                ? _value.totalElements
                : totalElements // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            isLast: null == isLast
                ? _value.isLast
                : isLast // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedFeedModelImplCopyWith<$Res>
    implements $PaginatedFeedModelCopyWith<$Res> {
  factory _$$PaginatedFeedModelImplCopyWith(
    _$PaginatedFeedModelImpl value,
    $Res Function(_$PaginatedFeedModelImpl) then,
  ) = __$$PaginatedFeedModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _tracksFromJson, toJson: _tracksToJson)
    List<FeedTrackModel> content,
    int pageNumber,
    int pageSize,
    int totalElements,
    int totalPages,
    bool isLast,
  });
}

/// @nodoc
class __$$PaginatedFeedModelImplCopyWithImpl<$Res>
    extends _$PaginatedFeedModelCopyWithImpl<$Res, _$PaginatedFeedModelImpl>
    implements _$$PaginatedFeedModelImplCopyWith<$Res> {
  __$$PaginatedFeedModelImplCopyWithImpl(
    _$PaginatedFeedModelImpl _value,
    $Res Function(_$PaginatedFeedModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedFeedModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? pageNumber = null,
    Object? pageSize = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? isLast = null,
  }) {
    return _then(
      _$PaginatedFeedModelImpl(
        content: null == content
            ? _value._content
            : content // ignore: cast_nullable_to_non_nullable
                  as List<FeedTrackModel>,
        pageNumber: null == pageNumber
            ? _value.pageNumber
            : pageNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        pageSize: null == pageSize
            ? _value.pageSize
            : pageSize // ignore: cast_nullable_to_non_nullable
                  as int,
        totalElements: null == totalElements
            ? _value.totalElements
            : totalElements // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        isLast: null == isLast
            ? _value.isLast
            : isLast // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$PaginatedFeedModelImpl implements _PaginatedFeedModel {
  const _$PaginatedFeedModelImpl({
    @JsonKey(fromJson: _tracksFromJson, toJson: _tracksToJson)
    final List<FeedTrackModel> content = const <FeedTrackModel>[],
    this.pageNumber = 0,
    this.pageSize = 0,
    this.totalElements = 0,
    this.totalPages = 0,
    this.isLast = true,
  }) : _content = content;

  factory _$PaginatedFeedModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedFeedModelImplFromJson(json);

  final List<FeedTrackModel> _content;
  @override
  @JsonKey(fromJson: _tracksFromJson, toJson: _tracksToJson)
  List<FeedTrackModel> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  @override
  @JsonKey()
  final int pageNumber;
  @override
  @JsonKey()
  final int pageSize;
  @override
  @JsonKey()
  final int totalElements;
  @override
  @JsonKey()
  final int totalPages;
  @override
  @JsonKey()
  final bool isLast;

  @override
  String toString() {
    return 'PaginatedFeedModel(content: $content, pageNumber: $pageNumber, pageSize: $pageSize, totalElements: $totalElements, totalPages: $totalPages, isLast: $isLast)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedFeedModelImpl &&
            const DeepCollectionEquality().equals(other._content, _content) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalElements, totalElements) ||
                other.totalElements == totalElements) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.isLast, isLast) || other.isLast == isLast));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_content),
    pageNumber,
    pageSize,
    totalElements,
    totalPages,
    isLast,
  );

  /// Create a copy of PaginatedFeedModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedFeedModelImplCopyWith<_$PaginatedFeedModelImpl> get copyWith =>
      __$$PaginatedFeedModelImplCopyWithImpl<_$PaginatedFeedModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedFeedModelImplToJson(this);
  }
}

abstract class _PaginatedFeedModel implements PaginatedFeedModel {
  const factory _PaginatedFeedModel({
    @JsonKey(fromJson: _tracksFromJson, toJson: _tracksToJson)
    final List<FeedTrackModel> content,
    final int pageNumber,
    final int pageSize,
    final int totalElements,
    final int totalPages,
    final bool isLast,
  }) = _$PaginatedFeedModelImpl;

  factory _PaginatedFeedModel.fromJson(Map<String, dynamic> json) =
      _$PaginatedFeedModelImpl.fromJson;

  @override
  @JsonKey(fromJson: _tracksFromJson, toJson: _tracksToJson)
  List<FeedTrackModel> get content;
  @override
  int get pageNumber;
  @override
  int get pageSize;
  @override
  int get totalElements;
  @override
  int get totalPages;
  @override
  bool get isLast;

  /// Create a copy of PaginatedFeedModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedFeedModelImplCopyWith<_$PaginatedFeedModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
