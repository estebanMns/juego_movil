import 'package:flutter/material.dart';

class GalacticBackground extends StatelessWidget {
  final Size screenSize;
  const GalacticBackground({super.key, required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A0714), Color(0xFF12093A), Color(0xFF0E0828), Color(0xFF0A0714)],
            ),
          ),
        ),
        // Brillos radiales
        _buildGlow(-60, screenSize.height * 0.1, 250, const Color(0xFF7C3AED).withValues(alpha: 0.2)),
        _buildGlow(null, screenSize.height * 0.4, 300, const Color(0xFF4C1D95).withValues(alpha: 0.25), right: -80),
        // Estrellas (Generación automática para no escribir 30 veces lo mismo)
        ...List.generate(30, (i) {
          final x = (i * 73.1 + 17) % screenSize.width;
          final y = (i * 51.7 + 31) % screenSize.height;
          return Positioned(
            left: x,
            top: y,
            child: Container(
              width: 1.0 + (i % 3),
              height: 1.0 + (i % 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2 + (i % 6) * 0.08),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildGlow(double? left, double top, double size, Color color, {double? right}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}