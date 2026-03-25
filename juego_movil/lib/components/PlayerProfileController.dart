// Archivo: lib/components/player_profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

// Importaciones según TU estructura
import 'package:juego_movil/models/PlayerModel.dart';
import 'package:juego_movil/config/AppColors.dart';

class PlayerProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  
  // --- ESTADO DEL JUGADOR ---
  // Usamos .obs para que la UI se actualice automáticamente
  final player = Rxn<PlayerModel>();
  final isLoading = true.obs;

  // --- ANIMACIONES DEL HUD ---
  late AnimationController pulseController;
  late Animation<double> orbitAnimation;

  @override
  void onInit() {
    super.onInit();
    
    // Configuración de la animación de las órbitas y partículas
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Se repite infinitamente

    orbitAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(pulseController);

    // Simulamos la carga de datos (Aquí conectarás con tu DB o Servicio más adelante)
    _loadPlayerData();
  }

  void _loadPlayerData() async {
    isLoading.value = true;
    
    // Simulación de delay de red
    await Future.delayed(const Duration(milliseconds: 800));

    // Datos de prueba (Hardcoded por ahora)
    player.value = const PlayerModel(
      uid: 'u001',
      username: 'Perro Blanco',
      avatarUrl: 'assets/images/kovuIcon.jpeg', // Imagen local del personaje
      coins: 0,
      level: 0,
      xp: 0,
      xpToNextLevel: 1000,
      rank: 'COMANDANTE GALÁCTICO',
      scanAccuracy: 0,
      totalScans: 0,
      dogsCollected: 0,
    );

    isLoading.value = false;
  }

  // --- MÉTODOS DE ACCIÓN ---
  
  void refreshStats() {
    // Aquí podrías llamar a tu ai_detector_service o gemini_service
    _loadPlayerData();
  }

  double get xpProgress => (player.value?.xp ?? 0) / (player.value?.xpToNextLevel ?? 1);

  @override
  void onClose() {
    pulseController.dispose(); // Limpieza de memoria
    super.onClose();
  }
}