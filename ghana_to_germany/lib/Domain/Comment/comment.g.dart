// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      postId: json['postId'] as String,
      owner: json['owner'] as String,
      content: json['content'] as String,
      dateCreated: json['dateCreated'] as String,
      isDeleted: json['isDeleted'] as bool,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'owner': instance.owner,
      'content': instance.content,
      'dateCreated': instance.dateCreated,
      'isDeleted': instance.isDeleted,
    };
