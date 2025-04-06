
import 'package:ghana_to_germany/Application/Abstractions/Repositories/ITranslateRepository.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IHttpClient.dart';
import 'package:ghana_to_germany/Application/UseCases/translateText.usecase.dart';
import 'package:ghana_to_germany/Domain/Translation/translation.dart';

class TranslateRepository implements ITranslateRepository {
  final IHttpClient httpClient;

  TranslateRepository({ required this.httpClient });

  @override
  Future<Translation> translate(TranslatePayload payload) async {
    var route = "translate";

    final data = {
      'postId': payload.postId,
    };

    var res = await httpClient.post(route, data);
    var translation = Translation.fromJson(res);

    return translation;
  }

}