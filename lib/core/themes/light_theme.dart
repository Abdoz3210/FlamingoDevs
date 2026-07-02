import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';


ThemeData buildLightTheme() {
  const colorScheme = ColorScheme(
    brightness: Brightness.light,

    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    onSurfaceVariant: AppColors.lightOnSurfaceVariant,
    inverseSurface: AppColors.lightInverseSurface,
    onInverseSurface: AppColors.lightInverseOnSurface,

    primary: AppColors.lightPrimary,
    onPrimary: AppColors.lightOnPrimary,
    primaryContainer: AppColors.lightPrimaryContainer,
    onPrimaryContainer: AppColors.lightOnPrimaryContainer,

    secondary: AppColors.lightSecondary,
    onSecondary: AppColors.lightOnSecondary,
    secondaryContainer: AppColors.lightSecondaryContainer,
    onSecondaryContainer: AppColors.lightOnSecondaryContainer,

    tertiary: AppColors.lightTertiary,
    onTertiary: AppColors.lightOnTertiary,
    tertiaryContainer: AppColors.lightTertiaryContainer,
    onTertiaryContainer: AppColors.lightOnTertiaryContainer,

    error: AppColors.lightError,
    onError: AppColors.lightOnError,
    errorContainer: AppColors.lightErrorContainer,
    onErrorContainer: AppColors.lightOnErrorContainer,

    outline: AppColors.lightOutline,
    outlineVariant: AppColors.lightOutlineVariant,
    surfaceTint: AppColors.lightSurfaceTint,
  );

  final textTheme = AppTypogragh.build(
    onSurface: AppColors.lightOnSurface,
    onSurfaceVariant: AppColors.lightOnSurfaceVariant,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: AppColors.lightBackground,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,

    cardTheme: CardThemeData(
      color: AppColors.lightSurfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        side: BorderSide(color: AppColors.lightOutlineVariant),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightOutlineVariant),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightError),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightOutlineVariant),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.lightOutlineVariant,
      thickness: 1,
      space: 1,
    ),
  );
}
