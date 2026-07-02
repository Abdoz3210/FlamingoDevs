import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── DARK THEME — from design tokens ─────────────────────────
  static const darkBackground = Color(0xFF10141A);
  static const darkSurface = Color(0xFF10141A);
  static const darkSurfaceDim = Color(0xFF10141A);
  static const darkSurfaceBright = Color(0xFF353940);
  static const darkSurfaceContainerLowest = Color(0xFF0A0E14);
  static const darkSurfaceContainerLow = Color(0xFF181C22);
  static const darkSurfaceContainer = Color(0xFF1C2026);
  static const darkSurfaceContainerHigh = Color(0xFF262A31);
  static const darkSurfaceContainerHighest = Color(0xFF31353C);
  static const darkSurfaceVariant = Color(0xFF31353C);
  static const darkSurfaceTint = Color(0xFFADC6FF);
  static const darkOnBackground = Color(0xFFDFE2EB);
  static const darkOnSurface = Color(0xFFDFE2EB);
  static const darkOnSurfaceVariant = Color(0xFFC1C6D7);
  static const darkInverseSurface = Color(0xFFDFE2EB);
  static const darkInverseOnSurface = Color(0xFF2D3137);
  static const darkOutline = Color(0xFF8B90A0);
  static const darkOutlineVariant = Color(0xFF414755);

  static const darkPrimary = Color(0xFFADC6FF);
  static const darkOnPrimary = Color(0xFF002E69);
  static const darkPrimaryContainer = Color(0xFF4B8EFF);
  static const darkOnPrimaryContainer = Color(0xFF00285C);
  static const darkInversePrimary = Color(0xFF005BC1);
  static const darkPrimaryFixed = Color(0xFFD8E2FF);
  static const darkPrimaryFixedDim = Color(0xFFADC6FF);
  static const darkOnPrimaryFixed = Color(0xFF001A41);
  static const darkOnPrimaryFixedVariant = Color(0xFF004493);

  static const darkSecondary = Color(0xFFBDF4FF);
  static const darkOnSecondary = Color(0xFF00363D);
  static const darkSecondaryContainer = Color(0xFF00E3FD);
  static const darkOnSecondaryContainer = Color(0xFF00616D);
  static const darkSecondaryFixed = Color(0xFF9CF0FF);
  static const darkSecondaryFixedDim = Color(0xFF00DAF3);
  static const darkOnSecondaryFixed = Color(0xFF001F24);
  static const darkOnSecondaryFixedVariant = Color(0xFF004F58);

  static const darkTertiary = Color(0xFFC1C6D6);
  static const darkOnTertiary = Color(0xFF2B303D);
  static const darkTertiaryContainer = Color(0xFF8B91A0);
  static const darkOnTertiaryContainer = Color(0xFF242A36);
  static const darkTertiaryFixed = Color(0xFFDDE2F3);
  static const darkTertiaryFixedDim = Color(0xFFC1C6D6);
  static const darkOnTertiaryFixed = Color(0xFF161C27);
  static const darkOnTertiaryFixedVariant = Color(0xFF414754);

  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);

  // Spotlight gradient — dark mode.
  // ONLY used on: logo mark, primary CTA buttons, 1–2 hero headline words.
  // Never as a background fill.
  static const darkGradient = [Color(0xFF00C6FF), Color(0xFF00E5FF)];

  // ── LIGHT THEME — mirrored structure, inverted values ───────
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const lightSurfaceContainerLow = Color(0xFFF7F8FA);
  static const lightSurfaceContainer = Color(0xFFF2F3F6);
  static const lightSurfaceContainerHigh = Color(0xFFEBEDF1);
  static const lightSurfaceContainerHighest = Color(0xFFE3E6EC);
  static const lightOnSurface = Color(0xFF0A0E14);
  static const lightOnSurfaceVariant = Color(0xFF4B5161);
  static const lightInverseSurface = Color(0xFF10141A);
  static const lightInverseOnSurface = Color(0xFFDFE2EB);
  static const lightOutline = Color(0xFFB7BBC4);
  static const lightOutlineVariant = Color(0xFFE2E4E9);
  static const lightSurfaceTint = Color(0xFF007AFF);

  static const lightPrimary = Color(0xFF005BC1);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFD8E2FF);
  static const lightOnPrimaryContainer = Color(0xFF001A41);
  static const lightInversePrimary = Color(0xFFADC6FF);

  static const lightSecondary = Color(0xFF00616D);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightSecondaryContainer = Color(0xFFBDF4FF);
  static const lightOnSecondaryContainer = Color(0xFF00363D);

  static const lightTertiary = Color(0xFF414754);
  static const lightOnTertiary = Color(0xFFFFFFFF);
  static const lightTertiaryContainer = Color(0xFFDDE2F3);
  static const lightOnTertiaryContainer = Color(0xFF161C27);

  static const lightError = Color(0xFFBA1A1A);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFFDAD6);
  static const lightOnErrorContainer = Color(0xFF410002);

  // Spotlight gradient — light mode. Deep navy to sapphire.
  static const lightGradient = [Color(0xFF050A15), Color(0xFF007AFF)];
}
