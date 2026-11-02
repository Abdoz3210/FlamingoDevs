import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/presentation/shared_widgets/origami_widgets.dart';
import 'package:flutter/material.dart';

/// The folded-paper mark with the "Flamingo" wordmark beside it.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 28, this.showWordmark = true});

  /// Height of the mark. The wordmark scales with it.
  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OrigamiMark(size: size),
        if (showWordmark) ...[
          SizedBox(width: size * 0.38),
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
