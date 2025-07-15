import 'package:flutter/material.dart';
import 'role_selection_screen.dart';

class LoginScreen extends StatelessWidget {
  final void Function(String role, String shift, [String? section]) onLoginSuccess;

  const LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoleSelectionScreen(
      onLoginSuccess: onLoginSuccess,
      initialRole: null, // تأكد أن هذا null حتى لا يتم الدخول التلقائي
    );
  }
}
