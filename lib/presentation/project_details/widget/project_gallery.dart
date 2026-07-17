import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:flutter/material.dart';

class ProjectGallery extends StatelessWidget {
  final ProjectModel project;
  const ProjectGallery({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final images = project.gallery;
    if (images.isEmpty) return const SizedBox.shrink();

    final padding = EdgeInsets.symmetric(
      horizontal: Responsive.sideMargin(context),
    );

    if (isMobile) {
      return Padding(
        padding: padding,
        child: Column(
          children: images
              .map(
                (img) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AspectRatio(
                    aspectRatio: 1.3,
                    child: _img(context, img.path),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    final small = images
        .where((i) => i.size == GalleryImageSize.small)
        .toList();
    final tall = images.where((i) => i.size == GalleryImageSize.tall).toList();
    final large = images
        .where((i) => i.size == GalleryImageSize.large)
        .toList();

    return Padding(
      padding: padding,
      child: SizedBox(
        height: 520,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (small.isNotEmpty)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    for (var i = 0; i < small.length; i++) ...[
                      Expanded(child: _img(context, small[i].path)),
                      if (i != small.length - 1) const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),

            const SizedBox(width: 16),
            if (tall.isNotEmpty)
              Expanded(flex: 3, child: _img(context, tall.first.path)),
            const SizedBox(width: 16),

            // Right — large
            if (large.isNotEmpty)
              Expanded(flex: 4, child: _img(context, large.first.path)),
          ],
        ),
      ),
    );
  }

  Widget _img(BuildContext context, String path) {
    final colors = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => Container(
          color: colors.surfaceContainerHighest,
          child: Icon(Icons.image_outlined, color: colors.outline),
        ),
      ),
    );
  }
}
