import 'package:flutter/cupertino.dart';

mixin ErrorNotifierMixin on ChangeNotifier {
  String? _error;
  String? get error => _error;

  void notifyError(String error) {
    _error = error;
  }

  void clearError() {
    _error = null;
  }
}