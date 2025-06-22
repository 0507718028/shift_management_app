import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatefulWidget {
  final Function(String role, String? shift) onLoginSuccess;

  const RoleSelectionScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;
  String? selectedShift;
  final TextEditingController _passwordController = TextEditingController();

  // كلمات المرور لكل دور
  final Map<String, String> passwords = {
    'manager': 'admin123',
    'shift_manager_صباح': '1234',
    'shift_manager_مساء': '2345',
    'shift_manager_ليل': '3456',
  };

  void _tryLogin() {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار الدور أولاً')),
      );
      return;
    }

    String key = selectedRole!;
    if (selectedRole == 'shift_manager' && selectedShift != null) {
      key += '_$selectedShift';
    }

    String? correctPassword = passwords[key];
    if (_passwordController.text.trim() == correctPassword) {
      widget.onLoginSuccess(selectedRole!, selectedShift);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة السر غير صحيحة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 120),
                const SizedBox(height: 16),
                const Text(
                  'شركة المجال العربي',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ورديات',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.blueAccent),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedRole = 'manager';
                      selectedShift = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  child: const Text('المدير'),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedRole = 'shift_manager';
                      selectedShift = 'صباح';
                    });
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  child: const Text('مشرف الوردية الصباحية'),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedRole = 'shift_manager';
                      selectedShift = 'مساء';
                    });
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  child: const Text('مشرف الوردية المسائية'),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedRole = 'shift_manager';
                      selectedShift = 'ليل';
                    });
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  child: const Text('مشرف الوردية الليلية'),
                ),

                const SizedBox(height: 32),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _tryLogin,
                    child: const Text('تسجيل الدخول'),
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
