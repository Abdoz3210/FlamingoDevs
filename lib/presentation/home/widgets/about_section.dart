import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/presentation/shared_widgets/section_title.dart';
import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.sideMargin(context),
        vertical: isMobile ? 40 : 80,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 24 : 40),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: isMobile ? _buildMobile(context) : _buildDesktop(context),
      ),
    );
  }
}

Widget _buildDesktop(BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(flex: 3, child: _buildText(context)),
      const SizedBox(width: 48),
      Expanded(child: _buildStates(context)),
    ],
  );
}

Widget _buildMobile(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(flex: 3, child: _buildText(context)),
      const SizedBox(width: 48),
      Expanded(child: _buildStates(context)),
    ],
  );
}

Widget _buildStates(BuildContext context) {
  return Wrap(
    spacing: 12,
    runSpacing: 12,
    children: const [
      _StatCard(value: '6+', label: 'PROJECT SHIPED'),
      _StatCard(value: '3', label: 'PLATFORMS       '),
      _StatCard(value: '100%', label: 'CUSTOM BUILT   '),
      _StatCard(value: '100%', label: 'CUSTOM DESIGN'),
    ],
  );
}

Widget _buildText(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(eyebrow: 'Our Philosophy', title: 'The Three Minds'),
      const SizedBox(height: 24),
      Text(
        'At Flamingo, we operate at the intersection of three '
        'distinct disciplines: the Architect, the Engineer, '
        'and the Strategist.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 12),
      Text(
        'The Architect ensures structural beauty and intuitive '
        'user flow. The Engineer guarantees unbreakable '
        'performance and modular codebases. The Strategist '
        'aligns every pixel with your long-term business goals.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 12),
      Text(
        "This holistic approach allows us to deliver mobile "
        "experiences that aren't just built, but engineered "
        "for longevity and market dominance.",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ],
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard({super.key, required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
