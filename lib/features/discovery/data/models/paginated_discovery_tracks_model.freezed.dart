// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_discovery_tracks_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginatedDiscoveryTracksModel _$PaginatedDiscoveryTracksModelFromJson(
  Map<String, dynamic> json,
) {
  return _PaginatedDiscoveryTracksModel.fromJson(json);
}

/// @nodoc
mixin _$PaginatedDiscoveryTracksModel {
  List<DiscoveryTrackModel> get content => throw _privateConstructorUsedError;
  int get pageNumber => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get isLast => throw _privateConstructorUsedError;

  /// Serializes this PaginatedDiscoveryTracksModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedDiscoveryTracksModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedDiscoveryTracksModelCopyWith<PaginatedDiscoveryTracksModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedDiscoveryTracksModelCopyWith<$Res> {
  factory $PaginatedDiscoveryTracksModelCopyWith(
    PaginatedDiscoveryTracksModel value,
    $Res Function(PaginatedDiscoveryTracksModel) then,
  ) =
      _$PaginatedDiscoveryTracksModelCopyWithImpl<
        $Res,
        PaginatedDiscoveryTracksModel
      >;
  @useResult
  $Res call({
    List<DiscoveryTrackModel> content,
    int pageNumber,
    int pageSize,
    int totalElements,
    int totalPages,
    bool isLast,
  });
}

/// @nodoc
class _$PaginatedDiscoveryTracksModelCopyWithImpl<
  $Res,
  $Val extends PaginatedDiscoveryTracksModel
>
    implements $PaginatedDiscoveryTracksModelCopyWith<$Res> {
  _$PaginatedDiscoveryTracksModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedDiscoveryTracksModel
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
                      as List<DiscoveryTrackModel>,
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
abstract class _$$PaginatedDiscoveryTracksModelImplCopyWith<$Res>
    implements $PaginatedDiscoveryTracksModelCopyWith<$Res> {
  factory _$$PaginatedDiscoveryTracksModelImplCopyWith(
    _$PaginatedDiscoveryTracksModelImpl value,
    $Res Function(_$PaginatedDiscoveryTracksModelImpl) then,
  ) = __$$PaginatedDiscoveryTracksModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<DiscoveryTrackModel> content,
    int pageNumber,
    int pageSize,
    int totalElements,
    int totalPages,
    bool isLast,
  });
}

/// @nodoc
class __$$PaginatedDiscoveryTracksModelImplCopyWithImpl<$Res>
    extends
        _$PaginatedDiscoveryTracksModelCopyWithImpl<
          $Res,
          _$PaginatedDiscoveryTracksModelImpl
        >
    implements _$$PaginatedDiscoveryTracksModelImplCopyWith<$Res> {
  __$$PaginatedDiscoveryTracksModelImplCopyWithImpl(
    _$PaginatedDiscoveryTracksModelImpl _value,
    $Res Function(_$PaginatedDiscoveryTracksModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedDiscoveryTracksModel
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
      _$PaginatedDiscoveryTracksModelImpl(
        content: null == content
            ? _value._content
            : content // ignore: cast_nullable_to_non_nullable
                  as List<DiscoveryTrackModel>,
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
@JsonSerializable()
class _$PaginatedDiscoveryTracksModelImpl
    implements _PaginatedDiscoveryTracksModel {
  const _$PaginatedDiscoveryTracksModelImpl({
    final List<DiscoveryTrackModel> content = const <DiscoveryTrackModel>[],
    this.pageNumber = 0,
    this.pageSize = 0,
    this.totalElements = 0,
    this.totalPages = 0,
    this.isLast = true,
  }) : _content = content;

  factory _$PaginatedDiscoveryTracksModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$PaginatedDiscoveryTracksModelImplFromJson(json);

  final List<DiscoveryTrackModel> _content;
  @override
  @JsonKey()
  List<DiscoveryTrackModel> get content {
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
    return 'PaginatedDiscoveryTracksModel(content: $content, pageNumber: $pageNumber, pageSize: $pageSize, totalElements: $totalElements, totalPages: $totalPages, isLast: $isLast)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedDiscoveryTracksModelImpl &&
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

  /// Create a copy of PaginatedDiscoveryTracksModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedDiscoveryTracksModelImplCopyWith<
    _$PaginatedDiscoveryTracksModelImpl
  >
  get copyWith =>
      __$$PaginatedDiscoveryTracksModelImplCopyWithImpl<
        _$PaginatedDiscoveryTracksModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedDiscoveryTracksModelImplToJson(this);
  }
}

abstract class _PaginatedDiscoveryTracksModel
    implements PaginatedDiscoveryTracksModel {
  const factory _PaginatedDiscoveryTracksModel({
    final List<DiscoveryTrackModel> content,
    final int pageNumber,
    final int pageSize,
    final int totalElements,
    final int totalPages,
    final bool isLast,
  }) = _$PaginatedDiscoveryTracksModelImpl;

  factory _PaginatedDiscoveryTracksModel.fromJson(Map<String, dynamic> json) =
      _$PaginatedDiscoveryTracksModelImpl.fromJson;

  @override
  List<DiscoveryTrackModel> get content;
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

  /// Create a copy of PaginatedDiscoveryTracksModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedDiscoveryTracksModelImplCopyWith<
    _$PaginatedDiscoveryTracksModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
