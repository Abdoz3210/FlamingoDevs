import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 200, this.showWordmark = true});

  final double size;
  final bool showWordmark;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final assetPath = isDark
        ? 'images/logo/icon_dark.png'
        : 'images/logo/icon_light.png';

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
          SizedBox(width: size * 0.32),
          Text(
            'Flamingo',
            style: AppTypogragh.mono(color: textColor).copyWith(
              fontWeight: FontWeight.w700,
              fontSize: size * 0.2,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
