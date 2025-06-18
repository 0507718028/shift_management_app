import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'shift_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ShiftManagementApp());
}

class ShiftManagementApp extends StatelessWidget {
  const ShiftManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ادارة الورديات',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> shifts = ['صباح', 'مساء', 'ليل'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الورديات'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: shifts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text('وردية ${shifts[index]}', textAlign: TextAlign.center),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShiftPage(shiftName: shifts[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
