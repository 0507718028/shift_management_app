import 'package:flutter/material.dart';
import 'section_detail_page.dart';
import 'import_passwords_page.dart';
import 'employee_search_page.dart'; // ✅ تأكد من وجود الملف

class SectionListPage extends StatelessWidget {
  const SectionListPage({super.key});

  static const List<String> sections = [
    'حرم', 'سطح', 'سجاد', 'ساحات', 'وكالة', 'مصاحف', 'ممرات',
    'دورات', 'المحطة المركزية', 'مغسلة السجاد', 'النساء',
    'الحشرات', 'المختبر', 'البيئة'
  ];

  static const String defaultShift = 'صباح'; // الوردية الافتراضية

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لدعم العربية
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اختر القسم'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'بحث عن موظف',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmployeeSearchPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.upload_file),
              tooltip: 'رفع كلمات المرور',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ImportPasswordsPage()),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ListView.separated(
            itemCount: sections.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final section = sections[index];
              return Center(
                child: SizedBox(
                  width: 280,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    tileColor: Colors.grey.shade100,
                    title: Center(
                      child: Text(
                        section,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SectionDetailPage(
                            sectionName: section,
                            shiftName: defaultShift,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
