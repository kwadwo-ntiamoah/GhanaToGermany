abstract class INavigationService {
  void pop();
  void go(String route);
  void push(String route);
  void replace(String route);
}