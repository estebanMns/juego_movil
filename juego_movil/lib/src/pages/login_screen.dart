import 'package:flutter/material.dart';
import 'package:juego_movil/src/pages/PlayerProfileScreen.dart';
import 'package:juego_movil/src/pages/settings_screen.dart';
import './home.dart';
import 'register_screen.dart';
import 'lobby.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondologin.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradiente overlay oscuro para mejor legibilidad
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
          // Contenido principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Logo o Título
                    const Column(
                      children: [
                        Icon(
                          Icons.rocket_launch,
                          size: 80,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'El robo de Molly',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Bienvenido de vuelta',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // Card del formulario
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Campo Email
                          TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Correo electrónico',
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                              prefixIcon: Icon(Icons.email_outlined, color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Campo Contraseña
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Contraseña',
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.white.withValues(alpha: 0.8)),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Olvidé contraseña
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                              },
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Botón Login
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _handleLogin(
                                  context,
                                  emailController.text,
                                  passwordController.text,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9C27B0),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 8,
                                shadowColor: const Color(0xFF9C27B0).withValues(alpha: 0.5),
                              ),
                              child: const Text(
                                'INICIAR SESIÓN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Texto de registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes cuenta?',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navegación directa a Register
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            );
                          },
                          child: const Text(
                            'Regístrate',
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin(BuildContext context, String email, String password) {
    // ==========================================
    // TODO: REEMPLAZAR CON TU BACKEND
    // ==========================================
    // Aquí iría la llamada a tu API de autenticación
    // Ejemplo con Firebase Auth, Supabase, o tu propio backend
    
    // Credenciales de prueba para desarrollo (ELIMINAR EN PRODUCCIÓN)
    const String testEmail = 'test@test.com';
    const String testPassword = '123456';

    // Validación de campos vacíos
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Verificación de credenciales (SOLO PARA PRUEBAS)
    if (email == testEmail && password == testPassword) {
      // Login exitoso - Navegar al lobby
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Lobby()),
      );
    } else {
      // Credenciales incorrectas
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email o contraseña incorrectos'),
          backgroundColor: Colors.red,
        ),
      );
    }
    
    // ==========================================
    // FIN DEL CÓDIGO DE PRUEBA
    // ==========================================
  }
}