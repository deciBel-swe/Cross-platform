// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SubscriptionStatus {
  String get status => throw _privateConstructorUsedError;
  String get plan => throw _privateConstructorUsedError;
  DateTime? get currentPeriodEnd => throw _privateConstructorUsedError;
  bool get cancelAtPeriodEnd => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionStatusCopyWith<SubscriptionStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionStatusCopyWith<$Res> {
  factory $SubscriptionStatusCopyWith(
    SubscriptionStatus value,
    $Res Function(SubscriptionStatus) then,
  ) = _$SubscriptionStatusCopyWithImpl<$Res, SubscriptionStatus>;
  @useResult
  $Res call({
    String status,
    String plan,
    DateTime? currentPeriodEnd,
    bool cancelAtPeriodEnd,
  });
}

/// @nodoc
class _$SubscriptionStatusCopyWithImpl<$Res, $Val extends SubscriptionStatus>
    implements $SubscriptionStatusCopyWith<$Res> {
  _$SubscriptionStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? plan = null,
    Object? currentPeriodEnd = freezed,
    Object? cancelAtPeriodEnd = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            plan: null == plan
                ? _value.plan
                : plan // ignore: cast_nullable_to_non_nullable
                      as String,
            currentPeriodEnd: freezed == currentPeriodEnd
                ? _value.currentPeriodEnd
                : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cancelAtPeriodEnd: null == cancelAtPeriodEnd
                ? _value.cancelAtPeriodEnd
                : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubscriptionStatusImplCopyWith<$Res>
    implements $SubscriptionStatusCopyWith<$Res> {
  factory _$$SubscriptionStatusImplCopyWith(
    _$SubscriptionStatusImpl value,
    $Res Function(_$SubscriptionStatusImpl) then,
  ) = __$$SubscriptionStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    String plan,
    DateTime? currentPeriodEnd,
    bool cancelAtPeriodEnd,
  });
}

/// @nodoc
class __$$SubscriptionStatusImplCopyWithImpl<$Res>
    extends _$SubscriptionStatusCopyWithImpl<$Res, _$SubscriptionStatusImpl>
    implements _$$SubscriptionStatusImplCopyWith<$Res> {
  __$$SubscriptionStatusImplCopyWithImpl(
    _$SubscriptionStatusImpl _value,
    $Res Function(_$SubscriptionStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? plan = null,
    Object? currentPeriodEnd = freezed,
    Object? cancelAtPeriodEnd = null,
  }) {
    return _then(
      _$SubscriptionStatusImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        plan: null == plan
            ? _value.plan
            : plan // ignore: cast_nullable_to_non_nullable
                  as String,
        currentPeriodEnd: freezed == currentPeriodEnd
            ? _value.currentPeriodEnd
            : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cancelAtPeriodEnd: null == cancelAtPeriodEnd
            ? _value.cancelAtPeriodEnd
            : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SubscriptionStatusImpl extends _SubscriptionStatus {
  const _$SubscriptionStatusImpl({
    required this.status,
    required this.plan,
    required this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
  }) : super._();

  @override
  final String status;
  @override
  final String plan;
  @override
  final DateTime? currentPeriodEnd;
  @override
  final bool cancelAtPeriodEnd;

  @override
  String toString() {
    return 'SubscriptionStatus(status: $status, plan: $plan, currentPeriodEnd: $currentPeriodEnd, cancelAtPeriodEnd: $cancelAtPeriodEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionStatusImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.plan, plan) || other.plan == plan) &&
            (identical(other.currentPeriodEnd, currentPeriodEnd) ||
                other.currentPeriodEnd == currentPeriodEnd) &&
            (identical(other.cancelAtPeriodEnd, cancelAtPeriodEnd) ||
                other.cancelAtPeriodEnd == cancelAtPeriodEnd));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    plan,
    currentPeriodEnd,
    cancelAtPeriodEnd,
  );

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionStatusImplCopyWith<_$SubscriptionStatusImpl> get copyWith =>
      __$$SubscriptionStatusImplCopyWithImpl<_$SubscriptionStatusImpl>(
        this,
        _$identity,
      );
}

abstract class _SubscriptionStatus extends SubscriptionStatus {
  const factory _SubscriptionStatus({
    required final String status,
    required final String plan,
    required final DateTime? currentPeriodEnd,
    required final bool cancelAtPeriodEnd,
  }) = _$SubscriptionStatusImpl;
  const _SubscriptionStatus._() : super._();

  @override
  String get status;
  @override
  String get plan;
  @override
  DateTime? get currentPeriodEnd;
  @override
  bool get cancelAtPeriodEnd;

  /// Create a copy of SubscriptionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionStatusImplCopyWith<_$SubscriptionStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
