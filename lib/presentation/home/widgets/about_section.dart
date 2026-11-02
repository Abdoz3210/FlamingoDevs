import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/presentation/shared_widgets/origami_widgets.dart';
import 'package:bma_portfolio/presentation/shared_widgets/reveal.dart';
import 'package:bma_portfolio/presentation/shared_widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final vh = MediaQuery.sizeOf(context).height;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: vh),
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Responsive.sideMargin(context),
            isMobile ? 88 : 112,
            Responsive.sideMargin(context),
            isMobile ? 56 : 96,
          ),
          child: isMobile ? _buildMobile(context) : _buildDesktop(context),
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildText(context)),
        const SizedBox(width: 56),
        Expanded(flex: 2, child: _buildStats(context)),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(context),
        const SizedBox(height: 40),
        _buildStats(context),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _StatCard(value: 6, suffix: '+', label: 'PROJECTS SHIPPED'),
        _StatCard(value: 3, suffix: '', label: 'PLATFORMS'),
        _StatCard(value: 100, suffix: '%', label: 'CUSTOM BUILT'),
        _StatCard(value: 100, suffix: '%', label: 'CUSTOM DESIGN'),
      ],
    );
  }

  Widget _buildText(BuildContext context) {
    final body = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          eyebrow: 'About',
          title: 'Three minds.',
          accent: 'Infinite solutions.',
        ),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 400),
          child: Text(
            'At Flamingo, we operate at the intersection of three '
            'distinct disciplines: the Architect, the Engineer, '
            'and the Strategist.',
            style: body,
          ),
        ),
        const SizedBox(height: 12),
        Reveal(
          delay: const Duration(milliseconds: 500),
          child: Text(
            'The Architect ensures structural beauty and intuitive '
            'user flow. The Engineer guarantees unbreakable '
            'performance and modular codebases. The Strategist '
            'aligns every pixel with your long-term business goals.',
            style: body,
          ),
        ),
        const SizedBox(height: 12),
        Reveal(
          delay: const Duration(milliseconds: 600),
          child: Text(
            "This holistic approach allows us to deliver mobile "
            "experiences that aren't just built, but engineered "
            "for longevity and market dominance.",
            style: body,
          ),
        ),
      ],
    );
  }
}

/// A folded card with a number that counts up the first time it is seen.
class _StatCard extends StatefulWidget {
  const _StatCard({
    required this.value,
    required this.suffix,
    required this.label,
  });

  final int value;
  final String suffix;
  final String label;

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  final _visibilityKey = UniqueKey();
  bool _seen = false;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final scheme = Theme.of(context).colorScheme;
    final end = (_seen || reduced) ? widget.value.toDouble() : 0.0;

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: (info) {
        if (!_seen && info.visibleFraction > 0.2) {
          setState(() => _seen = true);
        }
      },
      child: Reveal(
        delay: const Duration(milliseconds: 600),
        child: SizedBox(
          width: 170,
          child: FoldedCard(
            fold: 22,
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: end),
                  duration: const Duration(milliseconds: 1300),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, _) => Text(
                    '${v.round()}${widget.suffix}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: scheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.label,
                  style: AppTypogragh.mono(
                    color: scheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
