import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Providers/shared/errorNotifier.mixin.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Application/UseCases/logout.usecase.dart';

import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Infrastructure/Services/GoogleAuth.dart';

class LogoutViewModel extends ChangeNotifier with ErrorNotifierMixin {
  final LogoutUseCase logoutUseCase;
  final GoogleAuth googleAuth;

  LogoutViewModel({ required this.logoutUseCase, required this.googleAuth });

  FormStatus _status = FormStatus.INIT;
  FormStatus get status => _status;

  Future logout() async {
    await logoutUseCase.execute(Nothing());
    await googleAuth.signOut();

    _status = FormStatus.SUCCESSFUL;

    notifyListeners();
  }

  void resetState() {
    _status = FormStatus.INIT;
    notifyListeners();
  }
}