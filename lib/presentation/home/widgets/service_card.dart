import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/core/themes/app_gradient.dart';
import 'package:bma_portfolio/data/models/service_model.dart';
import 'package:bma_portfolio/presentation/shared_widgets/origami_widgets.dart';
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
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        // Lifts 4px on hover, like a sheet lifting off the desk.
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        child: FoldedCard(
          borderColor: _hovered
              ? scheme.primary.withValues(alpha: 0.5)
              : scheme.outlineVariant,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // A folded tile: gradient fill, one corner cut away.
              ClipPath(
                clipper: const CutCornerClipper(12),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(gradient: AppGradient.of(context)),
                  child: Icon(
                    _iconFor(widget.service.iconKey),
                    size: 22,
                    color: AppColors.onGradient,
                  ),
                ),
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
      ),
    );
  }
}
