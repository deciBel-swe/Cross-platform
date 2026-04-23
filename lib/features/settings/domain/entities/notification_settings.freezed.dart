// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationSettings _$NotificationSettingsFromJson(Map<String, dynamic> json) {
  return _NotificationSettings.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettings {
  bool get notifyOnFollow => throw _privateConstructorUsedError;
  bool get notifyOnLike => throw _privateConstructorUsedError;
  bool get notifyOnRepost => throw _privateConstructorUsedError;
  bool get notifyOnComment => throw _privateConstructorUsedError;
  bool get notifyOnDM => throw _privateConstructorUsedError;

  /// Serializes this NotificationSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingsCopyWith<NotificationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsCopyWith<$Res> {
  factory $NotificationSettingsCopyWith(
    NotificationSettings value,
    $Res Function(NotificationSettings) then,
  ) = _$NotificationSettingsCopyWithImpl<$Res, NotificationSettings>;
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
class _$NotificationSettingsCopyWithImpl<
  $Res,
  $Val extends NotificationSettings
>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettings
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
abstract class _$$NotificationSettingsImplCopyWith<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  factory _$$NotificationSettingsImplCopyWith(
    _$NotificationSettingsImpl value,
    $Res Function(_$NotificationSettingsImpl) then,
  ) = __$$NotificationSettingsImplCopyWithImpl<$Res>;
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
class __$$NotificationSettingsImplCopyWithImpl<$Res>
    extends _$NotificationSettingsCopyWithImpl<$Res, _$NotificationSettingsImpl>
    implements _$$NotificationSettingsImplCopyWith<$Res> {
  __$$NotificationSettingsImplCopyWithImpl(
    _$NotificationSettingsImpl _value,
    $Res Function(_$NotificationSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationSettings
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
      _$NotificationSettingsImpl(
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
class _$NotificationSettingsImpl implements _NotificationSettings {
  const _$NotificationSettingsImpl({
    this.notifyOnFollow = true,
    this.notifyOnLike = true,
    this.notifyOnRepost = true,
    this.notifyOnComment = true,
    this.notifyOnDM = true,
  });

  factory _$NotificationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsImplFromJson(json);

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
    return 'NotificationSettings(notifyOnFollow: $notifyOnFollow, notifyOnLike: $notifyOnLike, notifyOnRepost: $notifyOnRepost, notifyOnComment: $notifyOnComment, notifyOnDM: $notifyOnDM)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsImpl &&
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

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
  get copyWith =>
      __$$NotificationSettingsImplCopyWithImpl<_$NotificationSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsImplToJson(this);
  }
}

abstract class _NotificationSettings implements NotificationSettings {
  const factory _NotificationSettings({
    final bool notifyOnFollow,
    final bool notifyOnLike,
    final bool notifyOnRepost,
    final bool notifyOnComment,
    final bool notifyOnDM,
  }) = _$NotificationSettingsImpl;

  factory _NotificationSettings.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsImpl.fromJson;

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

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
