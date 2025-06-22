import 'package:flutter/material.dart';
import 'section_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> shifts = ['صباح', 'مساء', 'ليل'];
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
      appBar: AppBar(title: const Text('الصفحة الرئيسية - المدير')),
      body: ListView.builder(
        itemCount: shifts.length,
        itemBuilder: (context, index) {
          final shiftName = shifts[index];
          return ExpansionTile(
            title: Center(
              child: Text(
                'وردية $shiftName',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            children: sections.map((section) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SectionDetailPage(
                              shiftName: shiftName,
                              sectionName: section,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('قسم $section', style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
