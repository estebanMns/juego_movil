import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:juego_movil/config/app_colors.dart';
import 'package:juego_movil/components/player_profile_controller.dart';

class PlayerProfileScreen extends StatelessWidget {
  const PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlayerProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Imagen de fondo principal
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondoperroblanco.png'), 
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          // 2. Fondo Galáctico Animado
          _GalaxyBackground(controller: controller),

          // 3. Contenido Principal
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
                    const _TopBar(), // Quitamos el paso de monedas si prefieres usar el controller directo o lo dejamos simple
                    
                    const SizedBox(height: 40),
                    
                    _PlayerAvatar(avatarUrl: p.avatarUrl, level: p.level),
                    
                    const SizedBox(height: 15),
                    
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
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 30),
                    
                    _LevelProgressCard(xp: p.xp, nextLevel: p.xpToNextLevel),
                    
                    const SizedBox(height: 25),
                    
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

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerProfileController>();
    final p = controller.player.value!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // BOTÓN ATRÁS CORREGIDO PARA IR AL LOBBY
        _GlassButton(
          icon: Icons.arrow_back_ios_new,
          onTap: () {
            // Esto asegura que limpie la pantalla actual y vaya al Lobby
            Get.offAllNamed('/lobby'); 
          },
        ),
        _GlassChip(
          child: Text(
            '🪙 ${p.coins}',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
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
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Corregido: withValues
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl), 
            backgroundColor: Colors.white10,
          ),
        ),
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
    double progress = (xp / nextLevel).clamp(0.0, 1.0);
    
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        Expanded(
          child: _StatItem(
            label: 'PRECISIÓN',
            value: '$accuracy%', // Corregido: Sin llaves innecesarias
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
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              shadows: [
                // Corregido: withValues
                Shadow(color: color.withValues(alpha: 0.5), blurRadius: 10)
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 8, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _GlassCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface, 
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  final Widget child;
  const _GlassChip({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong, 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

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

class _GalaxyBackground extends StatelessWidget {
  final PlayerProfileController controller;
  const _GalaxyBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.pulseController,
      builder: (context, child) {
        return CustomPaint(
          painter: _OrbitParticlesPainter(controller.orbitAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _OrbitParticlesPainter extends CustomPainter {
  final double t; 
  _OrbitParticlesPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.28; 
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1;

    // Corregido: withValues
    paint.color = AppColors.cyan.withValues(alpha: 0.1);
    canvas.drawCircle(Offset(cx, cy), 100, paint);
    canvas.drawCircle(Offset(cx, cy), 130, paint);

    final angle = t * 2 * math.pi;
    final px = cx + 130 * math.cos(angle);
    final py = cy + 130 * math.sin(angle);
    
    canvas.drawCircle(
      Offset(px, py),
      4,
      Paint()
        ..color = AppColors.cyan
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawCircle(Offset(px, py), 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}