import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // private constructor — this class is never instantiated

  // ── DARK THEME ──────────────────────────────────────────────
  static const darkSurface = Color(0xFF10141A);
  static const darkSurfaceContainerLowest = Color(0xFF0A0E14);
  static const darkSurfaceContainerLow = Color(0xFF181C22);
  static const darkSurfaceContainer = Color(0xFF1C2026);
  static const darkSurfaceContainerHigh = Color(0xFF262A31);
  static const darkSurfaceContainerHighest = Color(0xFF31353C);
  static const darkOnSurface = Color(0xFFDFE2EB);
  static const darkOnSurfaceVariant = Color(0xFFC1C6D7);
  static const darkOutline = Color(0xFF8B90A0);
  static const darkOutlineVariant = Color(0xFF414755);
  static const darkPrimary = Color(0xFFADC6FF);
  static const darkOnPrimary = Color(0xFF002E69);
  static const darkPrimaryContainer = Color(0xFF4B8EFF);

  // The spotlight gradient — dark mode. Used ONLY on:
  // logo mark, primary CTA buttons, 1-2 hero headline words.
  static const darkGradient = [Color(0xFF00C6FF), Color(0xFF00E5FF)];

  // ── LIGHT THEME ─────────────────────────────────────────────
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceContainer = Color(0xFFF2F3F6);
  static const lightSurfaceContainerHighest = Color(0xFFE3E6EC);
  static const lightOnSurface = Color(0xFF0A0E14);
  static const lightOnSurfaceVariant = Color(0xFF4B5161);
  static const lightOutline = Color(0xFFB7BBC4);
  static const lightOutlineVariant = Color(0xFFE2E4E9);
  static const lightPrimary = Color(0xFF005BC1);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFD8E2FF);

  // The spotlight gradient — light mode. Deep navy to sapphire.
  static const lightGradient = [Color(0xFF050A15), Color(0xFF007AFF)];
}
