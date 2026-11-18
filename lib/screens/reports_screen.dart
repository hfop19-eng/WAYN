
import 'package:flutter/material.dart';
import '../models.dart';
import '../services.dart';
import '../theme.dart';
import '../widgets/custom_text_field.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final areaController = TextEditingController();

  String selectedCategory = 'ازدحام مروري';
  bool isLoading = false;
  bool isSending = false;
  String? errorMessage;

  List<WaynReport> reports = [];

  final List<String> categories = [
    'ازدحام مروري',
    'انقطاع كهرباء',
    'مشكلة طريق',
    'عرض تجاري',
    'مكان جديد',
    'فعالية',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    areaController.dispose();
    super.dispose();
  }

  Future<void> loadReports() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await AppServices.getReports();

      if (!mounted) return;

      setState(() {
        reports = data.map((item) => WaynReport.fromJson(item)).toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'تعذر تحميل البلاغات. تحقق من الاتصال والصلاحيات.';
      });
    }
  }

  Future<void> submitReport() async {
    final user = AppServices.currentUser;

    if (user == null) {
      showMessage('يجب تسجيل الدخول أولاً');
      return;
    }

    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      showMessage('اكتب عنوان البلاغ والوصف');
      return;
    }

    setState(() => isSending = true);

    try {
      await AppServices.supabase.from('reports').insert({
        'user_id': user.id,
        'category': selectedCategory,
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'area': areaController.text.trim().isEmpty
            ? null
            : areaController.text.trim(),
      });

      if (!mounted) return;

      titleController.clear();
      descriptionController.clear();
      areaController.clear();

      showMessage('تم إرسال البلاغ بنجاح');

      await loadReports();
    } catch (e) {
      if (!mounted) return;
      showMessage('لم نتمكن من إرسال البلاغ. تحقق من صلاحيات قاعدة البيانات.');
    } finally {
      if (mounted) {
        setState(() => isSending = false);
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaynTheme.background,
      appBar: AppBar(
        title: const Text(
          'بلاغات المجتمع',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: WaynTheme.surface,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: loadReports,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF42A5F5),
                    Color(0xFF9575CD),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.campaign,
                    color: Colors.white,
                    size: 35,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'شاركنا ما يحدث حولك',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'ساعد الآخرين بمعلومات محلية واضحة وحديثة.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'إرسال بلاغ جديد',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: WaynTheme.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'نوع البلاغ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedCategory = value);
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'عنوان البلاغ',
                    hint: 'مثلاً: ازدحام شديد في الشارع',
                    controller: titleController,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'تفاصيل البلاغ',
                    hint: 'اكتب التفاصيل التي تريد مشاركتها...',
                    controller: descriptionController,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'المنطقة',
                    hint: 'مثلاً: الحلة - شارع 40',
                    controller: areaController,
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: isSending ? null : submitReport,
                      icon: isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send),
                      label: Text(
                        isSending ? 'جارٍ الإرسال...' : 'إرسال البلاغ',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WaynTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            const Text(
              'آخر البلاغات',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_off, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: loadReports,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              )
            else if (reports.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Text('لا توجد بلاغات حتى الآن'),
                ),
              )
            else
              ...reports.map((report) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: WaynTheme.surface,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: WaynTheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              report.category,
                              style: TextStyle(
                                color: WaynTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            report.createdAt.toLocal().toString().substring(0, 16),
                            style: TextStyle(
                              color: WaynTheme.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        report.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(report.description),

                      if (report.area != null &&
                          report.area!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 17,
                              color: WaynTheme.muted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              report.area!,
                              style: TextStyle(color: WaynTheme.muted),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
