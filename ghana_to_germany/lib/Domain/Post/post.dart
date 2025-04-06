import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart'; // This part directive is needed for code generation

@JsonSerializable() // This annotation indicates that the class can be serialized
class Post {
  final String id, title, content, type, owner, dateCreated;
  final String? thumbnail, tag;
  final bool isLiked;
  final num? likeCount, bookmarkCount, commentCount;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.owner,
    required this.dateCreated,
    required this.isLiked,
    required this.likeCount,
    required this.bookmarkCount,
    required this.commentCount,
    this.thumbnail,
    this.tag
  });


  static List<Post> postsFromJson(List<dynamic> json) {
    return json.map((post) => Post.fromJson(post)).toList();
  }

  // Factory method to create a User from a JSON map
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  // Method to convert a User to a JSON map
  Map<String, dynamic> toJson() => _$PostToJson(this);
}