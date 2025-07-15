import 'package:flutter/material.dart';

class ShiftSelectionPage extends StatelessWidget {
  final void Function(String shift) onShiftSelected;

  const ShiftSelectionPage({Key? key, required this.onShiftSelected}) : super(key: key);

  static const List<String> shifts = ['صباح', 'مساء', 'ليل'];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اختر الوردية'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: shifts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final shift = shifts[index];
              return ListTile(
                tileColor: Colors.lightBlue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Center(
                  child: Text(
                    shift,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () {
                  onShiftSelected(shift);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
