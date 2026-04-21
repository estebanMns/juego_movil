// lib/components/player_galaxy_background.dart
// Responsabilidad: Renderizar el fondo animado de órbitas y partículas
// del perfil del jugador.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:juego_movil/config/app_colors.dart';
import 'player_profile_controller.dart';

/// Widget que muestra las partículas orbitales animadas del fondo.
class PlayerGalaxyBackground extends StatelessWidget {
  final PlayerProfileController controller;
  const PlayerGalaxyBackground({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.pulseController,
      builder: (context, child) {
        return CustomPaint(
          painter: OrbitParticlesPainter(controller.orbitAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }
}

/// CustomPainter que dibuja los anillos orbitales y la partícula animada.
class OrbitParticlesPainter extends CustomPainter {
  final double t;
  OrbitParticlesPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.28;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

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
