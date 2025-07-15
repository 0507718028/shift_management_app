import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyLeaveRequestsPage extends StatefulWidget {
  final String managerSection;

  const MyLeaveRequestsPage({super.key, required this.managerSection});

  @override
  State<MyLeaveRequestsPage> createState() => _MyLeaveRequestsPageState();
}

class _MyLeaveRequestsPageState extends State<MyLeaveRequestsPage> {
  final firestore = FirebaseFirestore.instance;

  Future<void> sendReminderToAdmin(String docId) async {
    await firestore.collection('leave_requests').doc(docId).update({
      'reminderSent': true,
      'lastReminder': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📣 تم إرسال تنبيه للإدارة')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('متابعة طلبات الإجازة لقسمك'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection('leave_requests')
              .where('section', isEqualTo: widget.managerSection)
              .orderBy('requestDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return const Center(child: Text('لا توجد طلبات إجازة لقسمك'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final docId = docs[index].id;

                final employeeName = data['employeeName'] ?? 'غير معروف';
                final shift = data['shift'] ?? 'غير محدد';
                final reason = data['reason'] ?? 'بدون سبب';
                final status = data['status'] ?? 'معلق';
                final reminderSent = data['reminderSent'] == true;
                final requestDate = data['requestDate'] != null
                    ? (data['requestDate'] as Timestamp).toDate()
                    : null;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الموظف: $employeeName',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 6),
                        Text('الوردية: $shift'),
                        if (requestDate != null)
                          Text('تاريخ الطلب: ${requestDate.toLocal().toString().split(' ')[0]}'),
                        const SizedBox(height: 6),
                        Text('السبب: $reason'),
                        const SizedBox(height: 12),
                        Text('الحالة: $status',
                            style: TextStyle(
                                color: status == 'موافق'
                                    ? Colors.green
                                    : (status == 'مرفوض'
                                        ? Colors.red
                                        : Colors.orange),
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),

                        // زر تنبيه للإدارة إذا الطلب معلق ولم يُرسل تذكير بعد
                        if (status == 'معلق' && !reminderSent)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await sendReminderToAdmin(docId);
                              },
                              icon: const Icon(Icons.notification_important),
                              label: const Text('تنبيه الإدارة'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber[800],
                              ),
                            ),
                          )
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
