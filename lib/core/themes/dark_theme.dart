import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/core/constants/app_sizes.dart';
import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:flutter/material.dart';

ThemeData buildDarkTheme() {
  const colorScheme = ColorScheme(
    brightness: Brightness.dark,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    onSurfaceVariant: AppColors.darkOnSurfaceVariant,
    inversePrimary: AppColors.darkInverseSurface,
    onInverseSurface: AppColors.darkInverseOnSurface,

    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkOnPrimary,
    primaryContainer: AppColors.darkPrimaryContainer,
    onPrimaryContainer: AppColors.darkOnPrimaryContainer,

    secondary: AppColors.darkSecondary,
    onSecondary: AppColors.darkOnSecondary,
    secondaryContainer: AppColors.darkSecondaryContainer,
    onSecondaryContainer: AppColors.darkOnSecondaryContainer,

    tertiary: AppColors.darkTertiary,
    onTertiary: AppColors.darkOnTertiary,
    tertiaryContainer: AppColors.darkTertiaryContainer,
    onTertiaryContainer: AppColors.darkOnTertiaryContainer,

    error: AppColors.darkError,
    onError: AppColors.darkOnError,
    errorContainer: AppColors.darkErrorContainer,
    onErrorContainer: AppColors.darkOnErrorContainer,

    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkOutlineVariant,
    surfaceTint: AppColors.darkSurfaceTint,
  );
  final textTheme = AppTypogragh.build(
    onSurface: AppColors.darkOnSurface,
    onSurfaceVariant: AppColors.darkOnSurfaceVariant,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: AppColors.darkBackground,

    // No ink splash — we'll handle hover states ourselves
    // so they match the design exactly
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,

    // Cards — slightly elevated surface, subtle border, rounded
    cardTheme: CardThemeData(
      color: AppColors.darkSurfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        side: BorderSide(color: AppColors.darkOutlineVariant),
      ),
    ),

    // Inputs — underline only, no box border
    // The focus state turns the underline blue (primary color)
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkOutlineVariant),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkPrimaryContainer, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkError),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkOutlineVariant),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.darkOutlineVariant,
      thickness: 1,
      space: 1,
    ),
  );
}
