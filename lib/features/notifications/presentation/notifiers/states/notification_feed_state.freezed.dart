// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NotificationFeedState {
  List<ActivityNotification> get notifications =>
      throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get isLastPage => throw _privateConstructorUsedError;
  bool get isFetchingNextPage => throw _privateConstructorUsedError;

  /// Create a copy of NotificationFeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationFeedStateCopyWith<NotificationFeedState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationFeedStateCopyWith<$Res> {
  factory $NotificationFeedStateCopyWith(
    NotificationFeedState value,
    $Res Function(NotificationFeedState) then,
  ) = _$NotificationFeedStateCopyWithImpl<$Res, NotificationFeedState>;
  @useResult
  $Res call({
    List<ActivityNotification> notifications,
    int currentPage,
    bool isLastPage,
    bool isFetchingNextPage,
  });
}

/// @nodoc
class _$NotificationFeedStateCopyWithImpl<
  $Res,
  $Val extends NotificationFeedState
>
    implements $NotificationFeedStateCopyWith<$Res> {
  _$NotificationFeedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationFeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? currentPage = null,
    Object? isLastPage = null,
    Object? isFetchingNextPage = null,
  }) {
    return _then(
      _value.copyWith(
            notifications: null == notifications
                ? _value.notifications
                : notifications // ignore: cast_nullable_to_non_nullable
                      as List<ActivityNotification>,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            isLastPage: null == isLastPage
                ? _value.isLastPage
                : isLastPage // ignore: cast_nullable_to_non_nullable
                      as bool,
            isFetchingNextPage: null == isFetchingNextPage
                ? _value.isFetchingNextPage
                : isFetchingNextPage // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationFeedStateImplCopyWith<$Res>
    implements $NotificationFeedStateCopyWith<$Res> {
  factory _$$NotificationFeedStateImplCopyWith(
    _$NotificationFeedStateImpl value,
    $Res Function(_$NotificationFeedStateImpl) then,
  ) = __$$NotificationFeedStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ActivityNotification> notifications,
    int currentPage,
    bool isLastPage,
    bool isFetchingNextPage,
  });
}

/// @nodoc
class __$$NotificationFeedStateImplCopyWithImpl<$Res>
    extends
        _$NotificationFeedStateCopyWithImpl<$Res, _$NotificationFeedStateImpl>
    implements _$$NotificationFeedStateImplCopyWith<$Res> {
  __$$NotificationFeedStateImplCopyWithImpl(
    _$NotificationFeedStateImpl _value,
    $Res Function(_$NotificationFeedStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationFeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? currentPage = null,
    Object? isLastPage = null,
    Object? isFetchingNextPage = null,
  }) {
    return _then(
      _$NotificationFeedStateImpl(
        notifications: null == notifications
            ? _value._notifications
            : notifications // ignore: cast_nullable_to_non_nullable
                  as List<ActivityNotification>,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        isLastPage: null == isLastPage
            ? _value.isLastPage
            : isLastPage // ignore: cast_nullable_to_non_nullable
                  as bool,
        isFetchingNextPage: null == isFetchingNextPage
            ? _value.isFetchingNextPage
            : isFetchingNextPage // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$NotificationFeedStateImpl implements _NotificationFeedState {
  const _$NotificationFeedStateImpl({
    final List<ActivityNotification> notifications = const [],
    this.currentPage = 0,
    this.isLastPage = false,
    this.isFetchingNextPage = false,
  }) : _notifications = notifications;

  final List<ActivityNotification> _notifications;
  @override
  @JsonKey()
  List<ActivityNotification> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool isLastPage;
  @override
  @JsonKey()
  final bool isFetchingNextPage;

  @override
  String toString() {
    return 'NotificationFeedState(notifications: $notifications, currentPage: $currentPage, isLastPage: $isLastPage, isFetchingNextPage: $isFetchingNextPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationFeedStateImpl &&
            const DeepCollectionEquality().equals(
              other._notifications,
              _notifications,
            ) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.isLastPage, isLastPage) ||
                other.isLastPage == isLastPage) &&
            (identical(other.isFetchingNextPage, isFetchingNextPage) ||
                other.isFetchingNextPage == isFetchingNextPage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_notifications),
    currentPage,
    isLastPage,
    isFetchingNextPage,
  );

  /// Create a copy of NotificationFeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationFeedStateImplCopyWith<_$NotificationFeedStateImpl>
  get copyWith =>
      __$$NotificationFeedStateImplCopyWithImpl<_$NotificationFeedStateImpl>(
        this,
        _$identity,
      );
}

abstract class _NotificationFeedState implements NotificationFeedState {
  const factory _NotificationFeedState({
    final List<ActivityNotification> notifications,
    final int currentPage,
    final bool isLastPage,
    final bool isFetchingNextPage,
  }) = _$NotificationFeedStateImpl;

  @override
  List<ActivityNotification> get notifications;
  @override
  int get currentPage;
  @override
  bool get isLastPage;
  @override
  bool get isFetchingNextPage;

  /// Create a copy of NotificationFeedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationFeedStateImplCopyWith<_$NotificationFeedStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
