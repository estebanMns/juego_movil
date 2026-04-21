import 'package:flutter/material.dart';
import 'dart:ui';
import '../../models/achievement_model.dart';

class AchievementMedal extends StatelessWidget {
  final Achievement achievement;

  const AchievementMedal({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: achievement.isUnlocked 
                ? achievement.color.withValues(alpha: 0.15) 
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: achievement.isUnlocked 
                  ? achievement.color.withValues(alpha: 0.5) 
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(achievement.icon, 
                   color: achievement.isUnlocked ? achievement.color : Colors.white24, 
                   size: 40),
              const SizedBox(height: 10),
              Text(achievement.title, 
                   style: TextStyle(color: achievement.isUnlocked ? Colors.white : Colors.white38, 
                   fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}