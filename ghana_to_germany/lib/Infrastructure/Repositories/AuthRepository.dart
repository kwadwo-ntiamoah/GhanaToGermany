
import 'package:ghana_to_germany/Application/Abstractions/Repositories/IAuthRepository.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IHttpClient.dart';
import 'package:ghana_to_germany/Application/UseCases/completeProfile.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/register.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/socialRegister.usecase.dart';
import 'package:ghana_to_germany/Domain/Profile/profile.dart';
import 'package:ghana_to_germany/Domain/Token/token.dart';
import 'dart:developer' as developer;

class AuthRepository implements IAuthRepository {
  final IHttpClient httpClient;

  AuthRepository({required this.httpClient});

  @override
  Future<Token> login(String username, String password) async {
    // TODO: implement login
    var route = "auth/mobile/login";

    final payload = {
      'email': username,
      'password': password,
    };

    var res = await httpClient.post<Map<String, dynamic>>(route, payload);

    developer.log("Received data: $res");
    var token = Token.fromJson(res);

    return token;
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Token> register(RegisterPayload payload) async {
    var route = "auth/mobile/register";

    final data = {
      'password': payload.password,
      'email': payload.email,
    };

    var res = await httpClient.post<Map<String, dynamic>>(route, data);
    var token = Token.fromJson(res);

    return token;
  }

  @override
  Future<Token> socialRegister(SocialRegisterPayload payload) async {
    var route = "auth/mobile/social";

    final data = {
      'email': payload.email,
      'fullName': payload.fullName,
      'phone': payload.phone
    };

    var res = await httpClient.post<Map<String, dynamic>>(route, data);
    var token = Token.fromJson(res);

    return token;
  }

  @override
  Future<Profile> completeProfile(CompleteProfilePayload payload) async {
    var route = "profile/complete";

    final data = {
      'firstName': payload.firstName,
      'lastName': payload.lastName,
      'phoneNumber': payload.phoneNumber,
      'country': payload.country
    };

    var res = await httpClient.post<Map<String, dynamic>>(route, data);
    var profile = Profile.fromJson(res);

    return profile;
  }

  @override
  Future<Profile> getProfile() async {
    try {
      var route = "profile";

      var res = await httpClient.get<Map<String, dynamic>>(route);
      var profile = Profile.fromJson(res);

      return profile;
    } catch (e) {
      developer.log("Error fetching profile: $e");
      rethrow;
    }
  }
}
