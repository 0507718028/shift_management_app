import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_leave_approval_page.dart';
import 'leave_requests_archive_page.dart'; // ✅ تأكد من وجود هذا الملف

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({Key? key}) : super(key: key);

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _isUploading = false;
  String _statusMessage = '';

  final Map<String, Map<String, String>> _passwords = {
    "حرم": {"password": "haram123"},
    "سطح": {"password": "sath123"},
    "سجاد": {"password": "sajad123"},
    "ساحات": {"password": "sahat123"},
    "وكالة": {"password": "wakala123"},
    "مصاحف": {"password": "mosahif123"},
    "ممرات": {"password": "mamarrat123"},
    "دورات": {"password": "dawrat123"},
    "المحطة المركزية": {"password": "markazia123"},
    "مغسلة السجاد": {"password": "maghsala123"},
    "النساء": {"password": "nisaa123"},
    "الحشرات": {"password": "hasharat123"},
    "المختبر": {"password": "mokhtabar123"},
    "البيئة": {"password": "beeah123"},
  };

  Future<void> _uploadPasswords() async {
    setState(() {
      _isUploading = true;
      _statusMessage = '';
    });

    final firestore = FirebaseFirestore.instance;

    try {
      for (final entry in _passwords.entries) {
        await firestore.collection('passwords').doc(entry.key).set(entry.value);
      }

      setState(() {
        _statusMessage = 'تم رفع جميع كلمات المرور بنجاح!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'حدث خطأ أثناء الرفع: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة تحكم الإدارة'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadPasswords,
                icon: const Icon(Icons.upload_file),
                label: Text(_isUploading ? 'جارٍ الرفع...' : 'رفع كلمات المرور'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminLeaveApprovalPage()),
                  );
                },
                icon: const Icon(Icons.approval),
                label: const Text('اعتماد طلبات الإجازة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LeaveRequestsArchivePage()),
                  );
                },
                icon: const Icon(Icons.archive),
                label: const Text('أرشيف الطلبات السابقة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              if (_statusMessage.isNotEmpty)
                Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusMessage.contains('نجاح') ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
