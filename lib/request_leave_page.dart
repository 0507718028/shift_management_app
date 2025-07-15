import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shift_management_app/request_leave_page.dart'; // استخدم اسم مشروعك الحقيقي


class RequestLeavePage extends StatefulWidget {
  final String managerSection;
  final String? preselectedEmployee;

  const RequestLeavePage({
    Key? key,
    required this.managerSection,
    this.preselectedEmployee,
  }) : super(key: key);

  @override
  State<RequestLeavePage> createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends State<RequestLeavePage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedEmployee;
  String? selectedShift;
  int? remainingLeaves;
  final TextEditingController _reasonController = TextEditingController();

  List<String> employees = [];
  bool isLoadingEmployees = false;
  bool _isSubmitting = false;

  final List<String> shifts = [
    'وردية 1',
    'وردية 2',
    'وردية 3',
  ];

  @override
  void initState() {
    super.initState();
    fetchEmployeesBySection();
  }

  Future<void> fetchEmployeesBySection() async {
    setState(() {
      isLoadingEmployees = true;
      employees.clear();
      selectedEmployee = null;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('sections')
          .doc(widget.managerSection)
          .collection('employees')
          .get();

      final fetchedEmployees = querySnapshot.docs
          .map((doc) => doc.data()['name'] as String?)
          .whereType<String>()
          .toList();

      setState(() {
        employees = fetchedEmployees;
        if (widget.preselectedEmployee != null &&
            employees.contains(widget.preselectedEmployee)) {
          selectedEmployee = widget.preselectedEmployee;
          fetchRemainingLeaves(selectedEmployee!);
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء جلب الموظفين: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingEmployees = false;
        });
      }
    }
  }

  Future<void> fetchRemainingLeaves(String employeeName) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('sections')
          .doc(widget.managerSection)
          .collection('employees')
          .doc(employeeName)
          .get();

      if (doc.exists && doc.data()?['remainingLeaves'] != null) {
        setState(() {
          remainingLeaves = doc['remainingLeaves'];
        });
      } else {
        setState(() {
          remainingLeaves = null;
        });
      }
    } catch (e) {
      setState(() {
        remainingLeaves = null;
      });
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate() ||
        selectedEmployee == null ||
        selectedShift == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول بشكل صحيح')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance.collection('leave_requests').add({
        'employeeName': selectedEmployee,
        'section': widget.managerSection,
        'shift': selectedShift,
        'reason': _reasonController.text.trim(),
        'requestDate': FieldValue.serverTimestamp(),
        'status': 'معلق',
        'requestedBy': 'رئيس القسم',
        'remainingLeavesAtRequest': remainingLeaves ?? 0,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال طلب الإجازة بنجاح')),
      );

      setState(() {
        selectedEmployee = null;
        selectedShift = null;
        remainingLeaves = null;
      });
      _reasonController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الإرسال: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلب إجازة لموظف من القسم'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: isLoadingEmployees
              ? const Center(child: CircularProgressIndicator())
              : employees.isEmpty
                  ? const Center(child: Text('لا يوجد موظفين في قسمك'))
                  : SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'اختر الموظف',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                              value: selectedEmployee,
                              items: employees
                                  .map((emp) => DropdownMenuItem(
                                        value: emp,
                                        child: Center(child: Text(emp)),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedEmployee = val;
                                  remainingLeaves = null;
                                });
                                if (val != null) {
                                  fetchRemainingLeaves(val);
                                }
                              },
                              validator: (val) =>
                                  val == null ? 'يرجى اختيار الموظف' : null,
                            ),
                            const SizedBox(height: 10),
                            if (remainingLeaves != null)
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'الإجازات المتبقية: $remainingLeaves يوم',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'اختر الوردية',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                              value: selectedShift,
                              items: shifts
                                  .map((shift) => DropdownMenuItem(
                                        value: shift,
                                        child: Center(child: Text(shift)),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedShift = val;
                                });
                              },
                              validator: (val) =>
                                  val == null ? 'يرجى اختيار الوردية' : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _reasonController,
                              decoration: InputDecoration(
                                labelText: 'سبب الإجازة',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                              maxLines: 3,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'يرجى إدخال سبب الإجازة';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSubmitting ? null : _submitRequest,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _isSubmitting
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        'إرسال طلب الإجازة',
                                        style: TextStyle(fontSize: 18),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
