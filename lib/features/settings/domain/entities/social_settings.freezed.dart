// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SocialSettings _$SocialSettingsFromJson(Map<String, dynamic> json) {
  return _SocialSettings.fromJson(json);
}

/// @nodoc
mixin _$SocialSettings {
  bool get isPrivate => throw _privateConstructorUsedError;
  bool get showHistory => throw _privateConstructorUsedError;

  /// Serializes this SocialSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialSettingsCopyWith<SocialSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialSettingsCopyWith<$Res> {
  factory $SocialSettingsCopyWith(
    SocialSettings value,
    $Res Function(SocialSettings) then,
  ) = _$SocialSettingsCopyWithImpl<$Res, SocialSettings>;
  @useResult
  $Res call({bool isPrivate, bool showHistory});
}

/// @nodoc
class _$SocialSettingsCopyWithImpl<$Res, $Val extends SocialSettings>
    implements $SocialSettingsCopyWith<$Res> {
  _$SocialSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isPrivate = null, Object? showHistory = null}) {
    return _then(
      _value.copyWith(
            isPrivate: null == isPrivate
                ? _value.isPrivate
                : isPrivate // ignore: cast_nullable_to_non_nullable
                      as bool,
            showHistory: null == showHistory
                ? _value.showHistory
                : showHistory // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SocialSettingsImplCopyWith<$Res>
    implements $SocialSettingsCopyWith<$Res> {
  factory _$$SocialSettingsImplCopyWith(
    _$SocialSettingsImpl value,
    $Res Function(_$SocialSettingsImpl) then,
  ) = __$$SocialSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isPrivate, bool showHistory});
}

/// @nodoc
class __$$SocialSettingsImplCopyWithImpl<$Res>
    extends _$SocialSettingsCopyWithImpl<$Res, _$SocialSettingsImpl>
    implements _$$SocialSettingsImplCopyWith<$Res> {
  __$$SocialSettingsImplCopyWithImpl(
    _$SocialSettingsImpl _value,
    $Res Function(_$SocialSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SocialSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isPrivate = null, Object? showHistory = null}) {
    return _then(
      _$SocialSettingsImpl(
        isPrivate: null == isPrivate
            ? _value.isPrivate
            : isPrivate // ignore: cast_nullable_to_non_nullable
                  as bool,
        showHistory: null == showHistory
            ? _value.showHistory
            : showHistory // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialSettingsImpl implements _SocialSettings {
  const _$SocialSettingsImpl({this.isPrivate = false, this.showHistory = true});

  factory _$SocialSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool isPrivate;
  @override
  @JsonKey()
  final bool showHistory;

  @override
  String toString() {
    return 'SocialSettings(isPrivate: $isPrivate, showHistory: $showHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialSettingsImpl &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.showHistory, showHistory) ||
                other.showHistory == showHistory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isPrivate, showHistory);

  /// Create a copy of SocialSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialSettingsImplCopyWith<_$SocialSettingsImpl> get copyWith =>
      __$$SocialSettingsImplCopyWithImpl<_$SocialSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialSettingsImplToJson(this);
  }
}

abstract class _SocialSettings implements SocialSettings {
  const factory _SocialSettings({
    final bool isPrivate,
    final bool showHistory,
  }) = _$SocialSettingsImpl;

  factory _SocialSettings.fromJson(Map<String, dynamic> json) =
      _$SocialSettingsImpl.fromJson;

  @override
  bool get isPrivate;
  @override
  bool get showHistory;

  /// Create a copy of SocialSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialSettingsImplCopyWith<_$SocialSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
