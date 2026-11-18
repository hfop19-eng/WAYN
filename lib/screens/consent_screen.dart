import 'package:flutter/material.dart';
import '../services.dart';
import '../widgets/custom_button.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool accepted = false;
  bool loading = false;

  static const String termsText = '''
شروط استخدام WAYN

1. يجب تقديم معلومات صحيحة.
2. يمنع نشر البلاغات الكاذبة أو المضللة.
3. يمنع التشهير أو الإساءة للآخرين.
4. يمنع نشر بيانات الآخرين الشخصية دون مسوغ قانوني.
5. المعلومات والبلاغات قد يقدمها المستخدمون ولا نضمن صحتها دائماً.
6. لا تعتمد على التطبيق وحده في حالات الطوارئ.
7. قد تتم مراجعة المحتوى المخالف واتخاذ إجراءات مناسبة.
8. يمنع اختراق التطبيق أو إساءة استخدام خدماته.
9. سنوضح التغييرات المهمة في الشروط.
10. لا تلغي هذه الشروط الحقوق التي يمنحها القانون للمستخدم.
''';

  static const String privacyText = '''
سياسة الخصوصية - WAYN

1. قد نجمع بيانات الحساب مثل اسم المستخدم والبريد الإلكتروني.
2. قد نعالج الموقع الجغرافي عند استخدام ميزات الموقع.
3. قد يختار المستخدم رفع صور ونصوص.
4. تستخدم البيانات لتشغيل التطبيق وتحسينه وحمايته.
5. تجنب نشر معلومات شخصية حساسة.
6. قد نستعين بمزودي خدمات لتشغيل التطبيق.
7. يمكنك طلب الوصول إلى بياناتك أو تصحيحها أو حذفها وفق الإجراءات المتاحة.
8. سنوضح مدة الاحتفاظ بالبيانات وأسبابها.
9. نطبق إجراءات مناسبة لحماية البيانات.
10. سنعلن عن التغييرات المهمة في سياسة الخصوصية.
''';

  void showDocument(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            content,
            textAlign: TextAlign.right,
            style: const TextStyle(height: 1.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Future<void> acceptTerms() async {
    if (!accepted) return;

    setState(() => loading = true);

    try {
      await AppServices.supabase.rpc('accept_current_terms');

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر حفظ الموافقة. حاول مرة أخرى.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مراجعة الشروط'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(
              Icons.verified_user_outlined,
              size: 75,
              color: Color(0xFF42A5F5),
            ),
            const SizedBox(height: 20),
            const Text(
              'تحديث شروط WAYN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'قبل المتابعة، يرجى مراجعة الشروط وسياسة الخصوصية والموافقة عليهما.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('شروط الاستخدام'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => showDocument(
                'شروط استخدام WAYN',
                termsText,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('سياسة الخصوصية'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => showDocument(
                'سياسة الخصوصية',
                privacyText,
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              value: accepted,
              onChanged: loading
                  ? null
                  : (value) {
                      setState(() {
                        accepted = value ?? false;
                      });
                    },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'قرأت الشروط وسياسة الخصوصية وأوافق عليهما.',
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'موافقة ومتابعة',
              loading: loading,
              onPressed: accepted ? acceptTerms : null,
            ),
          ],
        ),
      ),
    );
  }
}
