import 'package:ghana_to_germany/Application/Abstractions/Repositories/ITranslateRepository.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Domain/Translation/translation.dart';

class TranslateTextUseCase extends UseCase<TranslatePayload, Translation> {
  final ITranslateRepository translateRepository;

  TranslateTextUseCase({ required this.translateRepository });

  @override
  Future<Translation> execute(TranslatePayload payload) async {
    var data = await translateRepository.translate(payload);
    return data;
  }

}

class TranslatePayload {
  final String postId;

  TranslatePayload({required this.postId});
}