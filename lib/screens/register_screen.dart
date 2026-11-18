
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

  Future<void> register() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.length < 6) {
      showMessage('يرجى إكمال البيانات والتأكد من كلمة المرور');
      return;
    }

    if (!acceptedTerms) {
      showMessage('يجب الموافقة على الشروط وسياسة الخصوصية أولاً');
      return;
    }

    setState(() => loading = true);

    try {
      final response = await AppServices.signUp(
        email: email,
        password: password,
        username: username,
      );

      if (!mounted) return;

      if (response.user == null) {
        showMessage('لم يكتمل إنشاء الحساب. حاول مرة أخرى.');
        return;
      }

      showMessage(
        response.session == null
            ? 'تم إنشاء الحساب. تحقق من بريدك الإلكتروني إذا طُلب منك ذلك.'
            : 'تم إنشاء الحساب بنجاح. يمكنك تسجيل الدخول.',
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      showMessage(
        'تعذر إنشاء الحساب. تحقق من البريد الإلكتروني وحاول مجدداً.',
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
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
      appBar: AppBar(
        title: const Text('إنشاء حساب'),
      ),
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
2. يمنع نشر البلاغات الكاذبة أو التشهير أو الإساءة.
3. يمنع نشر بيانات الآخرين الشخصية دون أساس قانوني.
4. يجب احترام المستخدمين وعدم استخدام التطبيق للمضايقة.
5. قد تكون المعلومات والبلاغات مقدمة من المستخدمين ولا نضمن صحتها.
6. لا تعتمد على التطبيق وحده في حالات الطوارئ.
7. يمكن مراجعة المحتوى المخالف وتقييد الحسابات وفق إجراءات واضحة.
8. يمنع اختراق التطبيق أو إساءة استخدام خدماته.
9. سنوضح التغييرات المهمة في الشروط.
10. لا تلغي هذه الشروط أي حق يمنحه القانون للمستخدم.
''';

const String privacyText = '''
سياسة الخصوصية - WAYN

1. قد نجمع بيانات الحساب مثل اسم المستخدم والبريد الإلكتروني.
2. قد نعالج الموقع الجغرافي عند استخدام ميزات الموقع.
3. قد يختار المستخدم رفع صور ونصوص.
4. تستخدم البيانات لتشغيل التطبيق وتحسينه وحمايته.
5. تجنب نشر معلومات شخصية حساسة.
6. سنوضح مشاركة البيانات مع مزودي الخدمات وفق القانون.
7. سنوضح كيفية طلب الوصول إلى البيانات أو تصحيحها أو حذفها.
8. سنوضح مدة الاحتفاظ بالبيانات وأسبابها.
9. سنطبق إجراءات مناسبة لحماية البيانات.
10. سنعلن عن التغييرات المهمة في سياسة الخصوصية.
''';
