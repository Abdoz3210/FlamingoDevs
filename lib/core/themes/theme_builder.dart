import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:flutter/material.dart';

/// Builds the Flamingo ThemeData for either brightness.
///
/// Role mapping (so widgets can read `Theme.of(context).colorScheme`):
///   surface                  -> page background
///   surfaceContainerLow      -> second sheet, tinted areas
///   surfaceContainer         -> cards
///   surfaceContainerHighest  -> chips
///   onSurfaceVariant         -> body text
///   outlineVariant           -> hairline borders and the zigzag base line
///   primary                  -> accent (links, labels, focus, progress line)
ThemeData buildFlamingoTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  final scheme = isDark
      ? const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.darkAccent,
          onPrimary: Color(0xFF3B0A1E),
          primaryContainer: Color(0xFF7A2547),
          onPrimaryContainer: Color(0xFFFFD9E2),
          secondary: Color(0xFFFFB38A),
          onSecondary: Color(0xFF3A1500),
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
          surface: AppColors.darkBackground,
          onSurface: AppColors.darkInk,
          onSurfaceVariant: AppColors.darkMuted,
          outline: AppColors.darkOutline,
          outlineVariant: AppColors.darkBorder,
          surfaceContainerLowest: AppColors.darkFooter,
          surfaceContainerLow: AppColors.darkSurfaceLow,
          surfaceContainer: AppColors.darkSurface,
          surfaceContainerHigh: AppColors.darkChip,
          surfaceContainerHighest: AppColors.darkChip,
        )
      : const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.lightAccent,
          onPrimary: Colors.white,
          primaryContainer: AppColors.lightFold,
          onPrimaryContainer: AppColors.lightInk,
          secondary: Color(0xFFB8431F),
          onSecondary: Colors.white,
          error: Color(0xFFBA1A1A),
          onError: Colors.white,
          surface: AppColors.lightBackground,
          onSurface: AppColors.lightInk,
          onSurfaceVariant: AppColors.lightMuted,
          outline: AppColors.lightOutline,
          outlineVariant: AppColors.lightBorder,
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: AppColors.lightSurfaceLow,
          surfaceContainer: AppColors.lightSurface,
          surfaceContainerHigh: AppColors.lightChip,
          surfaceContainerHighest: AppColors.lightChip,
        );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    textTheme: AppTypogragh.build(
      onSurface: scheme.onSurface,
      onSurfaceVariant: scheme.onSurfaceVariant,
    ),
    scaffoldBackgroundColor: scheme.surface,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: scheme.error),
      ),
    ),
    extensions: [isDark ? OrigamiColors.dark : OrigamiColors.light],
  );
}
