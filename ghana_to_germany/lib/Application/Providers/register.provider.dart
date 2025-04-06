import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Providers/shared/errorNotifier.mixin.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Application/UseCases/register.usecase.dart';

import 'package:ghana_to_germany/Infrastructure/Services/DioHttpClient.dart';

class RegisterViewModel extends ChangeNotifier with ErrorNotifierMixin {
  final RegisterUseCase registerUseCase;

  RegisterViewModel({required this.registerUseCase});

  bool _obscureText = true;
  bool get obscureText => _obscureText;

  FormStatus _status = FormStatus.INIT;
  FormStatus get status => _status;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  void togglePassword() {
    _obscureText = !obscureText;
    notifyListeners();
  }

  Future<void> register() async {
    try {
      _status = FormStatus.LOADING;
      notifyListeners();

      var payload = RegisterPayload(
          password: _passwordController.value.text,
          email: _emailController.value.text.trim(),
      );

      await registerUseCase.execute(payload);

      // no error
      _status = FormStatus.SUCCESSFUL;
      notifyListeners();
    } on HttpException catch (e) {
      _status = FormStatus.FAILED;

      notifyError(
          e.statusCode == 401 ? "Invalid signup credentials" : e.toString());
      notifyListeners();
    }
  }

  void resetState() {
    _status = FormStatus.INIT;
    notifyListeners();
  }
}
