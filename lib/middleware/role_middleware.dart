import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';

class RoleMiddleware extends StatelessWidget {
  final Widget child;
  final String roleRequired;

  RoleMiddleware({required this.child, required this.roleRequired});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.fetchUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data == roleRequired) {
          return child;
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
