import 'package:ghana_to_germany/Application/Abstractions/Repositories/IPostRepository.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';

class AddWikiUseCase extends UseCase<AddWikiPayload, Post> {
  final IPostRepository postRepository;

  AddWikiUseCase({ required this.postRepository });

  @override
  Future<Post> execute(AddWikiPayload payload) async {
    var data = await postRepository.addWiki(payload);

    return data;
  }
}

class AddWikiPayload {
  String content, tag;

  AddWikiPayload({ required this.content, required this.tag });

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "tag": tag,
      "title": tag
    };
  }
}

