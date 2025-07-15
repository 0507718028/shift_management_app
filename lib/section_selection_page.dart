// section_selection_page.dart
import 'package:flutter/material.dart';

class SectionSelectionPage extends StatelessWidget {
  final void Function(String selectedSection) onSectionSelected;

  const SectionSelectionPage({super.key, required this.onSectionSelected});

  static const List<String> sections = [
    'حرم', 'سطح', 'سجاد', 'ساحات', 'وكالة', 'مصاحف', 'ممرات',
    'دورات', 'المحطة المركزية', 'مغسلة السجاد', 'النساء',
    'الحشرات', 'المختبر', 'البيئة',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اختر القسم'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: sections.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final section = sections[index];
              return ListTile(
                tileColor: Colors.teal.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Center(
                  child: Text(
                    section,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () {
                  onSectionSelected(section);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
