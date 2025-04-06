// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      owner: json['owner'] as String,
      dateCreated: json['dateCreated'] as String,
      isLiked: json['isLiked'] as bool,
      likeCount: json['likeCount'] as num?,
      bookmarkCount: json['bookmarkCount'] as num?,
      commentCount: json['commentCount'] as num?,
      thumbnail: json['thumbnail'] as String?,
      tag: json['tag'] as String?,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'type': instance.type,
      'owner': instance.owner,
      'dateCreated': instance.dateCreated,
      'thumbnail': instance.thumbnail,
      'tag': instance.tag,
      'isLiked': instance.isLiked,
      'likeCount': instance.likeCount,
      'bookmarkCount': instance.bookmarkCount,
      'commentCount': instance.commentCount,
    };
