import 'package:flutter/material.dart';

/// Warm editorial palette derived from the supplied travel-planner designs.
abstract final class AppColors {
  static const Color terracotta = Color(0xFFC85A32);
  static const Color terracottaDark = Color(0xFFA23E18);
  static const Color sage = Color(0xFF5F6D56);
  static const Color sageLight = Color(0xFFE7F0E2);
  static const Color amber = Color(0xFFD49B4B);
  static const Color sand = Color(0xFFFFF8F5);
  static const Color parchment = Color(0xFFFFFFFF);
  static const Color blush = Color(0xFFFDF1EC);
  static const Color blushStrong = Color(0xFFF8E8E1);
  static const Color ink = Color(0xFF2C2623);
  static const Color muted = Color(0xFF715F59);
  static const Color line = Color(0xFFE7DFD5);
  static const Color white = parchment;
  static const Color card = parchment;

  // Compatibility aliases for existing feature code.
  static const Color teal = terracotta;
  static const Color tealDark = terracottaDark;
  static const Color coral = amber;
}
