import 'package:ghana_to_germany/Application/UseCases/completeProfile.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/register.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/socialRegister.usecase.dart';
import 'package:ghana_to_germany/Domain/Profile/profile.dart';
import 'package:ghana_to_germany/Domain/Token/token.dart';

abstract class IAuthRepository {
  Future<Token> login(String username, String password);
  Future<Token> register(RegisterPayload payload);
  Future<Token> socialRegister(SocialRegisterPayload payload);
  Future<Profile> getProfile();
  Future<Profile> completeProfile(CompleteProfilePayload payload);
  Future<void> logout();
}