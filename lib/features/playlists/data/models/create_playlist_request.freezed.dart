// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_playlist_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreatePlaylistRequest _$CreatePlaylistRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreatePlaylistRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePlaylistRequest {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;

  /// Serializes this CreatePlaylistRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePlaylistRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePlaylistRequestCopyWith<CreatePlaylistRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePlaylistRequestCopyWith<$Res> {
  factory $CreatePlaylistRequestCopyWith(
    CreatePlaylistRequest value,
    $Res Function(CreatePlaylistRequest) then,
  ) = _$CreatePlaylistRequestCopyWithImpl<$Res, CreatePlaylistRequest>;
  @useResult
  $Res call({String title, String? description, String type, bool isPrivate});
}

/// @nodoc
class _$CreatePlaylistRequestCopyWithImpl<
  $Res,
  $Val extends CreatePlaylistRequest
>
    implements $CreatePlaylistRequestCopyWith<$Res> {
  _$CreatePlaylistRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePlaylistRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? isPrivate = null,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            isPrivate: null == isPrivate
                ? _value.isPrivate
                : isPrivate // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreatePlaylistRequestImplCopyWith<$Res>
    implements $CreatePlaylistRequestCopyWith<$Res> {
  factory _$$CreatePlaylistRequestImplCopyWith(
    _$CreatePlaylistRequestImpl value,
    $Res Function(_$CreatePlaylistRequestImpl) then,
  ) = __$$CreatePlaylistRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String? description, String type, bool isPrivate});
}

/// @nodoc
class __$$CreatePlaylistRequestImplCopyWithImpl<$Res>
    extends
        _$CreatePlaylistRequestCopyWithImpl<$Res, _$CreatePlaylistRequestImpl>
    implements _$$CreatePlaylistRequestImplCopyWith<$Res> {
  __$$CreatePlaylistRequestImplCopyWithImpl(
    _$CreatePlaylistRequestImpl _value,
    $Res Function(_$CreatePlaylistRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatePlaylistRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? isPrivate = null,
  }) {
    return _then(
      _$CreatePlaylistRequestImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        isPrivate: null == isPrivate
            ? _value.isPrivate
            : isPrivate // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePlaylistRequestImpl implements _CreatePlaylistRequest {
  const _$CreatePlaylistRequestImpl({
    required this.title,
    this.description,
    this.type = 'PLAYLIST',
    this.isPrivate = true,
  });

  factory _$CreatePlaylistRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePlaylistRequestImplFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final bool isPrivate;

  @override
  String toString() {
    return 'CreatePlaylistRequest(title: $title, description: $description, type: $type, isPrivate: $isPrivate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePlaylistRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, description, type, isPrivate);

  /// Create a copy of CreatePlaylistRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePlaylistRequestImplCopyWith<_$CreatePlaylistRequestImpl>
  get copyWith =>
      __$$CreatePlaylistRequestImplCopyWithImpl<_$CreatePlaylistRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePlaylistRequestImplToJson(this);
  }
}

abstract class _CreatePlaylistRequest implements CreatePlaylistRequest {
  const factory _CreatePlaylistRequest({
    required final String title,
    final String? description,
    final String type,
    final bool isPrivate,
  }) = _$CreatePlaylistRequestImpl;

  factory _CreatePlaylistRequest.fromJson(Map<String, dynamic> json) =
      _$CreatePlaylistRequestImpl.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  String get type;
  @override
  bool get isPrivate;

  /// Create a copy of CreatePlaylistRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePlaylistRequestImplCopyWith<_$CreatePlaylistRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
