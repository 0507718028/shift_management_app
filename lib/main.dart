import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'role_selection_screen.dart'; // ✅ الاستيراد الصحيح
import 'home_page.dart';
import 'shift_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ShiftManagementApp());
}

class ShiftManagementApp extends StatefulWidget {
  const ShiftManagementApp({super.key});

  @override
  State<ShiftManagementApp> createState() => _ShiftManagementAppState();
}

class _ShiftManagementAppState extends State<ShiftManagementApp> {
  String? role;
  String? shift;

  void handleLoginSuccess(String loggedRole, String? loggedShift) {
    setState(() {
      role = loggedRole;
      shift = loggedShift;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: role == null
          ? RoleSelectionScreen(onLoginSuccess: handleLoginSuccess)
          : role == 'manager'
              ? const HomePage()
              : ShiftPage(shiftName: shift ?? 'صباح'),
    );
  }
}
