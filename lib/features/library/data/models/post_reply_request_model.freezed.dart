// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_reply_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PostReplyRequestModel _$PostReplyRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _PostReplyRequestModel.fromJson(json);
}

/// @nodoc
mixin _$PostReplyRequestModel {
  String get body => throw _privateConstructorUsedError;

  /// Serializes this PostReplyRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostReplyRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostReplyRequestModelCopyWith<PostReplyRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostReplyRequestModelCopyWith<$Res> {
  factory $PostReplyRequestModelCopyWith(
    PostReplyRequestModel value,
    $Res Function(PostReplyRequestModel) then,
  ) = _$PostReplyRequestModelCopyWithImpl<$Res, PostReplyRequestModel>;
  @useResult
  $Res call({String body});
}

/// @nodoc
class _$PostReplyRequestModelCopyWithImpl<
  $Res,
  $Val extends PostReplyRequestModel
>
    implements $PostReplyRequestModelCopyWith<$Res> {
  _$PostReplyRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostReplyRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? body = null}) {
    return _then(
      _value.copyWith(
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostReplyRequestModelImplCopyWith<$Res>
    implements $PostReplyRequestModelCopyWith<$Res> {
  factory _$$PostReplyRequestModelImplCopyWith(
    _$PostReplyRequestModelImpl value,
    $Res Function(_$PostReplyRequestModelImpl) then,
  ) = __$$PostReplyRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String body});
}

/// @nodoc
class __$$PostReplyRequestModelImplCopyWithImpl<$Res>
    extends
        _$PostReplyRequestModelCopyWithImpl<$Res, _$PostReplyRequestModelImpl>
    implements _$$PostReplyRequestModelImplCopyWith<$Res> {
  __$$PostReplyRequestModelImplCopyWithImpl(
    _$PostReplyRequestModelImpl _value,
    $Res Function(_$PostReplyRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostReplyRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? body = null}) {
    return _then(
      _$PostReplyRequestModelImpl(
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostReplyRequestModelImpl implements _PostReplyRequestModel {
  const _$PostReplyRequestModelImpl({required this.body});

  factory _$PostReplyRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostReplyRequestModelImplFromJson(json);

  @override
  final String body;

  @override
  String toString() {
    return 'PostReplyRequestModel(body: $body)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostReplyRequestModelImpl &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, body);

  /// Create a copy of PostReplyRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostReplyRequestModelImplCopyWith<_$PostReplyRequestModelImpl>
  get copyWith =>
      __$$PostReplyRequestModelImplCopyWithImpl<_$PostReplyRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PostReplyRequestModelImplToJson(this);
  }
}

abstract class _PostReplyRequestModel implements PostReplyRequestModel {
  const factory _PostReplyRequestModel({required final String body}) =
      _$PostReplyRequestModelImpl;

  factory _PostReplyRequestModel.fromJson(Map<String, dynamic> json) =
      _$PostReplyRequestModelImpl.fromJson;

  @override
  String get body;

  /// Create a copy of PostReplyRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostReplyRequestModelImplCopyWith<_$PostReplyRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
