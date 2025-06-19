import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SectionDetailPage extends StatefulWidget {
  final String shiftName;
  final String sectionName;

  const SectionDetailPage({
    super.key,
    required this.shiftName,
    required this.sectionName,
  });

  @override
  State<SectionDetailPage> createState() => _SectionDetailPageState();
}

class _SectionDetailPageState extends State<SectionDetailPage> {
  final TextEditingController controller = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> employees = [];

  final List<String> sections = [
    'حرم', 'سطح', 'سجاد', 'ساحات', 'رئاسة', 'مرافق', 'مواقف',
  ];

  final List<String> shifts = ['صباح', 'مساء', 'ليل'];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final doc = await firestore.collection('shifts').doc(widget.shiftName).get();
    final data = doc.data();
    if (data != null && data[widget.sectionName] != null) {
      setState(() {
        employees = List<String>.from(data[widget.sectionName]);
      });
    }
  }

  Future<void> saveData() async {
    await firestore.collection('shifts').doc(widget.shiftName).set({
      widget.sectionName: employees,
    }, SetOptions(merge: true));
  }

  void addEmployee() {
    final name = controller.text.trim();
    if (name.isNotEmpty && !employees.contains(name)) {
      setState(() {
        employees.add(name);
        controller.clear();
      });
      saveData();
    }
  }

  void removeEmployee(String name) {
    setState(() {
      employees.remove(name);
    });
    saveData();
  }

  Future<void> moveEmployee() async {
    final selectedShift = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('اختر الوردية الهدف'),
          children: shifts
              .map((shift) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, shift),
                    child: Text(shift),
                  ))
              .toList(),
        );
      },
    );

    if (selectedShift == null) return;

    final selectedSection = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('اختر القسم الهدف'),
          children: sections
              .map((section) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, section),
                    child: Text(section),
                  ))
              .toList(),
        );
      },
    );

    if (selectedSection == null) return;

    final employeeName = await selectEmployeeDialog();

    if (employeeName == null) return;

    final originDocRef = firestore.collection('shifts').doc(widget.shiftName);
    final originDoc = await originDocRef.get();
    if (originDoc.exists) {
      final originData = originDoc.data()!;
      List<String> originEmployees = List<String>.from(originData[widget.sectionName] ?? []);
      originEmployees.remove(employeeName);
      await originDocRef.set({widget.sectionName: originEmployees}, SetOptions(merge: true));
    }

    final targetDocRef = firestore.collection('shifts').doc(selectedShift);
    final targetDoc = await targetDocRef.get();
    if (targetDoc.exists) {
      final targetData = targetDoc.data()!;
      List<String> targetEmployees = List<String>.from(targetData[selectedSection] ?? []);
      if (!targetEmployees.contains(employeeName)) {
        targetEmployees.add(employeeName);
        await targetDocRef.set({selectedSection: targetEmployees}, SetOptions(merge: true));
      }
    }

    await fetchData();
  }

  Future<String?> selectEmployeeDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('اختر الموظف للنقل'),
          children: employees
              .map((emp) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, emp),
                    child: Text(emp),
                  ))
              .toList(),
        );
      },
    );
  }

  void copyEmployeesToClipboard() {
    if (employees.isEmpty) return;
    final text = 'قائمة الموظفين - قسم ${widget.sectionName} / وردية ${widget.shiftName}:\n\n' +
        employees.map((e) => '• $e').join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ الأسماء إلى الحافظة')),
    );
  }

  Future<void> shareViaWhatsApp() async {
    if (employees.isEmpty) return;
    final text = 'قائمة الموظفين - قسم ${widget.sectionName} / وردية ${widget.shiftName}:\n\n' +
        employees.map((e) => '• $e').join('\n');

    final whatsappUrl = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن فتح واتساب')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('قسم ${widget.sectionName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: copyEmployeesToClipboard,
            tooltip: 'نسخ الأسماء',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: shareViaWhatsApp,
            tooltip: 'مشاركة واتساب',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'اسم الموظف',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addEmployee,
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: moveEmployee,
            icon: const Icon(Icons.drive_file_move),
            label: const Text('نقل موظف بين ورديات وأقسام'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final name = employees[index];
                return ListTile(
                  title: Text(name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeEmployee(name),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
