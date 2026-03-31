// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_comments_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginatedCommentsResponseModel _$PaginatedCommentsResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _PaginatedCommentsResponseModel.fromJson(json);
}

/// @nodoc
mixin _$PaginatedCommentsResponseModel {
  List<PostCommentResponseModel> get content =>
      throw _privateConstructorUsedError;
  int? get pageNumber => throw _privateConstructorUsedError;
  int? get pageSize => throw _privateConstructorUsedError;
  int? get totalElements => throw _privateConstructorUsedError;
  int? get totalPages => throw _privateConstructorUsedError;
  bool? get isLast => throw _privateConstructorUsedError;

  /// Serializes this PaginatedCommentsResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedCommentsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedCommentsResponseModelCopyWith<PaginatedCommentsResponseModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedCommentsResponseModelCopyWith<$Res> {
  factory $PaginatedCommentsResponseModelCopyWith(
    PaginatedCommentsResponseModel value,
    $Res Function(PaginatedCommentsResponseModel) then,
  ) =
      _$PaginatedCommentsResponseModelCopyWithImpl<
        $Res,
        PaginatedCommentsResponseModel
      >;
  @useResult
  $Res call({
    List<PostCommentResponseModel> content,
    int? pageNumber,
    int? pageSize,
    int? totalElements,
    int? totalPages,
    bool? isLast,
  });
}

/// @nodoc
class _$PaginatedCommentsResponseModelCopyWithImpl<
  $Res,
  $Val extends PaginatedCommentsResponseModel
>
    implements $PaginatedCommentsResponseModelCopyWith<$Res> {
  _$PaginatedCommentsResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedCommentsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? pageNumber = freezed,
    Object? pageSize = freezed,
    Object? totalElements = freezed,
    Object? totalPages = freezed,
    Object? isLast = freezed,
  }) {
    return _then(
      _value.copyWith(
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as List<PostCommentResponseModel>,
            pageNumber: freezed == pageNumber
                ? _value.pageNumber
                : pageNumber // ignore: cast_nullable_to_non_nullable
                      as int?,
            pageSize: freezed == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalElements: freezed == totalElements
                ? _value.totalElements
                : totalElements // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalPages: freezed == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int?,
            isLast: freezed == isLast
                ? _value.isLast
                : isLast // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedCommentsResponseModelImplCopyWith<$Res>
    implements $PaginatedCommentsResponseModelCopyWith<$Res> {
  factory _$$PaginatedCommentsResponseModelImplCopyWith(
    _$PaginatedCommentsResponseModelImpl value,
    $Res Function(_$PaginatedCommentsResponseModelImpl) then,
  ) = __$$PaginatedCommentsResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PostCommentResponseModel> content,
    int? pageNumber,
    int? pageSize,
    int? totalElements,
    int? totalPages,
    bool? isLast,
  });
}

/// @nodoc
class __$$PaginatedCommentsResponseModelImplCopyWithImpl<$Res>
    extends
        _$PaginatedCommentsResponseModelCopyWithImpl<
          $Res,
          _$PaginatedCommentsResponseModelImpl
        >
    implements _$$PaginatedCommentsResponseModelImplCopyWith<$Res> {
  __$$PaginatedCommentsResponseModelImplCopyWithImpl(
    _$PaginatedCommentsResponseModelImpl _value,
    $Res Function(_$PaginatedCommentsResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedCommentsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? pageNumber = freezed,
    Object? pageSize = freezed,
    Object? totalElements = freezed,
    Object? totalPages = freezed,
    Object? isLast = freezed,
  }) {
    return _then(
      _$PaginatedCommentsResponseModelImpl(
        content: null == content
            ? _value._content
            : content // ignore: cast_nullable_to_non_nullable
                  as List<PostCommentResponseModel>,
        pageNumber: freezed == pageNumber
            ? _value.pageNumber
            : pageNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
        pageSize: freezed == pageSize
            ? _value.pageSize
            : pageSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalElements: freezed == totalElements
            ? _value.totalElements
            : totalElements // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalPages: freezed == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int?,
        isLast: freezed == isLast
            ? _value.isLast
            : isLast // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedCommentsResponseModelImpl
    implements _PaginatedCommentsResponseModel {
  const _$PaginatedCommentsResponseModelImpl({
    final List<PostCommentResponseModel> content = const [],
    this.pageNumber,
    this.pageSize,
    this.totalElements,
    this.totalPages,
    this.isLast,
  }) : _content = content;

  factory _$PaginatedCommentsResponseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$PaginatedCommentsResponseModelImplFromJson(json);

  final List<PostCommentResponseModel> _content;
  @override
  @JsonKey()
  List<PostCommentResponseModel> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  @override
  final int? pageNumber;
  @override
  final int? pageSize;
  @override
  final int? totalElements;
  @override
  final int? totalPages;
  @override
  final bool? isLast;

  @override
  String toString() {
    return 'PaginatedCommentsResponseModel(content: $content, pageNumber: $pageNumber, pageSize: $pageSize, totalElements: $totalElements, totalPages: $totalPages, isLast: $isLast)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedCommentsResponseModelImpl &&
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

  /// Create a copy of PaginatedCommentsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedCommentsResponseModelImplCopyWith<
    _$PaginatedCommentsResponseModelImpl
  >
  get copyWith =>
      __$$PaginatedCommentsResponseModelImplCopyWithImpl<
        _$PaginatedCommentsResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedCommentsResponseModelImplToJson(this);
  }
}

abstract class _PaginatedCommentsResponseModel
    implements PaginatedCommentsResponseModel {
  const factory _PaginatedCommentsResponseModel({
    final List<PostCommentResponseModel> content,
    final int? pageNumber,
    final int? pageSize,
    final int? totalElements,
    final int? totalPages,
    final bool? isLast,
  }) = _$PaginatedCommentsResponseModelImpl;

  factory _PaginatedCommentsResponseModel.fromJson(Map<String, dynamic> json) =
      _$PaginatedCommentsResponseModelImpl.fromJson;

  @override
  List<PostCommentResponseModel> get content;
  @override
  int? get pageNumber;
  @override
  int? get pageSize;
  @override
  int? get totalElements;
  @override
  int? get totalPages;
  @override
  bool? get isLast;

  /// Create a copy of PaginatedCommentsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedCommentsResponseModelImplCopyWith<
    _$PaginatedCommentsResponseModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
