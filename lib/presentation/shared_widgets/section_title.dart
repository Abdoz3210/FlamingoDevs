import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/presentation/shared_widgets/reveal.dart';
import 'package:flutter/material.dart';

/// Small mono label above a headline whose words fold open as it scrolls in.
/// [accent] words are painted with the pink gradient.
class SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String accent;
  final TextAlign align;

  const SectionTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    this.accent = '',
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final centered = align == TextAlign.center;
    final style = Responsive.isMobile(context)
        ? AppTypogragh.headlineMobile(color: scheme.onSurface)
        : Theme.of(context).textTheme.headlineLarge!;

    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (eyebrow.isNotEmpty) ...[
          Reveal(
            child: Text(
              eyebrow.toUpperCase(),
              style: AppTypogragh.mono(color: scheme.primary, fontSize: 12),
            ),
          ),
          const SizedBox(height: 14),
        ],
        FoldHeadline(
          lead: title,
          accent: accent,
          style: style,
          textAlign: centered ? WrapAlignment.center : WrapAlignment.start,
        ),
      ],
    );
  }
}
