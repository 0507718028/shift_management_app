import 'package:flutter/material.dart';
import 'request_leave_page.dart';
import 'my_leave_requests_page.dart';
import 'leave_requests_archive_page.dart';
import 'shift_page.dart';

class WelcomeScreen extends StatelessWidget {
  final String role;
  final String section;
  final String? shift;

  const WelcomeScreen({
    super.key,
    required this.role,
    required this.section,
    this.shift,
  });

  String get roleLabel {
    switch (role) {
      case 'manager':
        return 'المدير';
      case 'sector_chief':
        return 'رئيس القسم';
      case 'engineer':
        return 'مهندس';
      case 'coordinator':
        return 'منسق';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مرحبا بك'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, size: 120, color: Colors.teal),
                const SizedBox(height: 20),

                Text(
                  'تم تسجيل الدخول بنجاح!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  'الدور: $roleLabel',
                  style: const TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),

                if (section.isNotEmpty || shift != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'القسم: $section\nالوردية: ${shift ?? 'غير محددة'}',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 30),

                ..._buildOptionsByRole(context),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('الخروج', style: TextStyle(fontSize: 18)),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  icon: const Icon(Icons.archive),
                  label: const Text('الأرشيف'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LeaveRequestsArchivePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOptionsByRole(BuildContext context) {
    switch (role) {
      case 'sector_chief':
        return _buildSectorChiefOptions(context);
      case 'manager':
      case 'engineer':
        return _buildManagerOptions(context);
      case 'coordinator':
        return []; // لاحقًا يمكن إضافة خصائص للمنسق
      default:
        return [];
    }
  }

  List<Widget> _buildSectorChiefOptions(BuildContext context) {
    return [
      ElevatedButton.icon(
        icon: const Icon(Icons.time_to_leave),
        label: const Text('طلب إجازة لموظف'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RequestLeavePage(managerSection: section),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      const SizedBox(height: 16),
      ElevatedButton.icon(
        icon: const Icon(Icons.list_alt),
        label: const Text('متابعة طلبات الإجازة'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MyLeaveRequestsPage(managerSection: section),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ];
  }

  List<Widget> _buildManagerOptions(BuildContext context) {
    return [
      ElevatedButton.icon(
        icon: const Icon(Icons.view_list),
        label: Text('عرض وردية ${shift ?? ''}'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ShiftPage(shiftName: shift ?? 'صباح'),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ];
  }
}
