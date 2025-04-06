import 'package:ghana_to_germany/Application/Abstractions/Repositories/IAuthRepository.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Domain/Profile/profile.dart';

class GetProfileUseCase extends UseCase<Nothing, Profile> {
  final IAuthRepository authRepository;

  GetProfileUseCase({ required this.authRepository });

  @override
  Future<Profile> execute(Nothing payload) {
    return authRepository.getProfile();
  }
}