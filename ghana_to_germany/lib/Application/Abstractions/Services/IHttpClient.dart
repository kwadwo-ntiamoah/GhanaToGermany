abstract class IHttpClient {
  Future<T> get<T>(String route);
  Future<T> post<T>(String route, dynamic payload);
}