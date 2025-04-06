import 'package:ghana_to_germany/Application/Abstractions/Repositories/IPostRepository.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';

class SearchUseCase extends UseCase<SearchPayload, List<Post>> {
  final IPostRepository postRepository;

  SearchUseCase({ required this.postRepository });

  @override
  Future<List<Post>> execute(SearchPayload payload) async {
    var data = await postRepository.searchPost(payload.query);
    return data;
  }
}

class SearchPayload {
  final String query;

  SearchPayload({required this.query});
}