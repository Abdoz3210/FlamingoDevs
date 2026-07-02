import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypogragh {
  AppTypogragh._();

  static TextTheme build({
    required Color onSurface,
    required Color onSurfaceVariant,
  }) {
    return TextTheme(
      displayLarge: GoogleFonts.pirataOne(
        fontSize: 72,
        fontWeight: FontWeight.w400,
        height: 80 / 72,
        letterSpacing: -0.02 * 72,
        color: onSurface,
      ),
      // Section titles — 48px, Pirata One
      headlineLarge: GoogleFonts.pirataOne(
        fontSize: 48,
        fontWeight: FontWeight.w400,
        height: 56 / 48,
        letterSpacing: -0.01 * 48,
        color: onSurface,
      ),

      // Sub-headers / card titles — 32px
      headlineMedium: GoogleFonts.pirataOne(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        height: 40 / 32,
        color: onSurface,
      ),

      // Small card titles — 22px
      headlineSmall: GoogleFonts.pirataOne(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: onSurface,
      ),

      // Body copy — 18px, Inter
      bodyLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: onSurfaceVariant,
      ),

      // Body copy — 16px, Inter
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: onSurfaceVariant,
      ),

      // Captions / small labels — 13px, Inter
      bodySmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: onSurfaceVariant,
      ),

      // Nav links / button labels — 15px, Inter
      labelLarge: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
    );
  }

  static TextStyle mono({required Color color, double fontSize = 12}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      letterSpacing: 0.05 * 12,
      color: color,
    );
  }

  // Mobile-scaled headline — used when isMobile is true in sections
  static TextStyle displayMobile({required Color color}) {
    return GoogleFonts.pirataOne(
      fontSize: 38,
      fontWeight: FontWeight.w400,
      height: 1.15,
      color: color,
    );
  }

  static TextStyle headlineMobile({required Color color}) {
    return GoogleFonts.pirataOne(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      height: 40 / 32,
      color: color,
    );
  }
}
