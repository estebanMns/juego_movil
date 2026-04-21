import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {

  final SupabaseClient _client = Supabase.instance.client;

  // metodo para el registro
  Future<void> signUpWithEmailPassword(String email, String password, String name) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {"name":name}
      );

      if (response.user == null){
        throw Exception("Error al registrarse intentelo de nuevo");
      }
  }

  //metodo para el inicio de sesion
  Future<void> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password
    );
    
    if (response.user == null){
      throw Exception("usuario o contraseña incorrectos intentelo de nuevo");
    }
  }

  //metodo para cerrar sesion
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  //getter para el estado de la autenticacion
  Stream<AuthState> get authState => _client.auth.onAuthStateChange;

}