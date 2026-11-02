import 'package:flutter/material.dart';

/// Flamingo / origami palette.
/// Light (warm paper) is the default theme, dark is a deep plum.
class AppColors {
  AppColors._();

  // ── Light: paper ────────────────────────────────────────────
  static const lightBackground = Color(0xFFFFF7F2); // page, first sheet
  static const lightSurfaceLow = Color(0xFFFFECE6); // second sheet, tints
  static const lightSheetAlt = Color(0xFFFFF1E9); // third sheet
  static const lightSurface = Color(0xFFFFFFFF); // cards
  static const lightChip = Color(0xFFFFE3E8);
  static const lightBorder = Color(0xFFF2D3D9);
  static const lightOutline = Color(0xFFC9A3AE);
  static const lightInk = Color(0xFF2A1722); // headline text
  static const lightMuted = Color(0xFF6B4A58); // body text
  static const lightAccent = Color(0xFFC2305A); // links, labels
  static const lightFold = Color(0xFFFFC2CF); // folded corner flap
  static const lightFacetA = Color(0xFFFFE0E6);
  static const lightFacetB = Color(0xFFFFCDBD);
  static const lightFooter = Color(0xFF2A1722);
  static const lightShadow = Color(0x332A1722);

  // ── Dark: plum ──────────────────────────────────────────────
  static const darkBackground = Color(0xFF1B0F1A);
  static const darkSurfaceLow = Color(0xFF241421);
  static const darkSheetAlt = Color(0xFF20121D);
  static const darkSurface = Color(0xFF2D1829);
  static const darkChip = Color(0xFF3D2238);
  static const darkBorder = Color(0xFF4A2C44);
  static const darkOutline = Color(0xFF86607A);
  static const darkInk = Color(0xFFFFEFF2);
  static const darkMuted = Color(0xFFD9B3C0);
  static const darkAccent = Color(0xFFFF8FAB);
  static const darkFold = Color(0xFF5A2F52);
  static const darkFacetA = Color(0xFF3A1E36);
  static const darkFacetB = Color(0xFF4B2740);
  static const darkFooter = Color(0xFF120912);
  static const darkShadow = Color(0x80000000);

  // ── Shared ──────────────────────────────────────────────────
  /// Text on gradient buttons (dark ink on the pink gradient).
  static const onGradient = Color(0xFF2A1722);

  /// Plum used to dim a sheet while the next one covers it.
  static const dim = Color(0xFF2A1722);

  // Origami mark colors.
  static const markCoral = Color(0xFFFF9E7A);
  static const markPink = Color(0xFFFF5C8A);
  static const markDeep = Color(0xFFC2305A);
}

/// Origami-only colors that Material's ColorScheme has no slot for.
/// Read with `OrigamiColors.of(context)`.
@immutable
class OrigamiColors extends ThemeExtension<OrigamiColors> {
  final Color fold;
  final Color facetA;
  final Color facetB;
  final Color chip;
  final Color footer;
  final Color sheetAlt;
  final Color shadow;

  const OrigamiColors({
    required this.fold,
    required this.facetA,
    required this.facetB,
    required this.chip,
    required this.footer,
    required this.sheetAlt,
    required this.shadow,
  });

  static const light = OrigamiColors(
    fold: AppColors.lightFold,
    facetA: AppColors.lightFacetA,
    facetB: AppColors.lightFacetB,
    chip: AppColors.lightChip,
    footer: AppColors.lightFooter,
    sheetAlt: AppColors.lightSheetAlt,
    shadow: AppColors.lightShadow,
  );

  static const dark = OrigamiColors(
    fold: AppColors.darkFold,
    facetA: AppColors.darkFacetA,
    facetB: AppColors.darkFacetB,
    chip: AppColors.darkChip,
    footer: AppColors.darkFooter,
    sheetAlt: AppColors.darkSheetAlt,
    shadow: AppColors.darkShadow,
  );

  static OrigamiColors of(BuildContext context) =>
      Theme.of(context).extension<OrigamiColors>() ?? light;

  @override
  OrigamiColors copyWith({
    Color? fold,
    Color? facetA,
    Color? facetB,
    Color? chip,
    Color? footer,
    Color? sheetAlt,
    Color? shadow,
  }) => OrigamiColors(
    fold: fold ?? this.fold,
    facetA: facetA ?? this.facetA,
    facetB: facetB ?? this.facetB,
    chip: chip ?? this.chip,
    footer: footer ?? this.footer,
    sheetAlt: sheetAlt ?? this.sheetAlt,
    shadow: shadow ?? this.shadow,
  );

  @override
  OrigamiColors lerp(ThemeExtension<OrigamiColors>? other, double t) {
    if (other is! OrigamiColors) return this;
    return OrigamiColors(
      fold: Color.lerp(fold, other.fold, t)!,
      facetA: Color.lerp(facetA, other.facetA, t)!,
      facetB: Color.lerp(facetB, other.facetB, t)!,
      chip: Color.lerp(chip, other.chip, t)!,
      footer: Color.lerp(footer, other.footer, t)!,
      sheetAlt: Color.lerp(sheetAlt, other.sheetAlt, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}
