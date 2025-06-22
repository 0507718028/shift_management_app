import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final Function(String role, String shift) onLoginSuccess;

  const LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String? selectedShift;

  final Map<String, String> shiftPasswords = {
    'صباح': '1234',
    'مساء': '2345',
    'ليل': '3456',
  };

  final String managerPassword = 'admin123';

  void _login() {
    final pass = _passwordController.text.trim();

    if (pass == managerPassword) {
      widget.onLoginSuccess('manager', 'all');
    } else if (selectedShift != null && shiftPasswords[selectedShift] == pass) {
      widget.onLoginSuccess('shift_manager', selectedShift!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة السر غير صحيحة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool canLogin = _passwordController.text.isNotEmpty &&
        (selectedShift != null || _passwordController.text.trim() == managerPassword);

    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل دخول')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // هنا الشعار
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      '🔴 الشعار لم يظهر',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  'شركة المجال العربي',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'ورديات',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'اختر الوردية',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedShift,
                  items: shiftPasswords.keys.map((shift) {
                    return DropdownMenuItem(
                      value: shift,
                      child: Text(shift),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedShift = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) {
                    if (canLogin) _login();
                  },
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canLogin ? _login : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
