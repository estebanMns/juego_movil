// lib/components/player_top_bar.dart
// Responsabilidad: Barra superior de la pantalla de perfil del jugador.
// Muestra el botón de retroceso al Lobby, las monedas del jugador
// y el botón de compartir.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
// ignore: unused_import (SharePlus se usa vía instancia)
import 'package:juego_movil/config/app_colors.dart';
import 'player_glass_elements.dart';
import 'player_profile_controller.dart';

/// Barra superior del perfil con tres acciones:
/// - [←] Regresa al Lobby usando Navigator.pop (compatible con Navigator nativo).
/// - [🪙 coins] Muestra las monedas actuales del jugador.
/// - [share] Comparte el perfil del jugador.
class PlayerTopBar extends StatelessWidget {
  const PlayerTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerProfileController>();

    return Obx(() {
      final p = controller.player.value;

      // Mientras el jugador no haya cargado, no mostramos nada
      if (p == null) return const SizedBox.shrink();

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Botón retroceder ──────────────────────────────────────────
          // Usa Navigator.pop porque la app usa MaterialApp con rutas
          // nativas de Flutter (no GetMaterialApp).
          // La Lobby abre esta pantalla con Navigator.push, por lo que
          // pop() regresa correctamente al Lobby sin importar desde dónde
          // se navegó a esta pantalla.
          PlayerGlassButton(
            icon: Icons.arrow_back_ios_new,
            onTap: () => Navigator.of(context).pop(),
          ),

          // ── Monedas del jugador ───────────────────────────────────────
          PlayerGlassChip(
            child: Text(
              '🪙 ${p.coins}',
              style: const TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          // ── Botón compartir ───────────────────────────────────────────
          PlayerGlassButton(
            icon: Icons.share_outlined,
            onTap: () {
              SharePlus.instance.share(
                ShareParams(
                  text: '¡Mira mi perfil en el juego! Soy ${p.username}, Nivel ${p.level}.',
                ),
              );
            },
          ),
        ],
      );
    });
  }
}