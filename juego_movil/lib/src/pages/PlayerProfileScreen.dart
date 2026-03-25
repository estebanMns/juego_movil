// Archivo: lib/src/pages/PerfilJugador.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'dart:math' as math;

// Importaciones adaptadas a la estructura estándar (snake_case)
import 'package:juego_movil/config/AppColors.dart';
import 'package:juego_movil/models/PlayerModel.dart';
import 'package:juego_movil/components/PlayerProfileController.dart';

class PlayerProfileScreen extends StatelessWidget {
  const PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectamos el controlador que creamos en la carpeta components
    final controller = Get.put(PlayerProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondoperroblanco.png'), // <-- CAMBIA ESTO
                fit: BoxFit.cover, // Para que la imagen cubra toda la pantalla
                alignment: Alignment.center,
              ),
            ),
          ),
          // ===================================================================

          // 2. Fondo Galáctico Animado (este ya lo tienes)
          _GalaxyBackground(controller: controller),

          // 3. Contenido Principal con SafeArea y Scroll
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.cyan),
                );
              }

              // Usamos el operador ! porque Rxn puede ser nulo,
              // pero aquí ya verificamos que no es así.
              final p = controller.player.value!;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _TopBar(coins: p.coins),
                    
                    const SizedBox(height: 40),
                    
                    // Avatar con efecto de órbita y badge de nivel
                    _PlayerAvatar(avatarUrl: p.avatarUrl, level: p.level),
                    
                    const SizedBox(height: 15),
                    
                    // Nombre y Rango del Jugador
                    Text(
                      p.username,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      p.rank.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.cyan,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 4, // Espaciado Cyberpunk
                      ),
                    ),

                    const SizedBox(height: 30),
                    
                    // Tarjeta de progreso de nivel
                    _LevelProgressCard(xp: p.xp, nextLevel: p.xpToNextLevel),
                    
                    const SizedBox(height: 25),
                    
                    // Grid de estadísticas principales
                    _StatsGrid(
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

// =============================================================================
// WIDGETS INTERNOS DE LA PANTALLA (NO REUTILIZABLES FUERA AQUÍ)
// =============================================================================

class _TopBar extends StatelessWidget {
  final int coins;
  const _TopBar({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón atrás con efecto cristal
        _GlassButton(
          icon: Icons.arrow_back_ios_new,
          onTap: () => Get.back(), // Get.back() funciona gracias a GetMaterialApp en app.dart
        ),
        // Chip de monedas neón
        _GlassChip(
          child: Text(
            '🪙 $coins',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        // Botón compartir cristal
        _GlassButton(icon: Icons.share_outlined, onTap: () {}),
      ],
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  final String avatarUrl;
  final int level;
  const _PlayerAvatar({required this.avatarUrl, required this.level});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Borde neón pulsante (el efecto lo da la sombra)
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cyan.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: CircleAvatar(
            // Imagen de red (puedes cambiarlo a AssetImage si tienes imágenes locales)
            backgroundImage: NetworkImage(avatarUrl), 
            backgroundColor: Colors.white10, // Fondo por si la imagen no carga
          ),
        ),
        // Badge de nivel superpuesto
        Positioned(
          bottom: 0,
          child: _GlassChip(
            child: Text(
              'LVL $level',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LevelProgressCard extends StatelessWidget {
  final int xp;
  final int nextLevel;
  const _LevelProgressCard({required this.xp, required this.nextLevel});

  @override
  Widget build(BuildContext context) {
    // Calculamos el progreso (de 0.0 a 1.0)
    double progress = (xp / nextLevel).clamp(0.0, 1.0);
    
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiquetas de texto superiores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'EXP PROGRESO',
                style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 1),
              ),
              Text(
                '$xp / $nextLevel',
                style: const TextStyle(color: AppColors.cyan, fontSize: 10, fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Barra de progreso neón
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white10,
            color: AppColors.cyan,
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% para el siguiente nivel',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 8),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final double accuracy;
  final int totalScans;
  final int dogs;

  const _StatsGrid({required this.accuracy, required this.totalScans, required this.dogs});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Usamos Expanded para que se dividan el espacio uniformemente
        Expanded(
          child: _StatItem(
            label: 'PRECISIÓN',
            value: '${accuracy}%',
            color: AppColors.accuracy,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            label: 'SCANS',
            value: '$totalScans',
            color: AppColors.purple3,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            label: 'LEVELS',
            value: '$dogs',
            color: AppColors.gold,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // Valor neón con monospace
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              shadows: [
                Shadow(color: color.withOpacity(0.5), blurRadius: 10)
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Etiqueta secundaria
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 8, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// COMPONENTES BASE (GLASS DESIGN / HUD ELEMENTS)
// =============================================================================

// Tarjeta básica con efecto cristal
class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _GlassCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        // Efecto de desenfoque de fondo (Blur)
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface, // Blanco traslúcido de tu config
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.border), // Borde traslúcido
          ),
          child: child,
        ),
      ),
    );
  }
}

// Pequeña etiqueta/chip con fondo neón traslúcido
class _GlassChip extends StatelessWidget {
  final Widget child;
  const _GlassChip({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong, // Fondo más opaco
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

// Botón circular cristalino
class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// =============================================================================
// PAINTERS Y FONDO (INTEGRADO AQUÍ PORQUE NO SE USA EN OTRO LADO)
// =============================================================================

class _GalaxyBackground extends StatelessWidget {
  final PlayerProfileController controller;
  const _GalaxyBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Escucha las animaciones del controlador
    return AnimatedBuilder(
      animation: controller.pulseController,
      builder: (context, child) {
        return CustomPaint(
          // Dibuja las órbitas y partículas basadas en el valor de animación
          painter: _OrbitParticlesPainter(controller.orbitAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _OrbitParticlesPainter extends CustomPainter {
  final double t; // Valor de animación (de 0.0 a 1.0)
  _OrbitParticlesPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.28; // Centrado en el avatar
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1;

    // Órbitas traslúcidas de fondo
    paint.color = AppColors.cyan.withOpacity(0.1);
    canvas.drawCircle(Offset(cx, cy), 100, paint);
    canvas.drawCircle(Offset(cx, cy), 130, paint);

    // Partícula animada neón
    // Calculamos ángulo basado en 't' para el movimiento circular
    final angle = t * 2 * math.pi;
    final px = cx + 130 * math.cos(angle);
    final py = cy + 130 * math.sin(angle);
    
    canvas.drawCircle(
      Offset(px, py),
      4,
      Paint()
        ..color = AppColors.cyan
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5), // Brillo neón
    );
    canvas.drawCircle(Offset(px, py), 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}