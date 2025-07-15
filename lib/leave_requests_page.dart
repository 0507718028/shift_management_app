import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveRequestsPage extends StatefulWidget {
  const LeaveRequestsPage({Key? key}) : super(key: key);

  @override
  State<LeaveRequestsPage> createState() => _LeaveRequestsPageState();
}

class _LeaveRequestsPageState extends State<LeaveRequestsPage> {
  final firestore = FirebaseFirestore.instance;

  Future<void> updateRequestStatus(String docId, String newStatus) async {
    try {
      await firestore.collection('leave_requests').doc(docId).update({
        'status': newStatus,
        'reviewDate': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحديث حالة الطلب إلى "$newStatus"')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء تحديث الطلب: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلبات الإجازة'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('leave_requests').orderBy('requestDate', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return const Center(child: Text('لا توجد طلبات إجازة حالياً'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data()! as Map<String, dynamic>;

                final employeeName = data['employeeName'] ?? 'غير معروف';
                final section = data['section'] ?? 'غير محدد';
                final shift = data['shift'] ?? 'غير محدد';
                final reason = data['reason'] ?? '';
                final status = data['status'] ?? 'معلق';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الموظف: $employeeName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text('القسم: $section'),
                        Text('الوردية: $shift'),
                        const SizedBox(height: 6),
                        Text('سبب الإجازة:\n$reason'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('الحالة: $status', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: status == 'موافق' ? Colors.green : status == 'مرفوض' ? Colors.red : Colors.orange,
                            )),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: status == 'موافق'
                                      ? null
                                      : () => updateRequestStatus(doc.id, 'موافق'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text('موافقة'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: status == 'مرفوض'
                                      ? null
                                      : () => updateRequestStatus(doc.id, 'مرفوض'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('رفض'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
