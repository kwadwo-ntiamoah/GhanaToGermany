// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      key: json['key'] as String,
      expiryMinutes: (json['expiryMinutes'] as num).toInt(),
      email: json['email'] as String,
      pendingProfileUpdate: json['pendingProfileUpdate'] as bool,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'key': instance.key,
      'email': instance.email,
      'expiryMinutes': instance.expiryMinutes,
      'pendingProfileUpdate': instance.pendingProfileUpdate,
    };
