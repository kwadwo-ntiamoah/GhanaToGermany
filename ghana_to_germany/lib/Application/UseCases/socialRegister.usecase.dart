import 'package:ghana_to_germany/Application/Abstractions/Repositories/IAuthRepository.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IAuthProvider.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';

class SocialRegisterUseCase extends UseCase<SocialRegisterPayload, void> {
  final IAuthRepository authRepository;
  final IAuthProvider authProvider;

  SocialRegisterUseCase({required this.authRepository, required this.authProvider});

  @override
  Future<void> execute(SocialRegisterPayload payload) async {
    var token = await authRepository.socialRegister(payload);

    // set token in shared preference
    authProvider.setAuthToken(token.key);
    authProvider.setProfileCompletionStatus(token.pendingProfileUpdate);
  }
}

class SocialRegisterPayload {
  final String? phone, email, fullName;

  SocialRegisterPayload({
    this.phone,
    this.email,
    this.fullName
  });
}
