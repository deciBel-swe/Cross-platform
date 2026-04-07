// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_blocked_users_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginatedBlockedUsersModel _$PaginatedBlockedUsersModelFromJson(
  Map<String, dynamic> json,
) {
  return _PaginatedBlockedUsersModel.fromJson(json);
}

/// @nodoc
mixin _$PaginatedBlockedUsersModel {
  @JsonKey(defaultValue: <BlockedUserModel>[])
  List<BlockedUserModel> get content => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readPageNumber, fromJson: _toInt, defaultValue: 0)
  int get pageNumber => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readPageSize, fromJson: _toInt, defaultValue: 20)
  int get pageSize => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toInt, defaultValue: 0)
  int get totalElements => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toInt, defaultValue: 1)
  int get totalPages => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readIsLast, fromJson: _toBool, defaultValue: true)
  bool get isLast => throw _privateConstructorUsedError;

  /// Serializes this PaginatedBlockedUsersModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedBlockedUsersModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedBlockedUsersModelCopyWith<PaginatedBlockedUsersModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedBlockedUsersModelCopyWith<$Res> {
  factory $PaginatedBlockedUsersModelCopyWith(
    PaginatedBlockedUsersModel value,
    $Res Function(PaginatedBlockedUsersModel) then,
  ) =
      _$PaginatedBlockedUsersModelCopyWithImpl<
        $Res,
        PaginatedBlockedUsersModel
      >;
  @useResult
  $Res call({
    @JsonKey(defaultValue: <BlockedUserModel>[]) List<BlockedUserModel> content,
    @JsonKey(readValue: _readPageNumber, fromJson: _toInt, defaultValue: 0)
    int pageNumber,
    @JsonKey(readValue: _readPageSize, fromJson: _toInt, defaultValue: 20)
    int pageSize,
    @JsonKey(fromJson: _toInt, defaultValue: 0) int totalElements,
    @JsonKey(fromJson: _toInt, defaultValue: 1) int totalPages,
    @JsonKey(readValue: _readIsLast, fromJson: _toBool, defaultValue: true)
    bool isLast,
  });
}

/// @nodoc
class _$PaginatedBlockedUsersModelCopyWithImpl<
  $Res,
  $Val extends PaginatedBlockedUsersModel
>
    implements $PaginatedBlockedUsersModelCopyWith<$Res> {
  _$PaginatedBlockedUsersModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedBlockedUsersModel
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
                      as List<BlockedUserModel>,
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
abstract class _$$PaginatedBlockedUsersModelImplCopyWith<$Res>
    implements $PaginatedBlockedUsersModelCopyWith<$Res> {
  factory _$$PaginatedBlockedUsersModelImplCopyWith(
    _$PaginatedBlockedUsersModelImpl value,
    $Res Function(_$PaginatedBlockedUsersModelImpl) then,
  ) = __$$PaginatedBlockedUsersModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(defaultValue: <BlockedUserModel>[]) List<BlockedUserModel> content,
    @JsonKey(readValue: _readPageNumber, fromJson: _toInt, defaultValue: 0)
    int pageNumber,
    @JsonKey(readValue: _readPageSize, fromJson: _toInt, defaultValue: 20)
    int pageSize,
    @JsonKey(fromJson: _toInt, defaultValue: 0) int totalElements,
    @JsonKey(fromJson: _toInt, defaultValue: 1) int totalPages,
    @JsonKey(readValue: _readIsLast, fromJson: _toBool, defaultValue: true)
    bool isLast,
  });
}

