// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      fullName: json['fullName'] as String,
      profilePhoto: json['profilePhoto'] as String,
      photos: json['photos'] as String,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'email': instance.email,
      'nickname': instance.nickname,
      'fullName': instance.fullName,
      'profilePhoto': instance.profilePhoto,
      'photos': instance.photos,
    };
