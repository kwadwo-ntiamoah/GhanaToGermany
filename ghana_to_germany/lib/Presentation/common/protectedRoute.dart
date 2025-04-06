import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Infrastructure/Services/GoogleAuth.dart';
import 'package:ghana_to_germany/Presentation/pages/login/login.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart'
as sl;

class ProtectedRoute extends StatelessWidget {
  final Widget child;

  const ProtectedRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream:  sl.getIt<GoogleAuth>().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return child;
        }
        return const LoginScreen();
      },
    );
  }
}