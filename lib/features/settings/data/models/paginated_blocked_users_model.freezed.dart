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
  List<BlockedUserModel> get content => throw _privateConstructorUsedError;
  int get pageNumber => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
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
    List<BlockedUserModel> content,
    int pageNumber,
    int pageSize,
    int totalElements,
    int totalPages,
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
    List<BlockedUserModel> content,
    int pageNumber,
    int pageSize,
    int totalElements,
    int totalPages,
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
    required final List<BlockedUserModel> content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isLast,
  }) : _content = content;

  factory _$PaginatedBlockedUsersModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$PaginatedBlockedUsersModelImplFromJson(json);

  final List<BlockedUserModel> _content;
  @override
  List<BlockedUserModel> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  @override
  final int pageNumber;
  @override
  final int pageSize;
  @override
  final int totalElements;
  @override
  final int totalPages;
  @override
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
    required final List<BlockedUserModel> content,
    required final int pageNumber,
    required final int pageSize,
    required final int totalElements,
    required final int totalPages,
    required final bool isLast,
  }) = _$PaginatedBlockedUsersModelImpl;

  factory _PaginatedBlockedUsersModel.fromJson(Map<String, dynamic> json) =
      _$PaginatedBlockedUsersModelImpl.fromJson;

  @override
  List<BlockedUserModel> get content;
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

  /// Create a copy of PaginatedBlockedUsersModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedBlockedUsersModelImplCopyWith<_$PaginatedBlockedUsersModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
