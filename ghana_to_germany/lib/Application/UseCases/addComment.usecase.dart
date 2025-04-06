import 'package:ghana_to_germany/Application/Abstractions/Repositories/IPostRepository.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';

class AddCommentUseCase extends UseCase<AddCommentPayload, void> {
  final IPostRepository postRepository;

  AddCommentUseCase({ required this.postRepository });

  @override
  Future execute(AddCommentPayload payload) async {
    await postRepository.addPostComment(payload);
  }
}


class AddCommentPayload {
  String content;
  String postId;

  AddCommentPayload({ required this.content, required this.postId });

  Map<String, dynamic> toJson() {
    return {
      "content": content
    };
  }
}