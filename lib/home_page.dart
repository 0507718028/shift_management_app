import 'package:flutter/material.dart';
import 'role_selection_screen.dart';

class HomePage extends StatelessWidget {
  final void Function(String role, String shift, [String? section]) onLoginSuccess;

  const HomePage({super.key, required this.onLoginSuccess});

  void _navigateToRoleSelection(BuildContext context, String role) {
    if (role == 'sector_chief') {
      // الدخول المباشر لتدفق رئيس القسم
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RoleSelectionScreen(
            onLoginSuccess: onLoginSuccess,
            initialRole: 'sector_chief',
          ),
        ),
      );
    } else {
      // عرض شاشة اختيار الدور بشكل عادي
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RoleSelectionScreen(
            onLoginSuccess: onLoginSuccess,
            initialRole: null,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الصفحة الرئيسية'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 160,
                  height: 160,
                ),
                const SizedBox(height: 30),
                _buildButton(context, 'مدير', 'manager', Colors.teal),
                const SizedBox(height: 16),
                _buildButton(context, 'مهندس', 'engineer', Colors.blue),
                const SizedBox(height: 16),
                _buildButton(context, 'منسق', 'coordinator', Colors.purple),
                const SizedBox(height: 16),
                _buildButton(context, 'رئيس قسم', 'sector_chief', Colors.green),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, String role, Color color) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _navigateToRoleSelection(context, role),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
