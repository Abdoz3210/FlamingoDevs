import 'dart:math' as math;

import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:bma_portfolio/presentation/shared_widgets/origami_widgets.dart';
import 'package:flutter/material.dart';

/// Shared Hero tag: the card cover on the home page and the band on the
/// project page are the same paper, so it unfolds from one to the other.
String projectHeroTag(String slug) => 'project-cover-$slug';

/// The four colors a project's cover art is drawn with. [c] and [d] make the
/// gradient behind everything; [a] and [b] are the two big folds.
class ProjectPalette {
  const ProjectPalette(this.a, this.b, this.c, this.d);

  final Color a;
  final Color b;
  final Color c;
  final Color d;

  static const _all = <ProjectPalette>[
    ProjectPalette(
      Color(0xFFFF9E7A),
      Color(0xFFC2305A),
      Color(0xFFFFD0DA),
      Color(0xFFFF5C8A),
    ),
    ProjectPalette(
      Color(0xFFFF5C8A),
      Color(0xFFFFB3C1),
      Color(0xFFFFE0E6),
      Color(0xFFC2305A),
    ),
    ProjectPalette(
      Color(0xFFC2305A),
      Color(0xFFFF8F6E),
      Color(0xFFFFCDBD),
      Color(0xFFF0567F),
    ),
    ProjectPalette(
      Color(0xFFFF7A9C),
      Color(0xFFC2305A),
      Color(0xFFFFB3C1),
      Color(0xFFE4502F),
    ),
  ];

  static const _bySlug = <String, int>{
    'my-coffee-shop': 0,
    'weather-app-ios': 1,
    'money-tracker-ios': 2,
    'news-cloud-app': 3,
  };

  /// Each known project keeps its own palette; a new one gets a stable pick.
  static ProjectPalette forSlug(String slug) {
    final known = _bySlug[slug];
    if (known != null) return _all[known];
    var h = 0;
    for (final u in slug.codeUnits) {
      h = (h * 31 + u) & 0x7fffffff;
    }
    return _all[h % _all.length];
  }
}

/// The slow, soft curve the folds and the phone move on when a card is lit.
const Curve kFoldCurve = Cubic(0.2, 0.8, 0.3, 1.0);

/// Cover art: four folded triangles over a gradient. When [lit] turns true
/// (the card is hovered or focused) three of the folds drift and turn.
class ProjectArt extends StatelessWidget {
  const ProjectArt({super.key, required this.palette, this.lit = false});

  final ProjectPalette palette;
  final bool lit;

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: (lit && !still) ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 600),
      curve: kFoldCurve,
      builder: (context, k, _) {
        return LayoutBuilder(
          builder: (context, box) {
            final w = box.maxWidth;
            final h = box.maxHeight;

            // left, top, width, height in percent of the cover; drift is the
            // hover move as a fraction of the triangle's own size.
            Widget fold(
              double l,
              double t,
              double fw,
              double fh,
              Color color,
              double opacity, {
              double dx = 0,
              double dy = 0,
              double degrees = 0,
            }) {
              final bw = fw * w / 100;
              final bh = fh * h / 100;
              return Positioned(
                left: l * w / 100,
                top: t * h / 100,
                width: bw,
                height: bh,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.translationValues(
                    dx * bw * k,
                    dy * bh * k,
                    0,
                  )..rotateZ(degrees * math.pi / 180 * k),
                  child: ClipPath(
                    clipper: const _TriangleClipper(),
                    child: ColoredBox(color: color.withValues(alpha: opacity)),
                  ),
                ),
              );
            }

            return ClipRect(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [palette.c, palette.d],
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    fold(-10, 30, 70, 90, palette.a, 1,
                        dx: -0.04, dy: -0.05, degrees: -3),
                    fold(40, -10, 65, 100, palette.b, 0.9,
                        dx: 0.03, dy: 0.06, degrees: 3),
                    fold(62, 46, 40, 62, palette.c, 1, dx: 0.05, dy: -0.04),
                    fold(6, 6, 28, 44, palette.d, 0.8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  const _TriangleClipper();

  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width / 2, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// A small phone that rises out of the bottom of a card cover. On [lit] it
/// lifts and tilts a little.
class ProjectMiniPhone extends StatelessWidget {
  const ProjectMiniPhone({super.key, required this.palette, this.lit = false});

  final ProjectPalette palette;
  final bool lit;

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        final h = box.maxHeight;
        final pw = w * 0.31;
        final ph = pw * 19 / 9;

        return ClipRect(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: (w - pw) / 2,
                bottom: -0.16 * h,
                width: pw,
                height: ph,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: (lit && !still) ? 1.0 : 0.0),
                  duration: const Duration(milliseconds: 500),
                  curve: kFoldCurve,
                  builder: (context, k, child) => Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.translationValues(0, -0.14 * ph * k, 0)
                      ..rotateZ(-3 * math.pi / 180 * k),
                    child: child,
                  ),
                  child: _PhoneBody(palette: palette),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PhoneBody extends StatelessWidget {
  const _PhoneBody({required this.palette});

  final ProjectPalette palette;

  static const _bar = Color(0xFFE3C9CD);

  Widget _line(double widthFactor) => FractionallySizedBox(
    widthFactor: widthFactor,
    alignment: Alignment.centerLeft,
    child: Container(
      height: 7,
      decoration: BoxDecoration(
        color: _bar,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F2),
        border: Border.all(color: const Color(0xFF1C1019), width: 4),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x73000000),
            blurRadius: 24,
            spreadRadius: -10,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [palette.a, palette.b],
                ),
              ),
            ),
            const SizedBox(height: 5),
            _line(0.8),
            const SizedBox(height: 5),
            _line(0.58),
            const SizedBox(height: 5),
            _line(0.7),
          ],
        ),
      ),
    );
  }
}

/// A project's cover art with its own Hero, so it can fly into the band on
/// the project page. [cut] folds the top-right corner away (0 for none).
/// With [aspectRatio] null it fills whatever space it is given.
class ProjectCover extends StatelessWidget {
  const ProjectCover({
    super.key,
    required this.project,
    this.cut = 0,
    this.aspectRatio = 4 / 3,
    this.lit = false,
  });

  final ProjectModel project;
  final double cut;
  final double? aspectRatio;
  final bool lit;

  @override
  Widget build(BuildContext context) {
    final fold = OrigamiColors.of(context).fold;
    final art = ProjectArt(
      palette: ProjectPalette.forSlug(project.slug),
      lit: lit,
    );

    Widget cover = cut > 0
        ? Stack(
            fit: StackFit.expand,
            children: [
              ClipPath(clipper: CutCornerClipper(cut), child: art),
              Positioned(
                top: 0,
                right: 0,
                width: cut,
                height: cut,
                child: CustomPaint(painter: _FlapPainter(fold)),
              ),
            ],
          )
        : art;

    if (aspectRatio != null) {
      cover = AspectRatio(aspectRatio: aspectRatio!, child: cover);
    }
    return Hero(tag: projectHeroTag(project.slug), child: cover);
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
