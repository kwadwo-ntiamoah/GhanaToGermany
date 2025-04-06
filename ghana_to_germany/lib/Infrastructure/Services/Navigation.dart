import 'package:ghana_to_germany/Application/Abstractions/Services/INavigationService.dart';
import 'package:go_router/go_router.dart';

class NavigationService implements INavigationService {
  final GoRouter router;

  NavigationService({ required this.router });

  @override
  void go(String route) {
    router.go(route);
  }

  @override
  void pop() {
    router.pop();
  }

  @override
  void push(String route) {
    router.push(route);
  }

  @override
  void replace(String route) {
    router.replace(route);
  }
}