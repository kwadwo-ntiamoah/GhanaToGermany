import 'package:ghana_to_germany/Application/UseCases/translateText.usecase.dart';
import 'package:ghana_to_germany/Domain/Translation/translation.dart';

abstract class ITranslateRepository {
  Future<Translation> translate(TranslatePayload payload);
}