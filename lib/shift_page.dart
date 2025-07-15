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
    'وكالة',
    'مصاحف',
    'ممرات',
    'دورات',
    'المحطة المركزية',
    'مغسلة السجاد',
    'النساء',
    'الحشرات',
    'المختبر',
    'البيئة',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,  // دعم اتجاه النص من اليمين لليسار
      child: Scaffold(
        appBar: AppBar(
          title: Text('وردية $shiftName'),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final sectionName = sections[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SectionDetailPage(
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
                child: Text(
                  'قسم $sectionName',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
