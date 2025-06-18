import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftPage extends StatefulWidget {
  final String shiftName;

  const ShiftPage({super.key, required this.shiftName});

  @override
  State<ShiftPage> createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<String> sections = ['دورات مياه', 'سطح', 'ساحات'];

  Map<String, List<String>> employees = {
    'دورات مياه': [],
    'سطح': [],
    'ساحات': [],
  };

  final TextEditingController employeeController = TextEditingController();

  String? draggedEmployee;
  String? fromSection;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    final doc = await firestore.collection('shifts').doc(widget.shiftName).get();
    if (doc.exists) {
      Map<String, dynamic>? data = doc.data();
      if (data != null) {
        setState(() {
          for (var section in sections) {
            employees[section] = List<String>.from(data[section] ?? []);
          }
        });
      }
    } else {
      // إنشاء المستند إذا لم يكن موجودًا
      await firestore.collection('shifts').doc(widget.shiftName).set({
        for (var section in sections) section: [],
      });
    }
  }

  Future<void> saveEmployees() async {
    await firestore.collection('shifts').doc(widget.shiftName).set(employees);
  }

  void addEmployee(String section) {
    final name = employeeController.text.trim();
    if (name.isEmpty) return;

    if (employees[section]!.contains(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الموظف موجود بالفعل في هذا القسم')),
      );
      return;
    }

    setState(() {
      employees[section]!.add(name);
      employeeController.clear();
    });

    saveEmployees();
  }

  void removeEmployee(String section, String name) {
    setState(() {
      employees[section]!.remove(name);
    });
    saveEmployees();
  }

  void moveEmployee(String from, String to, String name) {
    if (from == to) return;

    if (employees[to]!.contains(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الموظف موجود بالفعل في القسم $to')),
      );
      return;
    }

    setState(() {
      employees[from]!.remove(name);
      employees[to]!.add(name);
    });
    saveEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل وردية : ${widget.shiftName}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: employeeController,
              decoration: InputDecoration(
                labelText: 'اسم الموظف',
                border: OutlineInputBorder(),
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: addEmployee,
                  itemBuilder: (context) {
                    return sections
                        .map((section) => PopupMenuItem(
                              value: section,
                              child: Text('إضافة إلى $section'),
                            ))
                        .toList();
                  },
                ),
              ),
              onSubmitted: (value) {
                // إضافة في القسم الأول (دورات مياه) بشكل افتراضي
                addEmployee(sections[0]);
              },
            ),
          ),
          Expanded(
            child: Row(
              children: sections.map((section) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: DragTarget<String>(
                      onAccept: (name) {
                        if (draggedEmployee != null && fromSection != null) {
                          moveEmployee(fromSection!, section, draggedEmployee!);
                        }
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(section,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const Divider(),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: employees[section]!.length,
                                  itemBuilder: (context, index) {
                                    final name = employees[section]![index];
                                    return LongPressDraggable<String>(
                                      data: name,
                                      onDragStarted: () {
                                        draggedEmployee = name;
                                        fromSection = section;
                                      },
                                      onDragEnd: (details) {
                                        draggedEmployee = null;
                                        fromSection = null;
                                      },
                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade200,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(name,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(name),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              removeEmployee(section, name),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
