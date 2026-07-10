import 'package:bma_portfolio/core/themes/app_gradient.dart';
import 'package:bma_portfolio/data/models/service_model.dart';
import 'package:flutter/material.dart';

IconData _iconFor(String key) {
  switch (key) {
    case 'mobile':
      return Icons.smartphone_outlined;
    case 'design':
      return Icons.draw_outlined;
    case 'deployment':
      return Icons.rocket_launch_outlined;
    case 'ai':
      return Icons.auto_awesome_outlined;
    case 'backend':
      return Icons.dns_outlined;
    case 'crossplatform':
      return Icons.devices_outlined;
    default:
      return Icons.circle_outlined;
  }
}

class ServiceCard extends StatefulWidget {
  final ServiceModel service;
  const ServiceCard({super.key, required this.service});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        // Lifts 4px on hover — subtle, purposeful
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? colors.primary.withValues(alpha: 0.5)
                : colors.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,

          children: [
            // Icon — gradient colored on hover, muted when idle
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  (_hovered
                          ? AppGradient.of(context)
                          : LinearGradient(
                              colors: [
                                colors.onSurfaceVariant,
                                colors.onSurfaceVariant,
                              ],
                            ))
                      .createShader(bounds),
              child: Icon(_iconFor(widget.service.iconKey), size: 26),
            ),
            const SizedBox(height: 20),
            Text(
              widget.service.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              widget.service.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
