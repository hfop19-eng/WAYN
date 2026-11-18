import 'package:supabase_flutter/supabase_flutter.dart';

class AppServices {
  static final SupabaseClient supabase = Supabase.instance.client;

  static User? get currentUser => supabase.auth.currentUser;

  static const String currentTermsVersion = '1.0';
  static const String currentPrivacyVersion = '1.0';

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

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await supabase.auth.signOut();
  }

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

  static Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await supabase
        .from('posts')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

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

  static Future<List<Map<String, dynamic>>> getPlaces() async {
    final response = await supabase.from('places').select();

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getReports() async {
    final response = await supabase
        .from('reports')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
