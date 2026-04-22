import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // --- STORAGE / AVATARES ---

  /// Lista de URLs de avatares disponibles en tu bucket.
  /// Puedes reemplazar estos placeholders con tus URLs reales de Supabase.
  Future<List<String>> getAvailableAvatars() async {
    // Si prefieres listarlos dinámicamente desde el bucket:
    /*
    final List<FileObject> objects = await _supabase
        .storage
        .from('avatars')
        .list();
    
    return objects.map((obj) => _supabase
        .storage
        .from('avatars')
        .getPublicUrl(obj.name)).toList();
    */

    // Por ahora usamos una lista manual como pediste:
    return [
      'https://tvjdkuitdsmqiyymzjto.supabase.co/storage/v1/object/public/avatares/iker.jpeg',
      'https://tvjdkuitdsmqiyymzjto.supabase.co/storage/v1/object/public/avatares/kobu.jpeg',
      'https://tvjdkuitdsmqiyymzjto.supabase.co/storage/v1/object/public/avatares/matiasygato.jpeg',
      'https://tvjdkuitdsmqiyymzjto.supabase.co/storage/v1/object/public/avatares/moly.jpeg',
    ];
  }

  // --- BASE DE DATOS / PERFIL ---

  /// Actualiza la URL del avatar en la tabla 'profiles' para el usuario actual.
  Future<void> updateUserAvatar(String avatarUrl) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase
        .from('profiles')
        .update({'avatar_url': avatarUrl})
        .eq('id', userId);
  }

  /// Obtiene los datos del perfil del usuario actual.
  Future<Map<String, dynamic>?> getUserProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return data;
  }
}
