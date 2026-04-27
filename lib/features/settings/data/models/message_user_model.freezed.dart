// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageUserModel _$MessageUserModelFromJson(Map<String, dynamic> json) {
  return _MessageUserModel.fromJson(json);
}

/// @nodoc
mixin _$MessageUserModel {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;

  /// Serializes this MessageUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageUserModelCopyWith<MessageUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageUserModelCopyWith<$Res> {
  factory $MessageUserModelCopyWith(
    MessageUserModel value,
    $Res Function(MessageUserModel) then,
  ) = _$MessageUserModelCopyWithImpl<$Res, MessageUserModel>;
  @useResult
  $Res call({int id, String username});
}

/// @nodoc
class _$MessageUserModelCopyWithImpl<$Res, $Val extends MessageUserModel>
    implements $MessageUserModelCopyWith<$Res> {
  _$MessageUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? username = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageUserModelImplCopyWith<$Res>
    implements $MessageUserModelCopyWith<$Res> {
  factory _$$MessageUserModelImplCopyWith(
    _$MessageUserModelImpl value,
    $Res Function(_$MessageUserModelImpl) then,
  ) = __$$MessageUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String username});
}

/// @nodoc
class __$$MessageUserModelImplCopyWithImpl<$Res>
    extends _$MessageUserModelCopyWithImpl<$Res, _$MessageUserModelImpl>
    implements _$$MessageUserModelImplCopyWith<$Res> {
  __$$MessageUserModelImplCopyWithImpl(
    _$MessageUserModelImpl _value,
    $Res Function(_$MessageUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? username = null}) {
    return _then(
      _$MessageUserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageUserModelImpl implements _MessageUserModel {
  const _$MessageUserModelImpl({required this.id, required this.username});

  factory _$MessageUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageUserModelImplFromJson(json);

  @override
  final int id;
  @override
  final String username;

  @override
  String toString() {
    return 'MessageUserModel(id: $id, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username);

  /// Create a copy of MessageUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageUserModelImplCopyWith<_$MessageUserModelImpl> get copyWith =>
      __$$MessageUserModelImplCopyWithImpl<_$MessageUserModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageUserModelImplToJson(this);
  }
}

abstract class _MessageUserModel implements MessageUserModel {
  const factory _MessageUserModel({
    required final int id,
    required final String username,
  }) = _$MessageUserModelImpl;

  factory _MessageUserModel.fromJson(Map<String, dynamic> json) =
      _$MessageUserModelImpl.fromJson;

  @override
  int get id;
  @override
  String get username;

  /// Create a copy of MessageUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageUserModelImplCopyWith<_$MessageUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
