import 'package:flutter/material.dart';

class AppColors {
  // --- COLORES BASE (FONDO Y SUPERFICIES) ---
  static const Color background = Color(0xFF0A0E21); // Azul oscuro profundo (espacial)
  static const Color surface = Color(0x1AFFFFFF);    // Blanco con 10% opacidad (efecto cristal)
  static const Color surfaceStrong = Color(0x33FFFFFF); // Blanco con 20% opacidad
  static const Color border = Color(0x4DFFFFFF);     // Bordes sutiles para el Glassmorphism

  // --- COLORES NEÓN (HIGHLIGHTS) ---
  static const Color cyan = Color(0xFF00E5FF);       // Cian neón para escaneos e info técnica
  static const Color purple1 = Color(0xFF6200EA);    // Púrpura primario
  static const Color purple2 = Color(0xFF7C4DFF);    // Púrpura secundario
  static const Color purple3 = Color(0xFFB388FF);    // Púrpura claro para destellos
  
  // --- COLORES DE RANGO Y ESTADO ---
  static const Color gold = Color.fromARGB(255, 205, 199, 164);       // Para monedas y rangos altos
  static const Color goldLight = Color(0xFFFFF176);  // Brillo de monedas
  static const Color accuracy = Color(0xFF00FF88);   // Verde neón para precisión alta
  static const Color error = Color(0xFFFF5252);      // Rojo para alertas del sistema

  // --- TEXTO ---
  static const Color textPrimary = Colors.white;
  static const Color textMuted = Color(0xB3FFFFFF);  // Blanco al 70% para etiquetas secundarias

  // --- GRADIENTES ---
  static const LinearGradient cosmicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D47A1), // Azul profundo
      Color(0xFF311B92), // Púrpura oscuro
      Color(0xFF000000), // Negro espacial
    ],
  );

  static const RadialGradient scannerOverlay = RadialGradient(
    colors: [
      Colors.transparent,
      Color(0x3300E5FF), // Brillo cian en los bordes
    ],
  );
}