import 'package:flutter/material.dart';
import 'package:juego_movil/auth/service/auth_services.dart';
import 'package:juego_movil/src/pages/home_screen.dart';
import 'package:juego_movil/src/pages/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget{

  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {

  @override
  Widget build(BuildContext context) {
    final _auth = AuthServices();
    return StreamBuilder<AuthState>(
      stream: _auth.authState,
      builder: (context, snapshot){
        final Session = snapshot.data?.session;

        if (Session != null){
        return const Home();
      } else {
        return const Login();
      }
      },

      
    );

  }
}