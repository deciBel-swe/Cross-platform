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
  bool get isPreparing => throw _privateConstructorUsedError;
  bool get isPrepared => throw _privateConstructorUsedError;
  int? get preparedTrackId => throw _privateConstructorUsedError;
  String? get preparedTrackUrl => throw _privateConstructorUsedError;

  /// The full track entity for the currently prepared track.
  /// Populated by [TrackAudioNotifier.initializeForTrack] so that any
  /// widget (desktop bar, mobile mini-player, etc.) can access cover art,
  /// display name, like status, etc. without a separate lookup.
  Track? get currentTrack => throw _privateConstructorUsedError;

  /// Playback queue used for skip next/previous (based on where playback started).
  List<Track> get queue => throw _privateConstructorUsedError;
  bool get isPlaying => throw _privateConstructorUsedError;
  bool get isDragging => throw _privateConstructorUsedError;
  double? get dragProgress => throw _privateConstructorUsedError;
  Duration? get dragPosition => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  Duration get position => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;

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
    bool isPreparing,
    bool isPrepared,
    int? preparedTrackId,
    String? preparedTrackUrl,
    Track? currentTrack,
    List<Track> queue,
    bool isPlaying,
    bool isDragging,
    double? dragProgress,
    Duration? dragPosition,
    double progress,
    Duration position,
    Duration duration,
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
    Object? isPreparing = null,
    Object? isPrepared = null,
    Object? preparedTrackId = freezed,
    Object? preparedTrackUrl = freezed,
    Object? currentTrack = freezed,
    Object? queue = null,
    Object? isPlaying = null,
    Object? isDragging = null,
    Object? dragProgress = freezed,
    Object? dragPosition = freezed,
    Object? progress = null,
    Object? position = null,
    Object? duration = null,
  }) {
    return _then(
      _value.copyWith(
            isPreparing: null == isPreparing
                ? _value.isPreparing
                : isPreparing // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPrepared: null == isPrepared
                ? _value.isPrepared
                : isPrepared // ignore: cast_nullable_to_non_nullable
                      as bool,
            preparedTrackId: freezed == preparedTrackId
                ? _value.preparedTrackId
                : preparedTrackId // ignore: cast_nullable_to_non_nullable
                      as int?,
            preparedTrackUrl: freezed == preparedTrackUrl
                ? _value.preparedTrackUrl
                : preparedTrackUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentTrack: freezed == currentTrack
                ? _value.currentTrack
                : currentTrack // ignore: cast_nullable_to_non_nullable
                      as Track?,
            queue: null == queue
                ? _value.queue
                : queue // ignore: cast_nullable_to_non_nullable
                      as List<Track>,
            isPlaying: null == isPlaying
                ? _value.isPlaying
                : isPlaying // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDragging: null == isDragging
                ? _value.isDragging
                : isDragging // ignore: cast_nullable_to_non_nullable
                      as bool,
            dragProgress: freezed == dragProgress
                ? _value.dragProgress
                : dragProgress // ignore: cast_nullable_to_non_nullable
                      as double?,
            dragPosition: freezed == dragPosition
                ? _value.dragPosition
                : dragPosition // ignore: cast_nullable_to_non_nullable
                      as Duration?,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as Duration,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as Duration,
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
    bool isPreparing,
    bool isPrepared,
    int? preparedTrackId,
    String? preparedTrackUrl,
    Track? currentTrack,
    List<Track> queue,
    bool isPlaying,
    bool isDragging,
    double? dragProgress,
    Duration? dragPosition,
    double progress,
    Duration position,
    Duration duration,
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
    Object? isPreparing = null,
    Object? isPrepared = null,
    Object? preparedTrackId = freezed,
    Object? preparedTrackUrl = freezed,
    Object? currentTrack = freezed,
    Object? queue = null,
    Object? isPlaying = null,
    Object? isDragging = null,
    Object? dragProgress = freezed,
    Object? dragPosition = freezed,
    Object? progress = null,
    Object? position = null,
    Object? duration = null,
  }) {
    return _then(
      _$TrackAudioStateImpl(
        isPreparing: null == isPreparing
            ? _value.isPreparing
            : isPreparing // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPrepared: null == isPrepared
            ? _value.isPrepared
            : isPrepared // ignore: cast_nullable_to_non_nullable
                  as bool,
        preparedTrackId: freezed == preparedTrackId
            ? _value.preparedTrackId
            : preparedTrackId // ignore: cast_nullable_to_non_nullable
                  as int?,
        preparedTrackUrl: freezed == preparedTrackUrl
            ? _value.preparedTrackUrl
            : preparedTrackUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentTrack: freezed == currentTrack
            ? _value.currentTrack
            : currentTrack // ignore: cast_nullable_to_non_nullable
                  as Track?,
        queue: null == queue
            ? _value._queue
            : queue // ignore: cast_nullable_to_non_nullable
                  as List<Track>,
        isPlaying: null == isPlaying
            ? _value.isPlaying
            : isPlaying // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDragging: null == isDragging
            ? _value.isDragging
            : isDragging // ignore: cast_nullable_to_non_nullable
                  as bool,
        dragProgress: freezed == dragProgress
            ? _value.dragProgress
            : dragProgress // ignore: cast_nullable_to_non_nullable
                  as double?,
        dragPosition: freezed == dragPosition
            ? _value.dragPosition
            : dragPosition // ignore: cast_nullable_to_non_nullable
                  as Duration?,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as Duration,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration,
      ),
    );
  }
}

