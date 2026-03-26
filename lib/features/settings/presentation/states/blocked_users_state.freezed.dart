// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_users_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BlockedUsersState {
  List<BlockedUser> get users => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get hasReachedMax => throw _privateConstructorUsedError;
  Set<String> get unblockingIds =>
      throw _privateConstructorUsedError; // Track specific row loading
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of BlockedUsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockedUsersStateCopyWith<BlockedUsersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockedUsersStateCopyWith<$Res> {
  factory $BlockedUsersStateCopyWith(
    BlockedUsersState value,
    $Res Function(BlockedUsersState) then,
  ) = _$BlockedUsersStateCopyWithImpl<$Res, BlockedUsersState>;
  @useResult
  $Res call({
    List<BlockedUser> users,
    bool isLoading,
    int currentPage,
    bool hasReachedMax,
    Set<String> unblockingIds,
    String? errorMessage,
  });
}

/// @nodoc
class _$BlockedUsersStateCopyWithImpl<$Res, $Val extends BlockedUsersState>
    implements $BlockedUsersStateCopyWith<$Res> {
  _$BlockedUsersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockedUsersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? isLoading = null,
    Object? currentPage = null,
    Object? hasReachedMax = null,
    Object? unblockingIds = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            users: null == users
                ? _value.users
                : users // ignore: cast_nullable_to_non_nullable
                      as List<BlockedUser>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            hasReachedMax: null == hasReachedMax
                ? _value.hasReachedMax
                : hasReachedMax // ignore: cast_nullable_to_non_nullable
                      as bool,
            unblockingIds: null == unblockingIds
                ? _value.unblockingIds
                : unblockingIds // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BlockedUsersStateImplCopyWith<$Res>
    implements $BlockedUsersStateCopyWith<$Res> {
  factory _$$BlockedUsersStateImplCopyWith(
    _$BlockedUsersStateImpl value,
    $Res Function(_$BlockedUsersStateImpl) then,
  ) = __$$BlockedUsersStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<BlockedUser> users,
    bool isLoading,
    int currentPage,
    bool hasReachedMax,
    Set<String> unblockingIds,
    String? errorMessage,
  });
}

/// @nodoc
class __$$BlockedUsersStateImplCopyWithImpl<$Res>
    extends _$BlockedUsersStateCopyWithImpl<$Res, _$BlockedUsersStateImpl>
    implements _$$BlockedUsersStateImplCopyWith<$Res> {
  __$$BlockedUsersStateImplCopyWithImpl(
    _$BlockedUsersStateImpl _value,
    $Res Function(_$BlockedUsersStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlockedUsersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? isLoading = null,
    Object? currentPage = null,
    Object? hasReachedMax = null,
    Object? unblockingIds = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$BlockedUsersStateImpl(
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<BlockedUser>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        hasReachedMax: null == hasReachedMax
            ? _value.hasReachedMax
            : hasReachedMax // ignore: cast_nullable_to_non_nullable
                  as bool,
        unblockingIds: null == unblockingIds
            ? _value._unblockingIds
            : unblockingIds // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$BlockedUsersStateImpl implements _BlockedUsersState {
  const _$BlockedUsersStateImpl({
    final List<BlockedUser> users = const [],
    this.isLoading = false,
    this.currentPage = 0,
    this.hasReachedMax = false,
    final Set<String> unblockingIds = const {},
    this.errorMessage,
  }) : _users = users,
       _unblockingIds = unblockingIds;

  final List<BlockedUser> _users;
  @override
  @JsonKey()
  List<BlockedUser> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool hasReachedMax;
  final Set<String> _unblockingIds;
  @override
  @JsonKey()
  Set<String> get unblockingIds {
    if (_unblockingIds is EqualUnmodifiableSetView) return _unblockingIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_unblockingIds);
  }

  // Track specific row loading
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'BlockedUsersState(users: $users, isLoading: $isLoading, currentPage: $currentPage, hasReachedMax: $hasReachedMax, unblockingIds: $unblockingIds, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockedUsersStateImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax) &&
            const DeepCollectionEquality().equals(
              other._unblockingIds,
              _unblockingIds,
            ) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_users),
    isLoading,
    currentPage,
    hasReachedMax,
    const DeepCollectionEquality().hash(_unblockingIds),
    errorMessage,
  );

  /// Create a copy of BlockedUsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockedUsersStateImplCopyWith<_$BlockedUsersStateImpl> get copyWith =>
      __$$BlockedUsersStateImplCopyWithImpl<_$BlockedUsersStateImpl>(
        this,
        _$identity,
      );
}

abstract class _BlockedUsersState implements BlockedUsersState {
  const factory _BlockedUsersState({
    final List<BlockedUser> users,
    final bool isLoading,
    final int currentPage,
    final bool hasReachedMax,
    final Set<String> unblockingIds,
    final String? errorMessage,
  }) = _$BlockedUsersStateImpl;

  @override
  List<BlockedUser> get users;
  @override
  bool get isLoading;
  @override
  int get currentPage;
  @override
  bool get hasReachedMax;
  @override
  Set<String> get unblockingIds; // Track specific row loading
  @override
  String? get errorMessage;

  /// Create a copy of BlockedUsersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockedUsersStateImplCopyWith<_$BlockedUsersStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