/// @nodoc
class __$$PaginatedBlockedUsersModelImplCopyWithImpl<$Res>
    extends
        _$PaginatedBlockedUsersModelCopyWithImpl<
          $Res,
          _$PaginatedBlockedUsersModelImpl
        >
    implements _$$PaginatedBlockedUsersModelImplCopyWith<$Res> {
  __$$PaginatedBlockedUsersModelImplCopyWithImpl(
    _$PaginatedBlockedUsersModelImpl _value,
    $Res Function(_$PaginatedBlockedUsersModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedBlockedUsersModel
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
      _$PaginatedBlockedUsersModelImpl(
        content: null == content
            ? _value._content
            : content // ignore: cast_nullable_to_non_nullable
                  as List<BlockedUserModel>,
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
class _$PaginatedBlockedUsersModelImpl implements _PaginatedBlockedUsersModel {
  const _$PaginatedBlockedUsersModelImpl({
    @JsonKey(defaultValue: <BlockedUserModel>[])
    required final List<BlockedUserModel> content,
    @JsonKey(readValue: _readPageNumber, fromJson: _toInt, defaultValue: 0)
    required this.pageNumber,
    @JsonKey(readValue: _readPageSize, fromJson: _toInt, defaultValue: 20)
    required this.pageSize,
    @JsonKey(fromJson: _toInt, defaultValue: 0) required this.totalElements,
    @JsonKey(fromJson: _toInt, defaultValue: 1) required this.totalPages,
    @JsonKey(readValue: _readIsLast, fromJson: _toBool, defaultValue: true)
    required this.isLast,
  }) : _content = content;

  factory _$PaginatedBlockedUsersModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$PaginatedBlockedUsersModelImplFromJson(json);

  final List<BlockedUserModel> _content;
  @override
  @JsonKey(defaultValue: <BlockedUserModel>[])
  List<BlockedUserModel> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  @override
  @JsonKey(readValue: _readPageNumber, fromJson: _toInt, defaultValue: 0)
  final int pageNumber;
  @override
  @JsonKey(readValue: _readPageSize, fromJson: _toInt, defaultValue: 20)
  final int pageSize;
  @override
  @JsonKey(fromJson: _toInt, defaultValue: 0)
  final int totalElements;
  @override
  @JsonKey(fromJson: _toInt, defaultValue: 1)
  final int totalPages;
  @override
  @JsonKey(readValue: _readIsLast, fromJson: _toBool, defaultValue: true)
  final bool isLast;

  @override
  String toString() {
    return 'PaginatedBlockedUsersModel(content: $content, pageNumber: $pageNumber, pageSize: $pageSize, totalElements: $totalElements, totalPages: $totalPages, isLast: $isLast)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedBlockedUsersModelImpl &&
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

  /// Create a copy of PaginatedBlockedUsersModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedBlockedUsersModelImplCopyWith<_$PaginatedBlockedUsersModelImpl>
  get copyWith =>
      __$$PaginatedBlockedUsersModelImplCopyWithImpl<
        _$PaginatedBlockedUsersModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedBlockedUsersModelImplToJson(this);
  }
}

abstract class _PaginatedBlockedUsersModel
    implements PaginatedBlockedUsersModel {
  const factory _PaginatedBlockedUsersModel({
    @JsonKey(defaultValue: <BlockedUserModel>[])
    required final List<BlockedUserModel> content,
    @JsonKey(readValue: _readPageNumber, fromJson: _toInt, defaultValue: 0)
    required final int pageNumber,
    @JsonKey(readValue: _readPageSize, fromJson: _toInt, defaultValue: 20)
    required final int pageSize,
    @JsonKey(fromJson: _toInt, defaultValue: 0)
    required final int totalElements,
    @JsonKey(fromJson: _toInt, defaultValue: 1) required final int totalPages,
    @JsonKey(readValue: _readIsLast, fromJson: _toBool, defaultValue: true)
    required final bool isLast,
  }) = _$PaginatedBlockedUsersModelImpl;

  factory _PaginatedBlockedUsersModel.fromJson(Map<String, dynamic> json) =
      _$PaginatedBlockedUsersModelImpl.fromJson;

  @override
  @JsonKey(defaultValue: <BlockedUserModel>[])
  List<BlockedUserModel> get content;
  @override
  @JsonKey(readValue: _readPageNumber, fromJson: _toInt, defaultValue: 0)
  int get pageNumber;
  @override
  @JsonKey(readValue: _readPageSize, fromJson: _toInt, defaultValue: 20)
  int get pageSize;
  @override
  @JsonKey(fromJson: _toInt, defaultValue: 0)
  int get totalElements;
  @override
  @JsonKey(fromJson: _toInt, defaultValue: 1)
  int get totalPages;
  @override
  @JsonKey(readValue: _readIsLast, fromJson: _toBool, defaultValue: true)
  bool get isLast;

  /// Create a copy of PaginatedBlockedUsersModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedBlockedUsersModelImplCopyWith<_$PaginatedBlockedUsersModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
