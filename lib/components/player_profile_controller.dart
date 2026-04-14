// Archivo: lib/components/player_profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Importaciones optimizadas
import 'package:juego_movil/models/player_model.dart';

class PlayerProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  
  // --- ESTADO DEL JUGADOR ---
  // Rxn permite que el valor inicial sea nulo hasta que carguen los datos
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

    // Carga inicial de datos
    _loadPlayerData();
  }

  void _loadPlayerData() async {
    isLoading.value = true;
    
    // Simulación de delay de red
    await Future.delayed(const Duration(milliseconds: 800));

    // Datos de prueba
    // Nota: Asegúrate de que PlayerModel coincida con estos campos
    player.value = const PlayerModel(
      uid: 'u001',
      username: 'Perro Blanco',
      avatarUrl: 'https://tu-url-de-imagen.com/yoongi.jpg', // Cambiado a URL para evitar errores si no está en assets
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
    _loadPlayerData();
  }

  // Getter útil para la barra de progreso
  double get xpProgress => (player.value?.xp ?? 0) / (player.value?.xpToNextLevel ?? 1);

  @override
  void onClose() {
    // Es vital hacer dispose para evitar fugas de memoria (memory leaks)
    pulseController.dispose(); 
    super.onClose();
  }
}