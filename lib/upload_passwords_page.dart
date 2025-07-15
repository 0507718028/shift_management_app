import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPasswordsPage extends StatelessWidget {
  const UploadPasswordsPage({super.key});

  Future<void> uploadPasswords(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;

    final Map<String, String> passwords = {
      "manager": "admin123",
      "منسق": "coordinator123",
      "إدارة": "adminOffice123",
      "رئيس-حرم": "haram123",
      "رئيس-سطح": "sath123",
      "رئيس-سجاد": "sajad123",
      "رئيس-ساحات": "sahat123",
      "رئيس-وكالة": "wakala123",
      "رئيس-مصاحف": "mosahif123",
      "رئيس-ممرات": "mamarrat123",
      "رئيس-دورات": "dawrat123",
      "رئيس-المحطة المركزية": "markazia123",
      "رئيس-مغسلة السجاد": "maghsala123",
      "رئيس-النساء": "nisaa123",
      "رئيس-الحشرات": "hasharat123",
      "رئيس-المختبر": "mokhtabar123",
      "رئيس-البيئة": "beeah123",
    };

    try {
      for (var entry in passwords.entries) {
        await firestore.collection('passwords').doc(entry.key).set({
          'password': entry.value,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحميل كلمات المرور بنجاح ✅')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء التحميل: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تحميل كلمات المرور')),
        body: Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.cloud_upload),
            label: const Text('تحميل كلمات المرور إلى Firestore'),
            onPressed: () => uploadPasswords(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              backgroundColor: Colors.teal,
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
