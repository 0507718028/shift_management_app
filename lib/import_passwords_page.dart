import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class ImportPasswordsPage extends StatefulWidget {
  const ImportPasswordsPage({super.key});

  @override
  State<ImportPasswordsPage> createState() => _ImportPasswordsPageState();
}

class _ImportPasswordsPageState extends State<ImportPasswordsPage> {
  Future<void> uploadPasswords() async {
    final firestore = FirebaseFirestore.instance;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/passwords_import.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final Map<String, dynamic> passwords = jsonData['passwords'];

      for (final entry in passwords.entries) {
        await firestore
            .collection('passwords')
            .doc(entry.key)
            .set({'password': entry.value['password']}, SetOptions(merge: true));

        debugPrint("✅ تم رفع: ${entry.key}");
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم رفع كلمات المرور بنجاح')),
      );
    } catch (e) {
      debugPrint('❌ خطأ: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ حدث خطأ أثناء رفع الباسووردات: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality( // لضبط النصوص من اليمين لليسار
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('استيراد كلمات المرور'),
          centerTitle: true,
        ),
        body: Center(
          child: SizedBox(
            width: 280,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.upload_file, size: 24),
              label: const Text(
                'استيراد كلمات المرور',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: uploadPasswords,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
