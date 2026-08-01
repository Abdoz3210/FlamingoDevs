import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 200, this.showWordmark = true});

  final double size;
  final bool showWordmark;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness;
    // final textColor = Theme.of(context).colorScheme.onSurface;
    final assetPath = isDark
        ? 'assets/images/logo/icon_dark.png'
        : 'assets/images/logo/icon_light.png';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          assetPath,
          height: size,
          fit: BoxFit.fitHeight,

          // errorBuilder: (_, __, ___) =>
          //     Icon(Icons.terrain_outlined, size: size, color: textColor),
        ),
        if (showWordmark) ...[
          SizedBox(width: size * 0.42),
          Text(
            'FLAMINGO Devs',
            textAlign: TextAlign.center,
            style: AppTypogragh.origami(color: AppColors.lightPrimary).copyWith(
              // fontWeight: FontWeight.w700,
              fontSize: size * 0.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ],
      ],
    );
  }
}
