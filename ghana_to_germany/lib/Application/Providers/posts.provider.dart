import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IAuthProvider.dart';
import 'package:ghana_to_germany/Application/Providers/shared/errorNotifier.mixin.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/addComment.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/addPost.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getComments.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getPosts.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/likePost.usecase.dart';
import 'package:ghana_to_germany/Domain/Comment/comment.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';
import 'package:ghana_to_germany/Infrastructure/Services/DioHttpClient.dart';
import 'shared/form_status.dart';
import 'dart:developer' as developer;

class PostsViewModel extends ChangeNotifier with ErrorNotifierMixin {
  final GetPostsUseCase getPostsUseCase;
  final AddPostUseCase addPostUseCase;
  final LikePostUseCase likePostUseCase;
  final AddCommentUseCase addCommentUseCase;
  final GetCommentsUseCase getCommentsUseCase;

  final IAuthProvider authProvider;

  PostsViewModel(
      {required this.getPostsUseCase,
      required this.addPostUseCase,
      required this.likePostUseCase,
      required this.authProvider,
      required this.addCommentUseCase,
      required this.getCommentsUseCase});

  FormStatus _status = FormStatus.INIT;
  FormStatus _addPostStatus = FormStatus.INIT;
  FormStatus _addCommentStatus = FormStatus.INIT;

  FormStatus get status => _status;
  FormStatus get addPostStatus => _addPostStatus;
  FormStatus get addCommentStatus => _addCommentStatus;

  bool _logout = false;
  bool get logout => _logout;

  final TextEditingController _contentController = TextEditingController();
  TextEditingController get contentController => _contentController;

  final TextEditingController _commentController = TextEditingController();
  TextEditingController get commentController => _commentController;

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  final List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  final List<String> _likedPosts = [];
  List<String> get likedPosts => _likedPosts;

  Future<void> getPosts() async {
    try {
      _status = FormStatus.LOADING;
      notifyListeners();

      var data = await getPostsUseCase.execute(Nothing());
      _posts.clear();
      _posts.addAll(data);

      for (var p in data) {
        if (p.isLiked) {
          _likedPosts.add(p.id);
        }
      }

      // no error
      _status = FormStatus.SUCCESSFUL;
      notifyListeners();
    } on ForbiddenException {
      await authProvider.logout();
      _logout = true;

      notifyListeners();
    } catch (e) {
      _status = FormStatus.FAILED;

      notifyError(e.toString());
      notifyListeners();
    }
  }

  void receiveCreatedPost(Post post) {
    developer.log("Add Post ${post.id} to posts");
    _posts = [..._posts, post]; // Create a new list
    notifyListeners();
  }

  Future addPost(String tag) async {
    try {
      _addPostStatus = FormStatus.LOADING;
      notifyListeners();

      var payload =
          AddPostPayload(content: _contentController.value.text, tag: tag);
      await addPostUseCase.execute(payload);

      _addPostStatus = FormStatus.SUCCESSFUL;
      developer.log("Added successfully");
      notifyListeners();
    } catch (e) {
      _addPostStatus = FormStatus.FAILED;

      notifyError(e.toString());
      notifyListeners();
    }
  }

  Future<void> likePost(String postId) async {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex == -1) return;

    final post = _posts[postIndex];
    final wasLiked = post.isLiked;

    // Optimistic update
    _posts[postIndex] = Post(
        id: post.id,
        title: post.title,
        content: post.content,
        likeCount: post.likeCount! + (wasLiked ? -1 : 1),
        isLiked: !wasLiked,
        type: post.type,
        dateCreated: post.dateCreated,
        owner: post.owner,
        bookmarkCount: post.bookmarkCount,
        commentCount: post.commentCount);

    notifyListeners();

    await likePostUseCase.execute(postId);
  }

  Future addComment(String postId) async {
    try {

      if (_commentController.value.text.isEmpty) {
        return;
      }

      _addCommentStatus = FormStatus.LOADING;
      notifyListeners();

      var payload = AddCommentPayload(
          content: _commentController.value.text, postId: postId);
      await addCommentUseCase.execute(payload);

      _addCommentStatus = FormStatus.SUCCESSFUL;
      _commentController.clear();
      getComments(postId);

      notifyListeners();
    } on ForbiddenException {
      await authProvider.logout();
      _logout = true;

      notifyListeners();
    } catch (e) {
      _status = FormStatus.FAILED;

      notifyError(e.toString());
      notifyListeners();
    }
  }

  Future getComments(String postId) async {
    try {
      _status = FormStatus.LOADING;
      notifyListeners();

      var data = await getCommentsUseCase.execute(postId);
      _comments.clear();
      _comments.addAll(data);

      // no error
      _status = FormStatus.SUCCESSFUL;
      notifyListeners();
    } on ForbiddenException {
      await authProvider.logout();
      _logout = true;

      notifyListeners();
    } catch (e) {
      _status = FormStatus.FAILED;

      notifyError(e.toString());
      notifyListeners();
    }
  }

  void resetState() {
    _addPostStatus = FormStatus.INIT;
    _status = FormStatus.INIT;

    _contentController.clear();

    notifyListeners();
  }
}
