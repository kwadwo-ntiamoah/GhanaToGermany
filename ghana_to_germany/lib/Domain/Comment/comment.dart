import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart'; // This part directive is needed for code generation

@JsonSerializable() // This annotation indicates that the class can be serialized
class Comment {
  final String id, postId, owner, content, dateCreated;
  final bool isDeleted;

  Comment({
    required this.id,
    required this.postId,
    required this.owner,
    required this.content,
    required this.dateCreated,
    required this.isDeleted
  });


  static List<Comment> commentsFromJson(List<dynamic> json) {
    return json.map((comment) => Comment.fromJson(comment)).toList();
  }

  // Factory method to create a User from a JSON map
  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  // Method to convert a User to a JSON map
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}