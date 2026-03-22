// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_peaks_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TrackPeaksModel _$TrackPeaksModelFromJson(Map<String, dynamic> json) {
  return _TrackPeaksModel.fromJson(json);
}

/// @nodoc
mixin _$TrackPeaksModel {
  int get trackId => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  List<int> get peaks => throw _privateConstructorUsedError;

  /// Serializes this TrackPeaksModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrackPeaksModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackPeaksModelCopyWith<TrackPeaksModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackPeaksModelCopyWith<$Res> {
  factory $TrackPeaksModelCopyWith(
    TrackPeaksModel value,
    $Res Function(TrackPeaksModel) then,
  ) = _$TrackPeaksModelCopyWithImpl<$Res, TrackPeaksModel>;
  @useResult
  $Res call({int trackId, int duration, List<int> peaks});
}

/// @nodoc
class _$TrackPeaksModelCopyWithImpl<$Res, $Val extends TrackPeaksModel>
    implements $TrackPeaksModelCopyWith<$Res> {
  _$TrackPeaksModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackPeaksModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackId = null,
    Object? duration = null,
    Object? peaks = null,
  }) {
    return _then(
      _value.copyWith(
            trackId: null == trackId
                ? _value.trackId
                : trackId // ignore: cast_nullable_to_non_nullable
                      as int,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            peaks: null == peaks
                ? _value.peaks
                : peaks // ignore: cast_nullable_to_non_nullable
                      as List<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrackPeaksModelImplCopyWith<$Res>
    implements $TrackPeaksModelCopyWith<$Res> {
  factory _$$TrackPeaksModelImplCopyWith(
    _$TrackPeaksModelImpl value,
    $Res Function(_$TrackPeaksModelImpl) then,
  ) = __$$TrackPeaksModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int trackId, int duration, List<int> peaks});
}

/// @nodoc
class __$$TrackPeaksModelImplCopyWithImpl<$Res>
    extends _$TrackPeaksModelCopyWithImpl<$Res, _$TrackPeaksModelImpl>
    implements _$$TrackPeaksModelImplCopyWith<$Res> {
  __$$TrackPeaksModelImplCopyWithImpl(
    _$TrackPeaksModelImpl _value,
    $Res Function(_$TrackPeaksModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrackPeaksModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackId = null,
    Object? duration = null,
    Object? peaks = null,
  }) {
    return _then(
      _$TrackPeaksModelImpl(
        trackId: null == trackId
            ? _value.trackId
            : trackId // ignore: cast_nullable_to_non_nullable
                  as int,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        peaks: null == peaks
            ? _value._peaks
            : peaks // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TrackPeaksModelImpl implements _TrackPeaksModel {
  const _$TrackPeaksModelImpl({
    required this.trackId,
    required this.duration,
    final List<int> peaks = const <int>[],
  }) : _peaks = peaks;

  factory _$TrackPeaksModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackPeaksModelImplFromJson(json);

  @override
  final int trackId;
  @override
  final int duration;
  final List<int> _peaks;
  @override
  @JsonKey()
  List<int> get peaks {
    if (_peaks is EqualUnmodifiableListView) return _peaks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_peaks);
  }

  @override
  String toString() {
    return 'TrackPeaksModel(trackId: $trackId, duration: $duration, peaks: $peaks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackPeaksModelImpl &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other._peaks, _peaks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    trackId,
    duration,
    const DeepCollectionEquality().hash(_peaks),
  );

  /// Create a copy of TrackPeaksModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackPeaksModelImplCopyWith<_$TrackPeaksModelImpl> get copyWith =>
      __$$TrackPeaksModelImplCopyWithImpl<_$TrackPeaksModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackPeaksModelImplToJson(this);
  }
}

abstract class _TrackPeaksModel implements TrackPeaksModel {
  const factory _TrackPeaksModel({
    required final int trackId,
    required final int duration,
    final List<int> peaks,
  }) = _$TrackPeaksModelImpl;

  factory _TrackPeaksModel.fromJson(Map<String, dynamic> json) =
      _$TrackPeaksModelImpl.fromJson;

  @override
  int get trackId;
  @override
  int get duration;
  @override
  List<int> get peaks;

  /// Create a copy of TrackPeaksModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackPeaksModelImplCopyWith<_$TrackPeaksModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
