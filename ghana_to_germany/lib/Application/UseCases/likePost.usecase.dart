import 'package:ghana_to_germany/Application/Abstractions/Repositories/IPostRepository.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';

class LikePostUseCase extends UseCase<String, Post> {
  final IPostRepository postRepository;

  LikePostUseCase({ required this.postRepository });

  @override
  Future<Post> execute(String payload) async {
    return await postRepository.likePost(payload);
  }
}