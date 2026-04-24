// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resend_verification_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResendVerificationResponseModelImpl
_$$ResendVerificationResponseModelImplFromJson(Map<String, dynamic> json) =>
    _$ResendVerificationResponseModelImpl(
      message: json['message'] as String,
      coolDown: (json['coolDown'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ResendVerificationResponseModelImplToJson(
  _$ResendVerificationResponseModelImpl instance,
) => <String, dynamic>{
  'message': instance.message,
  'coolDown': instance.coolDown,
};
