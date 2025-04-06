import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Providers/shared/errorNotifier.mixin.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Application/UseCases/translateText.usecase.dart';

import 'package:ghana_to_germany/Infrastructure/Services/DioHttpClient.dart';

class TranslateViewModel extends ChangeNotifier with ErrorNotifierMixin{
  final TranslateTextUseCase translateTextUseCase;

  TranslateViewModel({ required this.translateTextUseCase });

  FormStatus _status = FormStatus.INIT;
  FormStatus get status => _status;

  String? _translatedText;
  String? get translatedText => _translatedText;

  Future<void> translate(String postId) async {
    try {
      _status = FormStatus.LOADING;
      notifyListeners();

      var payload = TranslatePayload(postId: postId);
      var response = await translateTextUseCase.execute(payload);
      _translatedText = response.translation;

      // no error
      _status = FormStatus.SUCCESSFUL;
      notifyListeners();
    } on HttpException catch (e) {
      _status = FormStatus.FAILED;

      notifyError(e.toString());
      notifyListeners();
    }
  }

  void resetState() {
    _status = FormStatus.INIT;
    notifyListeners();
  }
}