import 'package:ghana_to_germany/Application/Abstractions/Repositories/IPostRepository.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';

class GetWikisUseCase extends UseCase<Nothing, List<Post>> {
  final IPostRepository postRepository;

  GetWikisUseCase({ required this.postRepository });

  @override
  Future<List<Post>> execute(Nothing payload) async{
    var data = await postRepository.getWikis();
    return data;
  }

}

