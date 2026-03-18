// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_audio_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TrackAudioState {
  bool get isPlaying => throw _privateConstructorUsedError;
  Duration get position => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  bool get isDragging => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;

  /// Create a copy of TrackAudioState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackAudioStateCopyWith<TrackAudioState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackAudioStateCopyWith<$Res> {
  factory $TrackAudioStateCopyWith(
    TrackAudioState value,
    $Res Function(TrackAudioState) then,
  ) = _$TrackAudioStateCopyWithImpl<$Res, TrackAudioState>;
  @useResult
  $Res call({
    bool isPlaying,
    Duration position,
    Duration duration,
    bool isDragging,
    double progress,
  });
}

/// @nodoc
class _$TrackAudioStateCopyWithImpl<$Res, $Val extends TrackAudioState>
    implements $TrackAudioStateCopyWith<$Res> {
  _$TrackAudioStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackAudioState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPlaying = null,
    Object? position = null,
    Object? duration = null,
    Object? isDragging = null,
    Object? progress = null,
  }) {
    return _then(
      _value.copyWith(
            isPlaying: null == isPlaying
                ? _value.isPlaying
                : isPlaying // ignore: cast_nullable_to_non_nullable
                      as bool,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as Duration,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            isDragging: null == isDragging
                ? _value.isDragging
                : isDragging // ignore: cast_nullable_to_non_nullable
                      as bool,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrackAudioStateImplCopyWith<$Res>
    implements $TrackAudioStateCopyWith<$Res> {
  factory _$$TrackAudioStateImplCopyWith(
    _$TrackAudioStateImpl value,
    $Res Function(_$TrackAudioStateImpl) then,
  ) = __$$TrackAudioStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isPlaying,
    Duration position,
    Duration duration,
    bool isDragging,
    double progress,
  });
}

/// @nodoc
class __$$TrackAudioStateImplCopyWithImpl<$Res>
    extends _$TrackAudioStateCopyWithImpl<$Res, _$TrackAudioStateImpl>
    implements _$$TrackAudioStateImplCopyWith<$Res> {
  __$$TrackAudioStateImplCopyWithImpl(
    _$TrackAudioStateImpl _value,
    $Res Function(_$TrackAudioStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrackAudioState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPlaying = null,
    Object? position = null,
    Object? duration = null,
    Object? isDragging = null,
    Object? progress = null,
  }) {
    return _then(
      _$TrackAudioStateImpl(
        isPlaying: null == isPlaying
            ? _value.isPlaying
            : isPlaying // ignore: cast_nullable_to_non_nullable
                  as bool,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as Duration,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        isDragging: null == isDragging
            ? _value.isDragging
            : isDragging // ignore: cast_nullable_to_non_nullable
                  as bool,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$TrackAudioStateImpl implements _TrackAudioState {
  const _$TrackAudioStateImpl({
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.isDragging,
    required this.progress,
  });

  @override
  final bool isPlaying;
  @override
  final Duration position;
  @override
  final Duration duration;
  @override
  final bool isDragging;
  @override
  final double progress;

  @override
  String toString() {
    return 'TrackAudioState(isPlaying: $isPlaying, position: $position, duration: $duration, isDragging: $isDragging, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackAudioStateImpl &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.isDragging, isDragging) ||
                other.isDragging == isDragging) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isPlaying,
    position,
    duration,
    isDragging,
    progress,
  );

  /// Create a copy of TrackAudioState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackAudioStateImplCopyWith<_$TrackAudioStateImpl> get copyWith =>
      __$$TrackAudioStateImplCopyWithImpl<_$TrackAudioStateImpl>(
        this,
        _$identity,
      );
}

abstract class _TrackAudioState implements TrackAudioState {
  const factory _TrackAudioState({
    required final bool isPlaying,
    required final Duration position,
    required final Duration duration,
    required final bool isDragging,
    required final double progress,
  }) = _$TrackAudioStateImpl;

  @override
  bool get isPlaying;
  @override
  Duration get position;
  @override
  Duration get duration;
  @override
  bool get isDragging;
  @override
  double get progress;

  /// Create a copy of TrackAudioState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackAudioStateImplCopyWith<_$TrackAudioStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
