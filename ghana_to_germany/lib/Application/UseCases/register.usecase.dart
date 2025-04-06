import 'package:ghana_to_germany/Application/Abstractions/Repositories/IAuthRepository.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IAuthProvider.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';

class RegisterUseCase extends UseCase<RegisterPayload, void> {
  final IAuthRepository authRepository;
  final IAuthProvider authProvider;

  RegisterUseCase({required this.authRepository, required this.authProvider});

  @override
  Future<void> execute(RegisterPayload payload) async {
    var token = await authRepository.register(payload);

    // set token in shared preference
    authProvider.setAuthToken(token.key);
    authProvider.setProfileCompletionStatus(token.pendingProfileUpdate);
  }
}

class RegisterPayload {
  final String email, password;

  RegisterPayload({
    required this.email,
    required this.password
  });
}
