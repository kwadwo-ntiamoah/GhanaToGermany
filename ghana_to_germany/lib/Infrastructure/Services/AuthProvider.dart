import 'package:ghana_to_germany/Application/Abstractions/Services/IAuthProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider implements IAuthProvider {
  final SharedPreferences prefs;

  AuthProvider({ required this.prefs });

  @override
  bool? getAuthState() {
    return prefs.getBool('isAuthenticated');
  }

  @override
  Future<void> setAuthState(bool tf) async {
    await prefs.setBool("isAuthenticated", tf);
  }

  @override
  Future<void> setAuthToken(String token) async {
    var isSuccess = await prefs.setString('token', token);

    isSuccess ? await setAuthState(true) : await setAuthState(false);
  }

  @override
  String? getToken() {
    return prefs.getString('token');
  }

  @override
  bool? getProfileCompletionStatus() {
    return prefs.getBool('isProfilePending');
  }

  @override
  Future<void> setProfileCompletionStatus(bool isProfilePending) async {
    await prefs.setBool("isProfilePending", isProfilePending);
  }

  @override
  Future<void> logout() async {
    await prefs.clear();
  }

}