/// @nodoc

class _$TrackAudioStateImpl implements _TrackAudioState {
  const _$TrackAudioStateImpl({
    this.isPreparing = false,
    this.isPrepared = false,
    this.preparedTrackId,
    this.preparedTrackUrl,
    this.currentTrack,
    final List<Track> queue = const <Track>[],
    this.isPlaying = false,
    this.isDragging = false,
    this.dragProgress,
    this.dragPosition,
    this.progress = 0.0,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  }) : _queue = queue;

  @override
  @JsonKey()
  final bool isPreparing;
  @override
  @JsonKey()
  final bool isPrepared;
  @override
  final int? preparedTrackId;
  @override
  final String? preparedTrackUrl;

  /// The full track entity for the currently prepared track.
  /// Populated by [TrackAudioNotifier.initializeForTrack] so that any
  /// widget (desktop bar, mobile mini-player, etc.) can access cover art,
  /// display name, like status, etc. without a separate lookup.
  @override
  final Track? currentTrack;

  /// Playback queue used for skip next/previous (based on where playback started).
  final List<Track> _queue;

  /// Playback queue used for skip next/previous (based on where playback started).
  @override
  @JsonKey()
  List<Track> get queue {
    if (_queue is EqualUnmodifiableListView) return _queue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_queue);
  }

  @override
  @JsonKey()
  final bool isPlaying;
  @override
  @JsonKey()
  final bool isDragging;
  @override
  final double? dragProgress;
  @override
  final Duration? dragPosition;
  @override
  @JsonKey()
  final double progress;
  @override
  @JsonKey()
  final Duration position;
  @override
  @JsonKey()
  final Duration duration;

  @override
  String toString() {
    return 'TrackAudioState(isPreparing: $isPreparing, isPrepared: $isPrepared, preparedTrackId: $preparedTrackId, preparedTrackUrl: $preparedTrackUrl, currentTrack: $currentTrack, queue: $queue, isPlaying: $isPlaying, isDragging: $isDragging, dragProgress: $dragProgress, dragPosition: $dragPosition, progress: $progress, position: $position, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackAudioStateImpl &&
            (identical(other.isPreparing, isPreparing) ||
                other.isPreparing == isPreparing) &&
            (identical(other.isPrepared, isPrepared) ||
                other.isPrepared == isPrepared) &&
            (identical(other.preparedTrackId, preparedTrackId) ||
                other.preparedTrackId == preparedTrackId) &&
            (identical(other.preparedTrackUrl, preparedTrackUrl) ||
                other.preparedTrackUrl == preparedTrackUrl) &&
            (identical(other.currentTrack, currentTrack) ||
                other.currentTrack == currentTrack) &&
            const DeepCollectionEquality().equals(other._queue, _queue) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.isDragging, isDragging) ||
                other.isDragging == isDragging) &&
            (identical(other.dragProgress, dragProgress) ||
                other.dragProgress == dragProgress) &&
            (identical(other.dragPosition, dragPosition) ||
                other.dragPosition == dragPosition) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isPreparing,
    isPrepared,
    preparedTrackId,
    preparedTrackUrl,
    currentTrack,
    const DeepCollectionEquality().hash(_queue),
    isPlaying,
    isDragging,
    dragProgress,
    dragPosition,
    progress,
    position,
    duration,
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
    final bool isPreparing,
    final bool isPrepared,
    final int? preparedTrackId,
    final String? preparedTrackUrl,
    final Track? currentTrack,
    final List<Track> queue,
    final bool isPlaying,
    final bool isDragging,
    final double? dragProgress,
    final Duration? dragPosition,
    final double progress,
    final Duration position,
    final Duration duration,
  }) = _$TrackAudioStateImpl;

  @override
  bool get isPreparing;
  @override
  bool get isPrepared;
  @override
  int? get preparedTrackId;
  @override
  String? get preparedTrackUrl;

  /// The full track entity for the currently prepared track.
  /// Populated by [TrackAudioNotifier.initializeForTrack] so that any
  /// widget (desktop bar, mobile mini-player, etc.) can access cover art,
  /// display name, like status, etc. without a separate lookup.
  @override
  Track? get currentTrack;

  /// Playback queue used for skip next/previous (based on where playback started).
  @override
  List<Track> get queue;
  @override
  bool get isPlaying;
  @override
  bool get isDragging;
  @override
  double? get dragProgress;
  @override
  Duration? get dragPosition;
  @override
  double get progress;
  @override
  Duration get position;
  @override
  Duration get duration;

  /// Create a copy of TrackAudioState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackAudioStateImplCopyWith<_$TrackAudioStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
