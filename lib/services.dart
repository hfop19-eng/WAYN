
import 'package:supabase_flutter/supabase_flutter.dart';

class AppServices {
  static final SupabaseClient supabase = Supabase.instance.client;

  static User? get currentUser => supabase.auth.currentUser;

  static const String currentTermsVersion = '1.0';
  static const String currentPrivacyVersion = '1.0';

  // إنشاء حساب وإرسال رمز التحقق
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'username': username,
        'accepted_terms': true,
        'terms_version': currentTermsVersion,
        'privacy_version': currentPrivacyVersion,
        'accepted_at': DateTime.now().toUtc().toIso8601String(),
      },
    );
  }

  // التحقق من رمز البريد الإلكتروني
  static Future<AuthResponse> verifySignupOtp({
    required String email,
    required String token,
  }) async {
    return await supabase.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );
  }

  // إعادة إرسال رمز التحقق
  static Future<void> resendSignupOtp({
    required String email,
  }) async {
    await supabase.auth.resend(
      type: OtpType.signup,
      email: email,
    );
  }

  // تسجيل الدخول
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // تسجيل الخروج
  static Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // التحقق من الموافقة على الشروط
  static Future<bool> hasAcceptedCurrentTerms() async {
    final user = currentUser;

    if (user == null) return false;

    final response = await supabase
        .from('user_consents')
        .select('id')
        .eq('user_id', user.id)
        .eq('terms_version', currentTermsVersion)
        .eq('privacy_version', currentPrivacyVersion)
        .limit(1);

    return response.isNotEmpty;
  }

  // جلب منشورات المجتمع
  static Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await supabase
        .from('posts')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // إنشاء منشور جديد
  static Future<void> createPost({
    required String title,
    required String content,
    String? imageUrl,
    String? area,
  }) async {
    final user = currentUser;

    if (user == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    await supabase.from('posts').insert({
      'user_id': user.id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'area': area,
    });
  }

  // جلب الأماكن
  static Future<List<Map<String, dynamic>>> getPlaces() async {
    final response = await supabase
        .from('places')
        .select();

    return List<Map<String, dynamic>>.from(response);
  }

  // جلب البلاغات
  static Future<List<Map<String, dynamic>>> getReports() async {
    final response = await supabase
        .from('reports')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
