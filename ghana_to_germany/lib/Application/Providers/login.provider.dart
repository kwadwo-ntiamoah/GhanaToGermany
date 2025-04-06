import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Providers/shared/errorNotifier.mixin.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Application/UseCases/login.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/socialRegister.usecase.dart';

import 'package:ghana_to_germany/Infrastructure/Services/DioHttpClient.dart';
import 'package:ghana_to_germany/Infrastructure/Services/GoogleAuth.dart';
import 'dart:developer' as developer;

class LoginViewModel extends ChangeNotifier with ErrorNotifierMixin {
  final LoginUseCase loginUseCase;
  final SocialRegisterUseCase socialRegisterUseCase;
  final GoogleAuth googleAuth;

  LoginViewModel(
      {required this.loginUseCase,
      required this.googleAuth,
      required this.socialRegisterUseCase});

  bool _obscureText = true;
  bool get obscureText => _obscureText;

  FormStatus _status = FormStatus.INIT;
  FormStatus get status => _status;

  FormStatus _googleStatus = FormStatus.INIT;
  FormStatus get googleStatus => _googleStatus;

  final TextEditingController _usernameController = TextEditingController();
  TextEditingController get usernameController => _usernameController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  void togglePassword() {
    _obscureText = !obscureText;
    notifyListeners();
  }

  Future<void> login() async {
    try {
      _status = FormStatus.LOADING;
      notifyListeners();

      var payload = LoginPayload(
          username: _usernameController.value.text.toLowerCase().trim(),
          password: _passwordController.value.text.trim());

      await loginUseCase.execute(payload);
      _status = FormStatus.SUCCESSFUL;
      notifyListeners();

      developer.log("Login Successful");
    } on HttpException catch (e) {
      _status = FormStatus.FAILED;
      notifyListeners();

      notifyError(
          e.statusCode == 401 ? "Invalid login credentials" : e.toString());
    } on ForbiddenException catch (e) {
      _status = FormStatus.FAILED;
      notifyListeners();

      notifyError("Invalid login credentials");
    } catch (e) {
      _status = FormStatus.FAILED;
      notifyListeners();

      notifyError(e.toString());
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      _googleStatus = FormStatus.LOADING;
      notifyListeners();

      var userCred = await googleAuth.signInWithGoogle();

      if (userCred == null) {
        _googleStatus = FormStatus.FAILED;
        notifyError("Invalid login");
        notifyListeners();
      } else {
        var payload = SocialRegisterPayload(
            phone: userCred.user?.phoneNumber,
            email: userCred.user?.email,
            fullName: userCred.user?.displayName);

        await socialRegisterUseCase.execute(payload);

        _googleStatus = FormStatus.SUCCESSFUL;
        notifyListeners();

        developer.log("Logging in");
      }
    } catch (e) {
      _googleStatus = FormStatus.FAILED;
      notifyError(e.toString());
      notifyListeners();
    }
  }

  Future logoutWithGoogle() async {
    await googleAuth.signOut();
  }

  bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void resetState() {
    _status = FormStatus.INIT;
    _googleStatus = FormStatus.INIT;

    notifyListeners();
  }
}
