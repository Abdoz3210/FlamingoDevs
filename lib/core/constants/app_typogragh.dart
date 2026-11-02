import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Headlines use the Origami font declared in pubspec.yaml (family: Origami).
/// Never request a bold weight for it: it is a single-weight display face and
/// Flutter would fake the bold and distort the creases.
class AppTypogragh {
  AppTypogragh._();

  static const _headline = 'Origami';

  static TextStyle _h(double size, double height, Color color) => TextStyle(
    fontFamily: _headline,
    fontSize: size,
    height: height,
    color: color,
    fontWeight: FontWeight.w400,
  );

  static TextTheme build({
    required Color onSurface,
    required Color onSurfaceVariant,
  }) {
    return TextTheme(
      displayLarge: _h(76, 1.04, onSurface),
      displayMedium: _h(56, 1.06, onSurface),
      headlineLarge: _h(48, 1.1, onSurface),
      headlineMedium: _h(32, 1.2, onSurface),
      headlineSmall: _h(24, 1.2, onSurface),
      titleLarge: _h(20, 1.3, onSurface),
      bodyLarge: GoogleFonts.inter(
        fontSize: 18,
        height: 1.6,
        color: onSurfaceVariant,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        height: 1.5,
        color: onSurfaceVariant,
      ),
      bodySmall: GoogleFonts.jetBrainsMono(
        fontSize: 12,
        letterSpacing: 0.6,
        color: onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
        color: onSurface,
      ),
    );
  }

  /// Small uppercase labels, nav links, chips.
  static TextStyle mono({required Color color, double fontSize = 12}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.8,
      color: color,
    );
  }

  /// Mobile-scaled headline, used where a section switches on isMobile.
  static TextStyle displayMobile({required Color color}) =>
      _h(42, 1.06, color);

  static TextStyle headlineMobile({required Color color}) =>
      _h(28, 1.15, color);

  /// Plain Origami style at a mid size, for wordmarks and buttons.
  static TextStyle origami({required Color color}) => _h(32, 1.15, color);
}
