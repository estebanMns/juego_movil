import 'package:flutter/material.dart';

class Achievement {
  final String title;
  final IconData icon;
  final Color color;
  final bool isUnlocked;

  Achievement({
    required this.title,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
  });
}