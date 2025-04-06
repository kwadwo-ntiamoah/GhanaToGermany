import 'package:ghana_to_germany/Application/Abstractions/Repositories/IAuthRepository.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';

class CompleteProfileUseCase extends UseCase<CompleteProfilePayload, bool> {
  final IAuthRepository authRepository;

  CompleteProfileUseCase({required this.authRepository});

  @override
  Future<bool> execute(CompleteProfilePayload payload) async {
    var data = await authRepository.completeProfile(payload);
    return true;
  }
}

class CompleteProfilePayload {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String country;

  CompleteProfilePayload({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.country,
  });
}