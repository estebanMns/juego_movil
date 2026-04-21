import 'package:flutter/material.dart';

class AppColors {
  // --- COLORES BASE (FONDO Y SUPERFICIES) ---
  static const Color background = Color(0xFF0A0E21); 
  static const Color surface = Color(0x1AFFFFFF);    
  static const Color surfaceStrong = Color(0x33FFFFFF); // Mantenemos la versión de opacidad para Glassmorphism
  static const Color border = Color(0x4DFFFFFF);     
  static const Color profileSurface = Color(0xFF1E1E1E); // Renombrado para evitar conflicto con surfaceStrong

  // --- COLORES NEÓN Y HIGHLIGHTS ---
  static const Color cyan = Color(0xFF00E5FF);       
  static const Color purple1 = Color(0xFF6200EA);    
  static const Color purple2 = Color(0xFF7C4DFF);    
  static const Color purple3 = Color(0xFFB388FF);    
  
  // --- MONEDAS Y ESTADOS ---
  static const Color gold = Color(0xFFFFD93D);       // Usamos el amarillo brillante para las monedas
  static const Color goldMuted = Color.fromARGB(255, 205, 199, 164); // La versión anterior por si la necesitas
  static const Color goldLight = Color(0xFFFFF176);  
  static const Color accuracy = Color(0xFF00FF88);   
  static const Color error = Color(0xFFFF5252);      

  // --- TEXTO ---
  static const Color textPrimary = Colors.white;
  static const Color textMuted = Color(0xB3FFFFFF);  

  // --- GRADIENTES ---
  static const LinearGradient cosmicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D47A1),
      Color(0xFF311B92),
      Color(0xFF000000),
    ],
  );

  static const RadialGradient scannerOverlay = RadialGradient(
    colors: [
      Colors.transparent,
      Color(0x3300E5FF),
    ],
  );

  // --- COLORES PARA LOGROS (ACHIEVEMENTS) ---
  static const Color achRed = Color(0xFFFF6B6B);
  static const Color achYellow = Color(0xFFFFD93D);
  static const Color achOrange = Color(0xFFFF8E53);
  static const Color achGreen = Color(0xFF69F0AE);
  static const Color achPurple = Color(0xFF7C4DFF);
  static const Color achPink = Color(0xFFFF4081);

  // --- COLORES PARA TIENDA DE TIEMPO (TIME SHOP) ---
  static const Color timePrimary = Color(0xFF6C63FF);
  static const Color timeSecondary = Color(0xFF3F51B5);
  static const Color timeShadow = Color.fromARGB(255, 63, 81, 181);

  // --- COLORES TIENDA GENERAL (SHOP) ---
  static const Color shopTitleShadow = Color.fromARGB(255, 156, 39, 176);
  static const Color shopPurple1 = Color(0xFF9C27B0);
  static const Color shopPurple2 = Color(0xFF673AB7);
  static const Color shopBlue1 = Color(0xFF2196F3);
  static const Color shopBlue2 = Color(0xFF1976D2);
}