import 'package:flutter/material.dart';
import '../../models/character_model.dart';
import '../../config/app_colors.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final bool isCurrent;
  final double imageH;
  final double imageW;
  final Animation<double> glowAnimation;

  const CharacterCard({
    super.key,
    required this.character,
    required this.isCurrent,
    required this.imageH,
    required this.imageW,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildImageWithGlow(),
        const SizedBox(height: 14),
        _buildName(),
        const SizedBox(height: 8),
        _buildRoleBadge(),
        const SizedBox(height: 12),
        _buildDescription(),
      ],
    );
  }

  Widget _buildImageWithGlow() {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, _) => Container(
        width: imageW,
        height: imageH,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isCurrent ? AppColors.purple2 : Colors.white.withValues(alpha: 0.15),
            width: isCurrent ? 2.5 : 1.5,
          ),
          boxShadow: isCurrent ? [
            BoxShadow(
              color: AppColors.purple1.withValues(alpha: 0.6 * glowAnimation.value),
              blurRadius: 30,
              spreadRadius: 4,
            ),
          ] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Image.asset(character.image, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildName() {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        colors: [Color(0xFFE0C3FF), AppColors.purple2],
      ).createShader(rect),
      child: Text(
        character.name,
        style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w900, color: Colors.white),
      ),
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.purple1.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.purple2.withValues(alpha: 0.4)),
      ),
      child: Text(
        character.role,
        style: const TextStyle(color: Color(0xFFD8B4FE), fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        character.description,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13.0),
      ),
    );
  }
}