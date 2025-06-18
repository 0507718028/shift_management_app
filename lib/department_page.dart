import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DepartmentPage extends StatefulWidget {
  final String shiftName;
  final String departmentName;

  const DepartmentPage({
    super.key,
    required this.shiftName,
    required this.departmentName,
  });

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> employees = [];
  bool isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    final doc = await _firestore
        .collection('shifts')
        .doc(widget.shiftName)
        .collection('departments')
        .doc(widget.departmentName)
        .get();

    final data = doc.data();
    if (data != null && data.containsKey('employees')) {
      setState(() {
        employees = List<String>.from(data['employees']);
        isLoading = false;
      });
    } else {
      setState(() {
        employees = [];
        isLoading = false;
      });
    }
  }

  Future<void> _updateEmployees() async {
    await _firestore
        .collection('shifts')
        .doc(widget.shiftName)
        .collection('departments')
        .doc(widget.departmentName)
        .set({'employees': employees}, SetOptions(merge: true));
  }

  void _addEmployee() {
    final name = _controller.text.trim();
    if (name.isNotEmpty && !employees.contains(name)) {
      setState(() {
        employees.add(name);
        _controller.clear();
      });
      _updateEmployees();
    }
  }

  void _removeEmployee(String name) {
    setState(() {
      employees.remove(name);
    });
    _updateEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.departmentName} - ${widget.shiftName}'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'أدخل اسم الموظف',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _addEmployee,
                        child: const Text('إضافة'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final name = employees[index];
                      return ListTile(
                        title: Text(name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeEmployee(name),
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
