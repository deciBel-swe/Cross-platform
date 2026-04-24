// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get id => throw _privateConstructorUsedError;
  String? get conversationId => throw _privateConstructorUsedError;
  int get senderId => throw _privateConstructorUsedError;
  int? get recipientId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonEnum(alwaysCreate: true)
  ResourceType? get resourceType => throw _privateConstructorUsedError;
  int? get resourceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'timestamp', fromJson: _parseCreatedAt)
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
    MessageModel value,
    $Res Function(MessageModel) then,
  ) = _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call({
    String id,
    String? conversationId,
    int senderId,
    int? recipientId,
    String content,
    @JsonEnum(alwaysCreate: true) ResourceType? resourceType,
    int? resourceId,
    @JsonKey(name: 'timestamp', fromJson: _parseCreatedAt) DateTime createdAt,
    bool isRead,
  });
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = freezed,
    Object? senderId = null,
    Object? recipientId = freezed,
    Object? content = null,
    Object? resourceType = freezed,
    Object? resourceId = freezed,
    Object? createdAt = null,
    Object? isRead = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            conversationId: freezed == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as int,
            recipientId: freezed == recipientId
                ? _value.recipientId
                : recipientId // ignore: cast_nullable_to_non_nullable
                      as int?,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            resourceType: freezed == resourceType
                ? _value.resourceType
                : resourceType // ignore: cast_nullable_to_non_nullable
                      as ResourceType?,
            resourceId: freezed == resourceId
                ? _value.resourceId
                : resourceId // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
    _$MessageModelImpl value,
    $Res Function(_$MessageModelImpl) then,
  ) = __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? conversationId,
    int senderId,
    int? recipientId,
    String content,
    @JsonEnum(alwaysCreate: true) ResourceType? resourceType,
    int? resourceId,
    @JsonKey(name: 'timestamp', fromJson: _parseCreatedAt) DateTime createdAt,
    bool isRead,
  });
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
    _$MessageModelImpl _value,
    $Res Function(_$MessageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = freezed,
    Object? senderId = null,
    Object? recipientId = freezed,
    Object? content = null,
    Object? resourceType = freezed,
    Object? resourceId = freezed,
    Object? createdAt = null,
    Object? isRead = null,
  }) {
    return _then(
      _$MessageModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        conversationId: freezed == conversationId
            ? _value.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as int,
        recipientId: freezed == recipientId
            ? _value.recipientId
            : recipientId // ignore: cast_nullable_to_non_nullable
                  as int?,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        resourceType: freezed == resourceType
            ? _value.resourceType
            : resourceType // ignore: cast_nullable_to_non_nullable
                  as ResourceType?,
        resourceId: freezed == resourceId
            ? _value.resourceId
            : resourceId // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl implements _MessageModel {
  const _$MessageModelImpl({
    required this.id,
    this.conversationId,
    required this.senderId,
    this.recipientId,
    required this.content,
    @JsonEnum(alwaysCreate: true) this.resourceType,
    this.resourceId,
    @JsonKey(name: 'timestamp', fromJson: _parseCreatedAt)
    required this.createdAt,
    this.isRead = false,
  });

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String id;
  @override
  final String? conversationId;
  @override
  final int senderId;
  @override
  final int? recipientId;
  @override
  final String content;
  @override
  @JsonEnum(alwaysCreate: true)
  final ResourceType? resourceType;
  @override
  final int? resourceId;
  @override
  @JsonKey(name: 'timestamp', fromJson: _parseCreatedAt)
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isRead;

  @override
  String toString() {
    return 'MessageModel(id: $id, conversationId: $conversationId, senderId: $senderId, recipientId: $recipientId, content: $content, resourceType: $resourceType, resourceId: $resourceId, createdAt: $createdAt, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType) &&
            (identical(other.resourceId, resourceId) ||
                other.resourceId == resourceId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    conversationId,
    senderId,
    recipientId,
    content,
    resourceType,
    resourceId,
    createdAt,
    isRead,
  );

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(this);
  }
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel({
    required final String id,
    final String? conversationId,
    required final int senderId,
    final int? recipientId,
    required final String content,
    @JsonEnum(alwaysCreate: true) final ResourceType? resourceType,
    final int? resourceId,
    @JsonKey(name: 'timestamp', fromJson: _parseCreatedAt)
    required final DateTime createdAt,
    final bool isRead,
  }) = _$MessageModelImpl;

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  String get id;
  @override
  String? get conversationId;
  @override
  int get senderId;
  @override
  int? get recipientId;
  @override
  String get content;
  @override
  @JsonEnum(alwaysCreate: true)
  ResourceType? get resourceType;
  @override
  int? get resourceId;
  @override
  @JsonKey(name: 'timestamp', fromJson: _parseCreatedAt)
  DateTime get createdAt;
  @override
  bool get isRead;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
