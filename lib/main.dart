import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'shift_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await createEmptyShifts();
  runApp(const ShiftManagementApp());
}

Future<void> createEmptyShifts() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Map<String, List<String>> emptyShiftData = {
    "حرم": [],
    "سطح": [],
    "سجاد": [],
    "ساحات": [],
    "رئاسة": [],
    "مرافق": [],
    "مواقف": [],
  };

  final List<String> shifts = ['صباح', 'مساء', 'ليل'];

  for (var shiftName in shifts) {
    final docRef = firestore.collection('shifts').doc(shiftName);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set(emptyShiftData);
    }
  }
}

class ShiftManagementApp extends StatelessWidget {
  const ShiftManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'إدارة الورديات',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final password = _passwordController.text.trim();

    if (password == 'مدير') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (['صباح', 'مساء', 'ليل'].contains(password)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ShiftPage(shiftName: password)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة المرور غير صحيحة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _login(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('دخول'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final shifts = ['صباح', 'مساء', 'ليل'];
    return Scaffold(
      appBar: AppBar(title: const Text('المدير - إدارة الورديات')),
      body: ListView(
        children: shifts.map((shift) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text('وردية $shift', textAlign: TextAlign.center),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShiftPage(shiftName: shift),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
