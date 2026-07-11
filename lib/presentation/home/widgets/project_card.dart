import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() {
        _hovered = true;
      }),
      onExit: (_) => setState(() {
        _hovered = true;
      }),

      child: GestureDetector(
        onTap: () => context.goNamed(
          RouterNames.projectDetails,
          pathParameters: {'slug': widget.project.slug},
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hovered
                        ? colors.primary.withValues(alpha: 0.5)
                        : Colors.transparent,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  widget.project.coverImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: colors.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_outlined,
                      color: colors.outline,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.project.category.toUpperCase(),
              style: AppTypogragh.mono(color: colors.primary, fontSize: 11),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.project.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                AnimatedSlide(
                  offset: _hovered ? const Offset(9.3, 0) : Offset.zero,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.arrow_outward,
                    size: 18,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.project.shortDescription,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
