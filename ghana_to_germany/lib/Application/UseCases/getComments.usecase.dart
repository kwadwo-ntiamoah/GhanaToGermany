import 'package:ghana_to_germany/Application/Abstractions/Repositories/IPostRepository.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Domain/Comment/comment.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';

class GetCommentsUseCase extends UseCase<String, List<Comment>> {
  final IPostRepository postRepository;

  GetCommentsUseCase({ required this.postRepository });

  @override
  Future<List<Comment>> execute(String payload) async{
    var data = await postRepository.getComments(payload);
    return data;
  }

}

