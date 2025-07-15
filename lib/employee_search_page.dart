import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;

class EmployeeSearchPage extends StatefulWidget {
  const EmployeeSearchPage({super.key});

  @override
  State<EmployeeSearchPage> createState() => _EmployeeSearchPageState();
}

class _EmployeeSearchPageState extends State<EmployeeSearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  Future<void> searchEmployeesByPart(String part) async {
    if (part.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❗ يرجى إدخال جزء من اسم الموظف للبحث')),
        );
      }
      return;
    }

    setState(() {
      isLoading = true;
      searchResults.clear();
    });

    final firestore = FirebaseFirestore.instance;

    try {
      final sectionsSnapshot = await firestore.collection('sections').get();

      for (final sectionDoc in sectionsSnapshot.docs) {
        final sectionName = sectionDoc.id;

        final shiftsSnapshot = await firestore
            .collection('sections')
            .doc(sectionName)
            .collection('shifts')
            .get();

        for (final shiftDoc in shiftsSnapshot.docs) {
          final shiftName = shiftDoc.id;

          final employeesSnapshot = await firestore
              .collection('sections')
              .doc(sectionName)
              .collection('shifts')
              .doc(shiftName)
              .collection('employees')
              .get();

          for (final empDoc in employeesSnapshot.docs) {
            final empData = empDoc.data();
            final empName = empData['name'] ?? '';

            // بحث غير حساس لحالة الأحرف
            if (empName.toLowerCase().contains(part.toLowerCase())) {
              searchResults.add({
                'name': empName,
                'section': sectionName,
                'shift': shiftName,
              });
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ حدث خطأ أثناء البحث: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بحث جزئي عن موظف'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'اكتب جزءًا من اسم الموظف',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => searchEmployeesByPart(searchController.text),
                  ),
                ),
                onSubmitted: (_) => searchEmployeesByPart(searchController.text),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator()
              else if (searchResults.isEmpty)
                const Text(
                  'لا توجد نتائج مطابقة',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final result = searchResults[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Colors.teal),
                          title: Text(
                            result['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'القسم: ${result['section']}   -   الوردية: ${result['shift']}',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
