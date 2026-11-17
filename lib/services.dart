import 'package:supabase_flutter/supabase_flutter.dart';

class AppServices {
  static final SupabaseClient supabase = Supabase.instance.client;

  // المستخدم الحالي
  static User? get currentUser => supabase.auth.currentUser;

  // تسجيل حساب جديد
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
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

  // جلب المنشورات
  static Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await supabase
        .from('posts')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // إنشاء منشور
  static Future<void> createPost({
    required String title,
    required String description,
  }) async {
    await supabase.from('posts').insert({
      'title': title,
      'description': description,
      'user_id': currentUser?.id,
    });
  }

  // جلب الأماكن
  static Future<List<Map<String, dynamic>>> getPlaces() async {
    final response = await supabase.from('places').select();

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
