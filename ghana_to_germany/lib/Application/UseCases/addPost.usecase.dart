import 'package:ghana_to_germany/Application/Abstractions/Repositories/IPostRepository.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';

class AddPostUseCase extends UseCase<AddPostPayload, Post> {
  final IPostRepository postRepository;

  AddPostUseCase({ required this.postRepository });

  @override
  Future<Post> execute(AddPostPayload payload) async {
    var data = await postRepository.addPost(payload);
    return data;
  }

}

class AddPostPayload {
  String content, tag;

  AddPostPayload({ required this.content, required this.tag });

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "tag": tag,
      "title": tag
    };
  }
}