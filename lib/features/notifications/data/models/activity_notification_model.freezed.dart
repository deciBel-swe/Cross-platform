// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationUserModel _$NotificationUserModelFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationUserModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationUserModel {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this NotificationUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationUserModelCopyWith<NotificationUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationUserModelCopyWith<$Res> {
  factory $NotificationUserModelCopyWith(
    NotificationUserModel value,
    $Res Function(NotificationUserModel) then,
  ) = _$NotificationUserModelCopyWithImpl<$Res, NotificationUserModel>;
  @useResult
  $Res call({int id, String username, String? displayName, String? avatarUrl});
}

/// @nodoc
class _$NotificationUserModelCopyWithImpl<
  $Res,
  $Val extends NotificationUserModel
>
    implements $NotificationUserModelCopyWith<$Res> {
  _$NotificationUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationUserModelImplCopyWith<$Res>
    implements $NotificationUserModelCopyWith<$Res> {
  factory _$$NotificationUserModelImplCopyWith(
    _$NotificationUserModelImpl value,
    $Res Function(_$NotificationUserModelImpl) then,
  ) = __$$NotificationUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String username, String? displayName, String? avatarUrl});
}

/// @nodoc
class __$$NotificationUserModelImplCopyWithImpl<$Res>
    extends
        _$NotificationUserModelCopyWithImpl<$Res, _$NotificationUserModelImpl>
    implements _$$NotificationUserModelImplCopyWith<$Res> {
  __$$NotificationUserModelImplCopyWithImpl(
    _$NotificationUserModelImpl _value,
    $Res Function(_$NotificationUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(
      _$NotificationUserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationUserModelImpl implements _NotificationUserModel {
  const _$NotificationUserModelImpl({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
  });

  factory _$NotificationUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationUserModelImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  final String? displayName;
  @override
  final String? avatarUrl;

  @override
  String toString() {
    return 'NotificationUserModel(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, username, displayName, avatarUrl);

  /// Create a copy of NotificationUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationUserModelImplCopyWith<_$NotificationUserModelImpl>
  get copyWith =>
      __$$NotificationUserModelImplCopyWithImpl<_$NotificationUserModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationUserModelImplToJson(this);
  }
}

abstract class _NotificationUserModel implements NotificationUserModel {
  const factory _NotificationUserModel({
    required final int id,
    required final String username,
    final String? displayName,
    final String? avatarUrl,
  }) = _$NotificationUserModelImpl;

  factory _NotificationUserModel.fromJson(Map<String, dynamic> json) =
      _$NotificationUserModelImpl.fromJson;

  @override
  int get id;
  @override
  String get username;
  @override
  String? get displayName;
  @override
  String? get avatarUrl;

  /// Create a copy of NotificationUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationUserModelImplCopyWith<_$NotificationUserModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

NotificationResourceModel _$NotificationResourceModelFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationResourceModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationResourceModel {
  String get resourceType => throw _privateConstructorUsedError;
  int get resourceId => throw _privateConstructorUsedError;

  /// Serializes this NotificationResourceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationResourceModelCopyWith<NotificationResourceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationResourceModelCopyWith<$Res> {
  factory $NotificationResourceModelCopyWith(
    NotificationResourceModel value,
    $Res Function(NotificationResourceModel) then,
  ) = _$NotificationResourceModelCopyWithImpl<$Res, NotificationResourceModel>;
  @useResult
  $Res call({String resourceType, int resourceId});
}

/// @nodoc
class _$NotificationResourceModelCopyWithImpl<
  $Res,
  $Val extends NotificationResourceModel
>
    implements $NotificationResourceModelCopyWith<$Res> {
  _$NotificationResourceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? resourceType = null, Object? resourceId = null}) {
    return _then(
      _value.copyWith(
            resourceType: null == resourceType
                ? _value.resourceType
                : resourceType // ignore: cast_nullable_to_non_nullable
                      as String,
            resourceId: null == resourceId
                ? _value.resourceId
                : resourceId // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationResourceModelImplCopyWith<$Res>
    implements $NotificationResourceModelCopyWith<$Res> {
  factory _$$NotificationResourceModelImplCopyWith(
    _$NotificationResourceModelImpl value,
    $Res Function(_$NotificationResourceModelImpl) then,
  ) = __$$NotificationResourceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String resourceType, int resourceId});
}

/// @nodoc
class __$$NotificationResourceModelImplCopyWithImpl<$Res>
    extends
        _$NotificationResourceModelCopyWithImpl<
          $Res,
          _$NotificationResourceModelImpl
        >
    implements _$$NotificationResourceModelImplCopyWith<$Res> {
  __$$NotificationResourceModelImplCopyWithImpl(
    _$NotificationResourceModelImpl _value,
    $Res Function(_$NotificationResourceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? resourceType = null, Object? resourceId = null}) {
    return _then(
      _$NotificationResourceModelImpl(
        resourceType: null == resourceType
            ? _value.resourceType
            : resourceType // ignore: cast_nullable_to_non_nullable
                  as String,
        resourceId: null == resourceId
            ? _value.resourceId
            : resourceId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationResourceModelImpl implements _NotificationResourceModel {
  const _$NotificationResourceModelImpl({
    required this.resourceType,
    required this.resourceId,
  });

  factory _$NotificationResourceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationResourceModelImplFromJson(json);

  @override
  final String resourceType;
  @override
  final int resourceId;

  @override
  String toString() {
    return 'NotificationResourceModel(resourceType: $resourceType, resourceId: $resourceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationResourceModelImpl &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType) &&
            (identical(other.resourceId, resourceId) ||
                other.resourceId == resourceId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, resourceType, resourceId);

  /// Create a copy of NotificationResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationResourceModelImplCopyWith<_$NotificationResourceModelImpl>
  get copyWith =>
      __$$NotificationResourceModelImplCopyWithImpl<
        _$NotificationResourceModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationResourceModelImplToJson(this);
  }
}

abstract class _NotificationResourceModel implements NotificationResourceModel {
  const factory _NotificationResourceModel({
    required final String resourceType,
    required final int resourceId,
  }) = _$NotificationResourceModelImpl;

  factory _NotificationResourceModel.fromJson(Map<String, dynamic> json) =
      _$NotificationResourceModelImpl.fromJson;

  @override
  String get resourceType;
  @override
  int get resourceId;

  /// Create a copy of NotificationResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationResourceModelImplCopyWith<_$NotificationResourceModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ActivityNotificationModel _$ActivityNotificationModelFromJson(
  Map<String, dynamic> json,
) {
  return _ActivityNotificationModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityNotificationModel {
  int get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  NotificationUserModel get user => throw _privateConstructorUsedError;
  NotificationResourceModel get resource => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ActivityNotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityNotificationModelCopyWith<ActivityNotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityNotificationModelCopyWith<$Res> {
  factory $ActivityNotificationModelCopyWith(
    ActivityNotificationModel value,
    $Res Function(ActivityNotificationModel) then,
  ) = _$ActivityNotificationModelCopyWithImpl<$Res, ActivityNotificationModel>;
  @useResult
  $Res call({
    int id,
    String type,
    NotificationUserModel user,
    NotificationResourceModel resource,
    bool isRead,
    DateTime createdAt,
  });

  $NotificationUserModelCopyWith<$Res> get user;
  $NotificationResourceModelCopyWith<$Res> get resource;
}

/// @nodoc
class _$ActivityNotificationModelCopyWithImpl<
  $Res,
  $Val extends ActivityNotificationModel
>
    implements $ActivityNotificationModelCopyWith<$Res> {
  _$ActivityNotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? user = null,
    Object? resource = null,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as NotificationUserModel,
            resource: null == resource
                ? _value.resource
                : resource // ignore: cast_nullable_to_non_nullable
                      as NotificationResourceModel,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of ActivityNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotificationUserModelCopyWith<$Res> get user {
    return $NotificationUserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of ActivityNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotificationResourceModelCopyWith<$Res> get resource {
    return $NotificationResourceModelCopyWith<$Res>(_value.resource, (value) {
      return _then(_value.copyWith(resource: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityNotificationModelImplCopyWith<$Res>
    implements $ActivityNotificationModelCopyWith<$Res> {
  factory _$$ActivityNotificationModelImplCopyWith(
    _$ActivityNotificationModelImpl value,
    $Res Function(_$ActivityNotificationModelImpl) then,
  ) = __$$ActivityNotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String type,
    NotificationUserModel user,
    NotificationResourceModel resource,
    bool isRead,
    DateTime createdAt,
  });

  @override
  $NotificationUserModelCopyWith<$Res> get user;
  @override
  $NotificationResourceModelCopyWith<$Res> get resource;
}

/// @nodoc
class __$$ActivityNotificationModelImplCopyWithImpl<$Res>
    extends
        _$ActivityNotificationModelCopyWithImpl<
          $Res,
          _$ActivityNotificationModelImpl
        >
    implements _$$ActivityNotificationModelImplCopyWith<$Res> {
  __$$ActivityNotificationModelImplCopyWithImpl(
    _$ActivityNotificationModelImpl _value,
    $Res Function(_$ActivityNotificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? user = null,
    Object? resource = null,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ActivityNotificationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as NotificationUserModel,
        resource: null == resource
            ? _value.resource
            : resource // ignore: cast_nullable_to_non_nullable
                  as NotificationResourceModel,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityNotificationModelImpl implements _ActivityNotificationModel {
  const _$ActivityNotificationModelImpl({
    required this.id,
    required this.type,
    required this.user,
    required this.resource,
    required this.isRead,
    required this.createdAt,
  });

  factory _$ActivityNotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityNotificationModelImplFromJson(json);

  @override
  final int id;
  @override
  final String type;
  @override
  final NotificationUserModel user;
  @override
  final NotificationResourceModel resource;
  @override
  final bool isRead;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ActivityNotificationModel(id: $id, type: $type, user: $user, resource: $resource, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityNotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.resource, resource) ||
                other.resource == resource) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, user, resource, isRead, createdAt);

  /// Create a copy of ActivityNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityNotificationModelImplCopyWith<_$ActivityNotificationModelImpl>
  get copyWith =>
      __$$ActivityNotificationModelImplCopyWithImpl<
        _$ActivityNotificationModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityNotificationModelImplToJson(this);
  }
}

abstract class _ActivityNotificationModel implements ActivityNotificationModel {
  const factory _ActivityNotificationModel({
    required final int id,
    required final String type,
    required final NotificationUserModel user,
    required final NotificationResourceModel resource,
    required final bool isRead,
    required final DateTime createdAt,
  }) = _$ActivityNotificationModelImpl;

  factory _ActivityNotificationModel.fromJson(Map<String, dynamic> json) =
      _$ActivityNotificationModelImpl.fromJson;

  @override
  int get id;
  @override
  String get type;
  @override
  NotificationUserModel get user;
  @override
  NotificationResourceModel get resource;
  @override
  bool get isRead;
  @override
  DateTime get createdAt;

  /// Create a copy of ActivityNotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityNotificationModelImplCopyWith<_$ActivityNotificationModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
