import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppGradient {
  AppGradient._();

  static LinearGradient of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      colors: isDark ? AppColors.darkGradient : AppColors.lightGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomLeft,
    );
  }

  static Widget Text({required BuildContext context, required Widget child}) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => of(context).createShader(bounds),
      child: child,
    );
  }
}
