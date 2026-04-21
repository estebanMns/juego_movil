import 'package:flutter/material.dart';
import 'package:juego_movil/auth/service/auth_services.dart';
import 'package:juego_movil/src/pages/home_screen.dart';
import 'package:juego_movil/src/pages/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    // Cambiado de _auth a auth para evitar advertencias
    final auth = AuthServices();
    
    return StreamBuilder<AuthState>(
      stream: auth.authState,
      builder: (context, snapshot) {
        // Cambiado de Session a session (minúscula)
        final session = snapshot.data?.session;

        if (session != null) {
          return const Home();
        } else {
          return const Login();
        }
      },
    );
  }
}