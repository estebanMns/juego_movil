import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juego_movil/config/app_colors.dart';
import 'package:juego_movil/components/player_profile_controller.dart';
import 'package:juego_movil/components/player_top_bar.dart';
import 'package:juego_movil/components/player_galaxy_background.dart';
import 'package:juego_movil/components/player_stats_widgets.dart';

class PlayerProfileScreen extends StatelessWidget {
  const PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlayerProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── 1. Imagen de fondo principal ────────────────────────────
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondoperroblanco.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          // ── 2. Fondo galáctico animado ──────────────────────────────
          PlayerGalaxyBackground(controller: controller),

          // ── 3. Contenido principal ──────────────────────────────────
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.cyan),
                );
              }

              final p = controller.player.value!;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Barra superior: retroceso, monedas, compartir
                    const PlayerTopBar(),

                    const SizedBox(height: 40),

                    // Avatar con anillo y badge de nivel
                    PlayerAvatar(avatarUrl: p.avatarUrl, level: p.level),

                    const SizedBox(height: 15),

                    // Nombre del jugador
                    Text(
                      p.username,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),

                    // Rango del jugador
                    Text(
                      p.rank.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.cyan,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Barra de progreso de experiencia
                    PlayerLevelProgressCard(
                      xp: p.xp,
                      nextLevel: p.xpToNextLevel,
                    ),

                    const SizedBox(height: 25),

                    // Grid de estadísticas: precisión, scans, niveles
                    PlayerStatsGrid(
                      accuracy: p.scanAccuracy,
                      totalScans: p.totalScans,
                      dogs: p.dogsCollected,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
