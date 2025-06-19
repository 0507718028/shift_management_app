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

  static const Map<String, IconData> sectionIcons = {
    'حرم': Icons.home,
    'سطح': Icons.terrain,
    'سجاد': Icons.layers,
    'ساحات': Icons.square_foot,
    'رئاسة': Icons.apartment,
    'مرافق': Icons.construction,
    'مواقف': Icons.local_parking,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('وردية $shiftName')),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(
                sectionIcons[section] ?? Icons.work,
                color: Colors.blueAccent,
              ),
              title: Text(section, textAlign: TextAlign.center),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SectionDetailPage(
                      shiftName: shiftName,
                      sectionName: section,
                    ),
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
