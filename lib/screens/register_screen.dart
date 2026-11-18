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

  Future<void> register() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.length < 6) {
      showMessage('أكمل البيانات وتأكد أن كلمة المرور 6 أحرف على الأقل');
      return;
    }

    setState(() => loading = true);

    try {
      await AppServices.signUp(
        email: email,
        password: password,
        username: username,
      );

      if (!mounted) return;

      showMessage('تم إنشاء الحساب. تحقق من بريدك إذا طُلب منك ذلك.');
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
            const SizedBox(height: 25),
            const Icon(
              Icons.person_add_alt_1,
              size: 70,
              color: Color(0xFF42A5F5),
            ),
            const SizedBox(height: 25),
            const Text(
              'انضم إلى WAYN',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 28),
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
