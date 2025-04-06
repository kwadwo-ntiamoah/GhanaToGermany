import 'package:ghana_to_germany/Application/Abstractions/Repositories/IPostRepository.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Domain/Tag/tag.dart';

class GetTagsUseCase extends UseCase<Nothing, List<Tag>> {
  final IPostRepository postRepository;

  GetTagsUseCase({ required this.postRepository });

  @override
  Future<List<Tag>> execute(Nothing payload) async{
    var data = await postRepository.getTags();
    return data;
  }

}

