import 'package:flutter/material.dart';
import 'section_selection_page.dart';
import 'password_entry_page.dart';
import 'shift_selection_page.dart';

class RoleSelectionScreen extends StatefulWidget {
  final void Function(String role, String shift, [String? section]) onLoginSuccess;
  final String? initialRole;

  const RoleSelectionScreen({
    super.key,
    required this.onLoginSuccess,
    this.initialRole,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  void initState() {
    super.initState();

    // الدخول التلقائي إذا كان الدور هو "رئيس قسم"
    if (widget.initialRole == 'sector_chief') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSectorChiefLogin();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختيار الدور')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('اختر الدور لتسجيل الدخول:', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _handleSimpleRole('manager'),
                child: const Text('مدير'),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () => _handleSimpleRole('engineer'),
                child: const Text('مهندس'),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _handleSectorChiefLogin,
                child: const Text('رئيس قسم'),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () => _handleSimpleRole('coordinator'),
                child: const Text('منسق'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // تسجيل دخول الأدوار البسيطة (مدير، مهندس، منسق)
  Future<void> _handleSimpleRole(String role) async {
    final password = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordEntryPage(
          role: role,
          forManagerSection: false,
          onSuccess: (_) {
            Navigator.pop(context, true);
          },
        ),
      ),
    );

    if (password == true) {
      widget.onLoginSuccess(role, '', null);
    }
  }

  // تسجيل دخول رئيس القسم: اختيار القسم → كلمة المرور → الوردية
  Future<void> _handleSectorChiefLogin() async {
    final selectedSection = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => SectionSelectionPage(
          onSectionSelected: (section) {
            Navigator.pop(context, section);
          },
        ),
      ),
    );

    if (selectedSection != null) {
      final password = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordEntryPage(
            role: 'sector_chief',
            forManagerSection: true,
            initialSection: selectedSection,
            onSuccess: (_) {
              Navigator.pop(context, true);
            },
          ),
        ),
      );

      if (password == true) {
        String? selectedShift;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShiftSelectionPage(
              onShiftSelected: (shift) {
                selectedShift = shift;
                Navigator.pop(context);
              },
            ),
          ),
        );

        if (selectedShift != null) {
          widget.onLoginSuccess('sector_chief', selectedShift!, selectedSection);
        }
      }
    }
  }
}
