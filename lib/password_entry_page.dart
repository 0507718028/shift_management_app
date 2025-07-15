import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordEntryPage extends StatefulWidget {
  final String role; // 'مدير'، 'منسق'، 'إدارة'، 'رئيس'
  final bool forManagerSection;
  final void Function(String? selectedSection) onSuccess;
  final String? initialSection;

  const PasswordEntryPage({
    Key? key,
    required this.role,
    required this.forManagerSection,
    required this.onSuccess,
    this.initialSection,
  }) : super(key: key);

  @override
  State<PasswordEntryPage> createState() => _PasswordEntryPageState();
}

class _PasswordEntryPageState extends State<PasswordEntryPage> {
  final TextEditingController _passwordController = TextEditingController();
  String? selectedSection;
  bool isLoading = false;
  String errorMessage = '';

  final List<String> sections = [
    'حرم', 'سطح', 'سجاد', 'ساحات', 'وكالة', 'مصاحف', 'ممرات',
    'دورات', 'المحطة المركزية', 'مغسلة السجاد', 'النساء',
    'الحشرات', 'المختبر', 'البيئة',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialSection != null) {
      selectedSection = widget.initialSection;
    }
  }

  Future<void> verifyPassword() async {
    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    final input = _passwordController.text.trim();
    if (input.isEmpty) {
      setState(() {
        errorMessage = 'يرجى إدخال كلمة المرور';
        isLoading = false;
      });
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;
      String docId;

      if (widget.forManagerSection) {
        if (selectedSection == null) {
          setState(() {
            errorMessage = 'يرجى اختيار القسم';
            isLoading = false;
          });
          return;
        }
        docId = 'رئيس-$selectedSection';
      } else {
        docId = widget.role;
      }

      final docSnapshot = await firestore.collection('passwords').doc(docId).get();

      if (!docSnapshot.exists) {
        setState(() {
          errorMessage = 'لا توجد كلمة مرور لهذا الدور أو القسم';
          isLoading = false;
        });
        return;
      }

      final storedPassword = docSnapshot.get('password') as String;

      if (input == storedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول بنجاح ✅')),
        );
        widget.onSuccess(selectedSection);
      } else {
        setState(() {
          errorMessage = 'كلمة المرور غير صحيحة';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'حدث خطأ أثناء التحقق: $e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إدخال كلمة المرور - ${widget.role}'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (widget.forManagerSection) ...[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'اختر القسم',
                    border: OutlineInputBorder(),
                  ),
                  items: sections
                      .map((sec) => DropdownMenuItem(
                            value: sec,
                            child: Text('قسم $sec'),
                          ))
                      .toList(),
                  value: selectedSection,
                  onChanged: (val) {
                    setState(() {
                      selectedSection = val;
                      errorMessage = '';
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  border: const OutlineInputBorder(),
                  errorText: errorMessage.isNotEmpty ? errorMessage : null,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : verifyPassword,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('دخول', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
