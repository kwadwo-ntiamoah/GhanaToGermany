import 'package:ghana_to_germany/Application/Abstractions/Repositories/IPostRepository.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IHttpClient.dart';
import 'package:ghana_to_germany/Application/UseCases/addComment.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/addPost.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/addWiki.usecase.dart';
import 'package:ghana_to_germany/Domain/Comment/comment.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';

import 'package:ghana_to_germany/Domain/Tag/tag.dart';

class PostRepository implements IPostRepository {
  final IHttpClient httpClient;

  PostRepository({ required this.httpClient });

  @override
  Future<List<Post>> getNews() async {
    var route = "news";

    var res = await httpClient.get(route);
    var news = Post.postsFromJson(res);
    
    return news;
  }

  @override
  Future<List<Post>> getPosts() async {
    var route = "post";

    var res = await httpClient.get(route);
    var posts = Post.postsFromJson(res);
    
    return posts;
  }

  @override
  Future<List<Post>> getWikis() async {
    var route = "wiki";
    
    var res = await httpClient.get(route);
    var wikis = Post.postsFromJson(res);
    
    return wikis;
  }

  @override
  Future<List<Tag>> getTags() async {
    var route = "tags";
    
    var res = await httpClient.get(route);
    var tags = Tag.tagsFromJson(res);

    return tags;
  }

  @override
  Future<Post> addPost(AddPostPayload entity) async{
    var route = "post";

    var res = await httpClient.post(route, entity.toJson());
    var post = Post.fromJson(res);

    return post;
  }

  @override
  Future<Post> addWiki(AddWikiPayload entity) async {
    var route = "wiki";

    var res = await httpClient.post(route, entity.toJson());
    var post = Post.fromJson(res);

    return post;
  }

  @override
  Future<Post> likePost(String postId) async {
    var route = "post/toggleLike?postId=$postId";
    var res = await httpClient.post(route, {});
    var post = Post.fromJson(res);

    return post;
  }

  @override
  Future<List<Post>> searchPost(String query) async {
    var route = "search?query=$query";
    var res = await httpClient.get(route);
    var posts = Post.postsFromJson(res);

    return posts;
  }

  @override
  Future addPostComment(AddCommentPayload payload) async{
    var route = "post/comment?postId=${payload.postId}";
    await httpClient.post(route, payload.toJson());
  }

  @override
  Future<List<Comment>> getComments(String postId) async {
    var route = "post/comment?postId=$postId";
    var res = await httpClient.get(route);

    var comments = Comment.commentsFromJson(res);
    return comments;
  }

}