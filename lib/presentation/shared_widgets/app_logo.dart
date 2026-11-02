import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/presentation/shared_widgets/paper_edge.dart';
import 'package:flutter/material.dart';

/// The origami flamingo with the "Flamingo" wordmark beside it.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 28, this.showWordmark = true});

  /// Base size. The bird is a little taller than this and the wordmark
  /// scales with it.
  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          FlamingoMark.asset,
          height: size * 1.3,
          fit: BoxFit.fitHeight,
          filterQuality: FilterQuality.medium,
          excludeFromSemantics: true,
        ),
        if (showWordmark) ...[
          SizedBox(width: size * 0.34),
          Text(
            'Flamingo',
            style: AppTypogragh.origami(color: ink).copyWith(
              fontSize: size * 0.78,
              height: 1,
            ),
          ),
        ],
      ],
    );
  }
}
