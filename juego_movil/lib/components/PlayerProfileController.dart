import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

// Importaciones según TU estructura
import 'package:juego_movil/models/PlayerModel.dart';
import 'package:juego_movil/config/AppColors.dart';
// Importamos el helper para que el controlador pueda hablar con SQLite
import 'package:juego_movil/service/database_helper.dart'; 

class PlayerProfileController extends GetxController with GetSingleTickerProviderStateMixin {
  
  // --- ESTADO DEL JUGADOR ---
  final player = Rxn<PlayerModel>();
  final isLoading = true.obs;

  // --- ANIMACIONES DEL HUD ---
  late AnimationController pulseController;
  late Animation<double> orbitAnimation;

  @override
  void onInit() {
    super.onInit();
    
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    orbitAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(pulseController);

    // Al iniciar, intentamos cargar si ya hay alguien logueado
    _loadPlayerData();
  }

  // --- NUEVO MÉTODO PARA LOGIN ---
  // Esta es la parte que conectará tu pantalla de Login con SQLite
  Future<bool> loginLocal(String usernameIngresado) async {
  isLoading.value = true;
  try {
    final dbPlayer = await DatabaseHelper.instance.getPlayer();
    
    if (dbPlayer != null) {
      // Comparamos limpiando espacios y pasando todo a minúsculas
      String nombreDB = dbPlayer.username.trim().toLowerCase();
      String nombreInput = usernameIngresado.trim().toLowerCase();

      if (nombreDB == nombreInput) {
        player.value = dbPlayer;
        isLoading.value = false;
        return true;
      }
    }
  } catch (e) {
    print("Error: $e");
  }
  isLoading.value = false;
  return false;
}
  void _loadPlayerData() async {
    isLoading.value = true;
    
    // Primero intentamos ver si hay datos reales en la DB
    final savedPlayer = await DatabaseHelper.instance.getPlayer();
    
    if (savedPlayer != null) {
      player.value = savedPlayer;
    } else {
      // Si no hay nada, dejamos el de prueba que tenías (Hardcoded)
      player.value = const PlayerModel(
        uid: 'u001',
        username: 'Perro Blanco',
        avatarUrl: 'https://share.google/FiEZdAvvJouuTtuG0',
        coins: 0,
        level: 0,
        xp: 0,
        xpToNextLevel: 1000,
        rank: 'COMANDANTE GALÁCTICO',
        scanAccuracy: 0,
        totalScans: 0,
        dogsCollected: 0,
      );
    }

    isLoading.value = false;
  }

  // --- MÉTODOS DE ACCIÓN ---
  
  void refreshStats() {
    _loadPlayerData();
  }

  double get xpProgress => (player.value?.xp ?? 0) / (player.value?.xpToNextLevel ?? 1);

  @override
  void onClose() {
    pulseController.dispose();
    super.onClose();
  }
}