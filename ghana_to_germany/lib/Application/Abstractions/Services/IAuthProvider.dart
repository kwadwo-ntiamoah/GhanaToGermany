abstract class IAuthProvider {
  Future<void> setProfileCompletionStatus(bool isProfileComplete);
  Future<void> setAuthToken(String token);
  Future<void> setAuthState(bool tf);
  Future<void> logout();
  bool? getAuthState();
  bool? getProfileCompletionStatus();
  String? getToken();
}