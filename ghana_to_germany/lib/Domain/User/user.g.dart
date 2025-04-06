// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      nickname: json['nickname'] as String,
      fullName: json['fullName'] as String,
      profilePhoto: json['profilePhoto'] as String?,
      photos: json['photos'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'fullName': instance.fullName,
      'profilePhoto': instance.profilePhoto,
      'photos': instance.photos,
    };
