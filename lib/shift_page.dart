import 'package:flutter/material.dart';
import 'section_detail_page.dart';

class ShiftPage extends StatelessWidget {
  final String shiftName;

  const ShiftPage({super.key, required this.shiftName});

  static const List<String> sections = [
    'حرم',
    'سطح',
    'سجاد',
    'ساحات',
    'رئاسة',
    'مرافق',
    'مواقف',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('وردية $shiftName'),
        centerTitle: true, // ✅ توسيط العنوان
      ),
      body: Center( // ✅ يجعل الأزرار في منتصف الشاشة
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20),
          shrinkWrap: true,
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final sectionName = sections[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SectionDetailPage(
                          shiftName: shiftName,
                          sectionName: sectionName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('قسم $sectionName', style: const TextStyle(fontSize: 18)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
