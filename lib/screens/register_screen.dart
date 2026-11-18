import 'package:flutter/material.dart';
import '../services.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool acceptedTerms = false;

  static const String termsVersion = '1.0';

  Future<void> register() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.length < 6) {
      showMessage('يرجى إكمال جميع البيانات');
      return;
    }

    if (!acceptedTerms) {
      showMessage('يجب الموافقة على الشروط وسياسة الخصوصية أولاً');
      return;
    }

    setState(() => loading = true);

    try {
      await AppServices.supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'accepted_terms': true,
          'terms_version': termsVersion,
          'accepted_at': DateTime.now().toUtc().toIso8601String(),
        },
      );

      if (!mounted) return;

      showMessage('تم إرسال طلب إنشاء الحساب. تحقق من بريدك إذا طُلب منك ذلك.');
      Navigator.pop(context);
    } catch (e) {
      showMessage('تعذر إنشاء الحساب. تحقق من البيانات وحاول مجدداً.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.person_add_alt_1,
              size: 70,
              color: Color(0xFF42A5F5),
            ),
            const SizedBox(height: 20),
            const Text(
              'انضم إلى WAYN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            CustomTextField(
              label: 'اسم المستخدم',
              controller: usernameController,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 18),

            CustomTextField(
              label: 'البريد الإلكتروني',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 18),

            CustomTextField(
              label: 'كلمة المرور',
              controller: passwordController,
              obscureText: true,
              prefixIcon: const Icon(Icons.lock_outline),
            ),

            const SizedBox(height: 22),

            CheckboxListTile(
              value: acceptedTerms,
              onChanged: loading
                  ? null
                  : (value) {
                      setState(() {
                        acceptedTerms = value ?? false;
                      });
                    },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Wrap(
                children: [
                  const Text('أوافق على '),
                  GestureDetector(
                    onTap: () => showDocument(
                      'شروط استخدام WAYN',
                      termsText,
                    ),
                    child: const Text(
                      'شروط الاستخدام',
                      style: TextStyle(
                        color: Color(0xFF42A5F5),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text(' و'),
                  GestureDetector(
                    onTap: () => showDocument(
                      'سياسة الخصوصية',
                      privacyText,
                    ),
                    child: const Text(
                      'سياسة الخصوصية',
                      style: TextStyle(
                        color: Color(0xFF42A5F5),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            CustomButton(
              text: 'إنشاء الحساب',
              loading: loading,
              onPressed: register,
            ),
          ],
        ),
      ),
    );
  }
}

const String termsText = '''
مرحباً بك في WAYN.

1. يجب تقديم معلومات صحيحة عند استخدام التطبيق.

2. يمنع نشر البلاغات الكاذبة أو التشهير أو التهديد أو الإساءة للآخرين.

3. يمنع نشر بيانات الآخرين الشخصية أو صورهم دون أساس قانوني أو إذن مناسب.

4. يجب احترام المستخدمين وعدم استخدام التطبيق للمضايقة أو الاحتيال.

5. المعلومات والبلاغات المنشورة قد تكون مقدمة من المستخدمين، ولا يضمن WAYN صحتها أو اكتمالها.

6. لا تعتمد على التطبيق وحده في حالات الطوارئ أو قرارات السلامة. ارجع إلى الجهات الرسمية.

7. يمكن مراجعة المحتوى المخالف أو تقييد الحسابات التي تنتهك القواعد، وفق إجراءات واضحة.

8. يجب عدم محاولة اختراق التطبيق أو إساءة استخدام خدماته.

9. قد تتغير الشروط عند تطوير التطبيق، وسنوضح للمستخدم التغييرات المهمة ونطلب موافقته مجدداً عند الحاجة.

10. لا تلغي هذه الشروط أي حق أو حماية يمنحها القانون للمستخدم.
''';

const String privacyText = '''
سياسة الخصوصية - WAYN

1. قد نجمع بيانات الحساب مثل اسم المستخدم والبريد الإلكتروني.

2. قد نعالج الموقع الجغرافي عند استخدام ميزات الخريطة والبلاغات القريبة، وفق الأذونات التي يمنحها المستخدم.

3. قد يختار المستخدم رفع صور أو نصوص عند إنشاء المنشورات والبلاغات.

4. تستخدم البيانات لتشغيل التطبيق وتحسين الخدمات والحماية من الإساءة.

5. لا ينبغي نشر معلومات شخصية حساسة داخل المنشورات العامة.

6. يجب توضيح أي مشاركة للبيانات مع مزودي الخدمات أو الجهات الأخرى وفق القانون.

7. سنوفر للمستخدم معلومات عن كيفية طلب الوصول إلى بياناته أو تصحيحها أو حذفها وفق الحقوق القانونية.

8. سنوضح مدة الاحتفاظ بالبيانات وأسباب الاحتفاظ بها قبل الإطلاق العام.

9. سنطبق إجراءات مناسبة لحماية البيانات من الوصول غير المصرح به.

10. سنعلن عن التغييرات المهمة في سياسة الخصوصية.
''';
