import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:flutter/material.dart';

class ProjectDescription extends StatelessWidget {
  final ProjectModel project;

  const ProjectDescription({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.sideMargin(context),
        vertical: isMobile ? 40 : 80,
      ),
      child: isMobile ? _buildMobile(context) : _buildDesktop(context),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildNarrative(context)),
        const SizedBox(width: 48),
        Expanded(flex: 2, child: _buildPanel(context)),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNarrative(context),
        const SizedBox(height: 32),
        _buildPanel(context),
      ],
    );
  }

  Widget _buildNarrative(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The Challenge.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 14),
        Text(project.challenge, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 36),
        Text('The Solution', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 14),
        Text(project.solution, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildPanel(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TECH STACK',
            style: AppTypogragh.mono(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.techStack
                .map((t) => _TechChip(label: t))
                .toList(),
          ),
          const SizedBox(height: 28),
          Divider(color: colors.outlineVariant),
          const SizedBox(height: 20),
          Text(
            'PROJECT METRICS',
            style: AppTypogragh.mono(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          for (final metrics in project.metrics)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    metrics.label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    metrics.value,
                    style: AppTypogragh.mono(
                      color: colors.primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTypogragh.mono(color: colors.onSurfaceVariant, fontSize: 11),
      ),
    );
  }
}
