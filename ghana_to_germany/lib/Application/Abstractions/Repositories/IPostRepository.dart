import 'package:ghana_to_germany/Application/UseCases/addComment.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/addPost.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/addWiki.usecase.dart';
import 'package:ghana_to_germany/Domain/Comment/comment.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';
import 'package:ghana_to_germany/Domain/Tag/tag.dart';

abstract class IPostRepository {
  Future<List<Post>> getPosts();
  Future<List<Post>> getNews();
  Future<List<Post>> getWikis();
  Future<List<Tag>> getTags();
  Future<Post> addPost(AddPostPayload entity );
  Future<Post> addWiki(AddWikiPayload entity);
  Future<Post> likePost(String postId);
  Future<List<Post>> searchPost(String query);
  Future addPostComment(AddCommentPayload comment);
  Future<List<Comment>> getComments(String postId);
}