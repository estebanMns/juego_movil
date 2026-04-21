import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importante para que funcione Get y Obx
import 'package:share_plus/share_plus.dart'; 
import 'package:juego_movil/config/app_colors.dart';
import 'player_glass_elements.dart';
import 'player_profile_controller.dart';

class PlayerTopBar extends StatelessWidget {
  const PlayerTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos Get.find para encontrar tu controlador de perfil
    final controller = Get.find<PlayerProfileController>();

    return Obx(() {
      final p = controller.player.value;

      // Si aún no carga el jugador, mostramos un espacio vacío
      if (p == null) return const SizedBox.shrink();

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PlayerGlassButton(
            icon: Icons.arrow_back_ios_new,
            onTap: () => Get.back(), 
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceStrong,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              '🪙 ${p.coins}', 
              style: const TextStyle(
                color: AppColors.gold, 
                fontWeight: FontWeight.bold
              )
            ),
          ),

          PlayerGlassButton(
            icon: Icons.share_outlined,
            onTap: () {
              // Nueva forma de llamar a Share para evitar el error de "deprecated"
              Share.share('¡Mira mi perfil en el juego! Soy ${p.username}, Nivel ${p.level}.');
            },
          ),
        ],
      );
    });
  }
}