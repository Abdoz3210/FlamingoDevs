import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:bma_portfolio/presentation/shared_widgets/origami_widgets.dart';
import 'package:flutter/material.dart';

/// Shared Hero tag: the card cover on the home page and the band on the
/// project page are the same paper, so it unfolds from one to the other.
String projectHeroTag(String slug) => 'project-cover-$slug';

/// A project cover image with its top-right corner folded away.
/// With [aspectRatio] null it fills whatever space it is given.
class ProjectCover extends StatelessWidget {
  const ProjectCover({
    super.key,
    required this.project,
    this.cut = 28,
    this.aspectRatio = 16 / 10,
  });

  final ProjectModel project;
  final double cut;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fold = OrigamiColors.of(context).fold;

    final art = Stack(
      fit: StackFit.expand,
      children: [
        ClipPath(
          clipper: CutCornerClipper(cut),
          child: ColoredBox(
            color: scheme.surfaceContainerHighest,
            child: Image.asset(
              project.coverImage,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              excludeFromSemantics: true,
              errorBuilder: (_, _, _) => Center(
                child: Icon(
                  Icons.image_outlined,
                  color: scheme.outline,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          width: cut,
          height: cut,
          child: CustomPaint(painter: _FlapPainter(fold)),
        ),
      ],
    );

    return Hero(
      tag: projectHeroTag(project.slug),
      child: aspectRatio == null
          ? art
          : AspectRatio(aspectRatio: aspectRatio!, child: art),
    );
  }
}

class _FlapPainter extends CustomPainter {
  const _FlapPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _FlapPainter old) => old.color != color;
}
