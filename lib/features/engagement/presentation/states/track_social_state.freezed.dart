// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_social_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TrackSocialState {
  Map<String, TrackSocialData> get trackStates =>
      throw _privateConstructorUsedError;
  Set<String> get loadingKeys => throw _privateConstructorUsedError;

  /// Create a copy of TrackSocialState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackSocialStateCopyWith<TrackSocialState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackSocialStateCopyWith<$Res> {
  factory $TrackSocialStateCopyWith(
    TrackSocialState value,
    $Res Function(TrackSocialState) then,
  ) = _$TrackSocialStateCopyWithImpl<$Res, TrackSocialState>;
  @useResult
  $Res call({
    Map<String, TrackSocialData> trackStates,
    Set<String> loadingKeys,
  });
}

/// @nodoc
class _$TrackSocialStateCopyWithImpl<$Res, $Val extends TrackSocialState>
    implements $TrackSocialStateCopyWith<$Res> {
  _$TrackSocialStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackSocialState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? trackStates = null, Object? loadingKeys = null}) {
    return _then(
      _value.copyWith(
            trackStates: null == trackStates
                ? _value.trackStates
                : trackStates // ignore: cast_nullable_to_non_nullable
                      as Map<String, TrackSocialData>,
            loadingKeys: null == loadingKeys
                ? _value.loadingKeys
                : loadingKeys // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrackSocialStateImplCopyWith<$Res>
    implements $TrackSocialStateCopyWith<$Res> {
  factory _$$TrackSocialStateImplCopyWith(
    _$TrackSocialStateImpl value,
    $Res Function(_$TrackSocialStateImpl) then,
  ) = __$$TrackSocialStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<String, TrackSocialData> trackStates,
    Set<String> loadingKeys,
  });
}

/// @nodoc
class __$$TrackSocialStateImplCopyWithImpl<$Res>
    extends _$TrackSocialStateCopyWithImpl<$Res, _$TrackSocialStateImpl>
    implements _$$TrackSocialStateImplCopyWith<$Res> {
  __$$TrackSocialStateImplCopyWithImpl(
    _$TrackSocialStateImpl _value,
    $Res Function(_$TrackSocialStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrackSocialState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? trackStates = null, Object? loadingKeys = null}) {
    return _then(
      _$TrackSocialStateImpl(
        trackStates: null == trackStates
            ? _value._trackStates
            : trackStates // ignore: cast_nullable_to_non_nullable
                  as Map<String, TrackSocialData>,
        loadingKeys: null == loadingKeys
            ? _value._loadingKeys
            : loadingKeys // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
      ),
    );
  }
}

/// @nodoc

class _$TrackSocialStateImpl implements _TrackSocialState {
  const _$TrackSocialStateImpl({
    final Map<String, TrackSocialData> trackStates = const {},
    final Set<String> loadingKeys = const {},
  }) : _trackStates = trackStates,
       _loadingKeys = loadingKeys;

  final Map<String, TrackSocialData> _trackStates;
  @override
  @JsonKey()
  Map<String, TrackSocialData> get trackStates {
    if (_trackStates is EqualUnmodifiableMapView) return _trackStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_trackStates);
  }

  final Set<String> _loadingKeys;
  @override
  @JsonKey()
  Set<String> get loadingKeys {
    if (_loadingKeys is EqualUnmodifiableSetView) return _loadingKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_loadingKeys);
  }

  @override
  String toString() {
    return 'TrackSocialState(trackStates: $trackStates, loadingKeys: $loadingKeys)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackSocialStateImpl &&
            const DeepCollectionEquality().equals(
              other._trackStates,
              _trackStates,
            ) &&
            const DeepCollectionEquality().equals(
              other._loadingKeys,
              _loadingKeys,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_trackStates),
    const DeepCollectionEquality().hash(_loadingKeys),
  );

  /// Create a copy of TrackSocialState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackSocialStateImplCopyWith<_$TrackSocialStateImpl> get copyWith =>
      __$$TrackSocialStateImplCopyWithImpl<_$TrackSocialStateImpl>(
        this,
        _$identity,
      );
}

abstract class _TrackSocialState implements TrackSocialState {
  const factory _TrackSocialState({
    final Map<String, TrackSocialData> trackStates,
    final Set<String> loadingKeys,
  }) = _$TrackSocialStateImpl;

  @override
  Map<String, TrackSocialData> get trackStates;
  @override
  Set<String> get loadingKeys;

  /// Create a copy of TrackSocialState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackSocialStateImplCopyWith<_$TrackSocialStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
