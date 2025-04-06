import 'package:ghana_to_germany/Application/Abstractions/Repositories/IAuthRepository.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IAuthProvider.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';

class LoginUseCase extends UseCase<LoginPayload, void> {
  final IAuthRepository authRepository;
  final IAuthProvider authProvider;

  LoginUseCase({required this.authRepository, required this.authProvider});

  @override
  Future<void> execute(LoginPayload payload) async {
    var token = await authRepository.login(payload.username, payload.password);

    // set token in shared preference
    authProvider.setAuthToken(token.key);
    authProvider.setProfileCompletionStatus(token.pendingProfileUpdate);
  }
}

class LoginPayload {
  final String username, password;

  LoginPayload({required this.username, required this.password});
}
