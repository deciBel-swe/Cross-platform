// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationSettingsModel _$NotificationSettingsModelFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettingsModel {
  bool get notifyOnFollow => throw _privateConstructorUsedError;
  bool get notifyOnLike => throw _privateConstructorUsedError;
  bool get notifyOnRepost => throw _privateConstructorUsedError;
  bool get notifyOnComment => throw _privateConstructorUsedError;
  bool get notifyOnDM => throw _privateConstructorUsedError;

  /// Serializes this NotificationSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingsModelCopyWith<NotificationSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsModelCopyWith<$Res> {
  factory $NotificationSettingsModelCopyWith(
    NotificationSettingsModel value,
    $Res Function(NotificationSettingsModel) then,
  ) = _$NotificationSettingsModelCopyWithImpl<$Res, NotificationSettingsModel>;
  @useResult
  $Res call({
    bool notifyOnFollow,
    bool notifyOnLike,
    bool notifyOnRepost,
    bool notifyOnComment,
    bool notifyOnDM,
  });
}

/// @nodoc
class _$NotificationSettingsModelCopyWithImpl<
  $Res,
  $Val extends NotificationSettingsModel
>
    implements $NotificationSettingsModelCopyWith<$Res> {
  _$NotificationSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifyOnFollow = null,
    Object? notifyOnLike = null,
    Object? notifyOnRepost = null,
    Object? notifyOnComment = null,
    Object? notifyOnDM = null,
  }) {
    return _then(
      _value.copyWith(
            notifyOnFollow: null == notifyOnFollow
                ? _value.notifyOnFollow
                : notifyOnFollow // ignore: cast_nullable_to_non_nullable
                      as bool,
            notifyOnLike: null == notifyOnLike
                ? _value.notifyOnLike
                : notifyOnLike // ignore: cast_nullable_to_non_nullable
                      as bool,
            notifyOnRepost: null == notifyOnRepost
                ? _value.notifyOnRepost
                : notifyOnRepost // ignore: cast_nullable_to_non_nullable
                      as bool,
            notifyOnComment: null == notifyOnComment
                ? _value.notifyOnComment
                : notifyOnComment // ignore: cast_nullable_to_non_nullable
                      as bool,
            notifyOnDM: null == notifyOnDM
                ? _value.notifyOnDM
                : notifyOnDM // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationSettingsModelImplCopyWith<$Res>
    implements $NotificationSettingsModelCopyWith<$Res> {
  factory _$$NotificationSettingsModelImplCopyWith(
    _$NotificationSettingsModelImpl value,
    $Res Function(_$NotificationSettingsModelImpl) then,
  ) = __$$NotificationSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool notifyOnFollow,
    bool notifyOnLike,
    bool notifyOnRepost,
    bool notifyOnComment,
    bool notifyOnDM,
  });
}

/// @nodoc
class __$$NotificationSettingsModelImplCopyWithImpl<$Res>
    extends
        _$NotificationSettingsModelCopyWithImpl<
          $Res,
          _$NotificationSettingsModelImpl
        >
    implements _$$NotificationSettingsModelImplCopyWith<$Res> {
  __$$NotificationSettingsModelImplCopyWithImpl(
    _$NotificationSettingsModelImpl _value,
    $Res Function(_$NotificationSettingsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifyOnFollow = null,
    Object? notifyOnLike = null,
    Object? notifyOnRepost = null,
    Object? notifyOnComment = null,
    Object? notifyOnDM = null,
  }) {
    return _then(
      _$NotificationSettingsModelImpl(
        notifyOnFollow: null == notifyOnFollow
            ? _value.notifyOnFollow
            : notifyOnFollow // ignore: cast_nullable_to_non_nullable
                  as bool,
        notifyOnLike: null == notifyOnLike
            ? _value.notifyOnLike
            : notifyOnLike // ignore: cast_nullable_to_non_nullable
                  as bool,
        notifyOnRepost: null == notifyOnRepost
            ? _value.notifyOnRepost
            : notifyOnRepost // ignore: cast_nullable_to_non_nullable
                  as bool,
        notifyOnComment: null == notifyOnComment
            ? _value.notifyOnComment
            : notifyOnComment // ignore: cast_nullable_to_non_nullable
                  as bool,
        notifyOnDM: null == notifyOnDM
            ? _value.notifyOnDM
            : notifyOnDM // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsModelImpl implements _NotificationSettingsModel {
  const _$NotificationSettingsModelImpl({
    this.notifyOnFollow = true,
    this.notifyOnLike = true,
    this.notifyOnRepost = true,
    this.notifyOnComment = true,
    this.notifyOnDM = true,
  });

  factory _$NotificationSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsModelImplFromJson(json);

  @override
  @JsonKey()
  final bool notifyOnFollow;
  @override
  @JsonKey()
  final bool notifyOnLike;
  @override
  @JsonKey()
  final bool notifyOnRepost;
  @override
  @JsonKey()
  final bool notifyOnComment;
  @override
  @JsonKey()
  final bool notifyOnDM;

  @override
  String toString() {
    return 'NotificationSettingsModel(notifyOnFollow: $notifyOnFollow, notifyOnLike: $notifyOnLike, notifyOnRepost: $notifyOnRepost, notifyOnComment: $notifyOnComment, notifyOnDM: $notifyOnDM)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsModelImpl &&
            (identical(other.notifyOnFollow, notifyOnFollow) ||
                other.notifyOnFollow == notifyOnFollow) &&
            (identical(other.notifyOnLike, notifyOnLike) ||
                other.notifyOnLike == notifyOnLike) &&
            (identical(other.notifyOnRepost, notifyOnRepost) ||
                other.notifyOnRepost == notifyOnRepost) &&
            (identical(other.notifyOnComment, notifyOnComment) ||
                other.notifyOnComment == notifyOnComment) &&
            (identical(other.notifyOnDM, notifyOnDM) ||
                other.notifyOnDM == notifyOnDM));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    notifyOnFollow,
    notifyOnLike,
    notifyOnRepost,
    notifyOnComment,
    notifyOnDM,
  );

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
  get copyWith =>
      __$$NotificationSettingsModelImplCopyWithImpl<
        _$NotificationSettingsModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsModelImplToJson(this);
  }
}

abstract class _NotificationSettingsModel implements NotificationSettingsModel {
  const factory _NotificationSettingsModel({
    final bool notifyOnFollow,
    final bool notifyOnLike,
    final bool notifyOnRepost,
    final bool notifyOnComment,
    final bool notifyOnDM,
  }) = _$NotificationSettingsModelImpl;

  factory _NotificationSettingsModel.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsModelImpl.fromJson;

  @override
  bool get notifyOnFollow;
  @override
  bool get notifyOnLike;
  @override
  bool get notifyOnRepost;
  @override
  bool get notifyOnComment;
  @override
  bool get notifyOnDM;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
