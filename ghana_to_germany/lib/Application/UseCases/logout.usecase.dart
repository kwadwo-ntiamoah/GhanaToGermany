import 'package:ghana_to_germany/Application/Abstractions/Repositories/IAuthRepository.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IAuthProvider.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';

class LogoutUseCase extends UseCase<Nothing, void> {
  final IAuthRepository authRepository;
  final IAuthProvider authProvider;

  LogoutUseCase({required this.authRepository, required this.authProvider});

  @override
  Future<void> execute(Nothing _) async {
    authProvider.logout();
  }
}