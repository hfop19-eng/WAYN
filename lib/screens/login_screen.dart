import 'package:flutter/material.dart';
import '../services.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage('يرجى إدخال البريد الإلكتروني وكلمة المرور');
      return;
    }

    setState(() => loading = true);

    try {
      await AppServices.signIn(
        email: email,
        password: password,
      );

      final accepted = await AppServices.hasAcceptedCurrentTerms();

      if (!mounted) return;

      if (!accepted) {
        await AppServices.signOut();

        if (!mounted) return;

        showMessage(
          'يجب الموافقة على الشروط وسياسة الخصوصية الحالية قبل الدخول.',
        );
        return;
      }

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      showMessage('تعذر تسجيل الدخول. تحقق من البيانات والاتصال.');
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 35),

            const Icon(
              Icons.location_on_rounded,
              size: 75,
              color: Color(0xFF42A5F5),
            ),

            const SizedBox(height: 20),

            const Text(
              'مرحباً بعودتك إلى WAYN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 35),

            CustomTextField(
              label: 'البريد الإلكتروني',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: 'كلمة المرور',
              controller: passwordController,
              obscureText: true,
              prefixIcon: const Icon(Icons.lock_outline),
            ),

            const SizedBox(height: 28),

            CustomButton(
              text: 'تسجيل الدخول',
              loading: loading,
              onPressed: login,
            ),

            const SizedBox(height: 18),

            TextButton(
              onPressed: loading
                  ? null
                  : () {
                      Navigator.pushNamed(context, '/register');
                    },
              child: const Text('ليس لديك حساب؟ أنشئ حساباً جديداً'),
            ),
          ],
        ),
      ),
    );
  }
}
