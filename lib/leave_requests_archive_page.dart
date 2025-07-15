import 'package:flutter/material.dart';

class LeaveRequestsArchivePage extends StatelessWidget {
  const LeaveRequestsArchivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('أرشيف طلبات الإجازة'),
        ),
        body: const Center(
          child: Text(
            'هنا سيتم عرض طلبات الإجازة المؤرشفة',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
