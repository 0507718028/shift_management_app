import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ✅ تأكد من وجود هذا الاستدعاء
import 'login_screen.dart';
import 'welcome_screen.dart';
import 'request_leave_page.dart';
import 'my_leave_requests_page.dart';
import 'leave_requests_archive_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ✅ هذا السطر يحل المشكلة
  );
  runApp(const ShiftManagementApp());
}

class ShiftManagementApp extends StatefulWidget {
  const ShiftManagementApp({Key? key}) : super(key: key);

  @override
  State<ShiftManagementApp> createState() => _ShiftManagementAppState();
}

class _ShiftManagementAppState extends State<ShiftManagementApp> {
  String? _role;
  String? _shift;
  String? _section;

  void _onLoginSuccess(String role, String shift, [String? section]) {
    setState(() {
      _role = role;
      _shift = shift;
      _section = section;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shift Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      routes: {
        '/request_leave': (context) => RequestLeavePage(
              managerSection: _section ?? '',
            ),
        '/my_leave_requests': (context) => MyLeaveRequestsPage(
              managerSection: _section ?? '',
            ),
        '/leave_requests_archive': (context) => const LeaveRequestsArchivePage(),
      },
      home: Builder(
        builder: (context) {
          if (_role == null) {
            return LoginScreen(
              onLoginSuccess: _onLoginSuccess,
            );
          } else {
            return WelcomeScreen(
              role: _role!,
              shift: _shift!,
              section: _section ?? '',
            );
          }
        },
      ),
    );
  }
}
