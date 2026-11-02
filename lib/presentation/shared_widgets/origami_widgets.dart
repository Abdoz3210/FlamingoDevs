import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/presentation/shared_widgets/paper_edge.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// Corner cut: a rectangle with its top-right corner folded away.
// ─────────────────────────────────────────────────────────────
Path cutCornerPath(Size size, double cut) {
  final c = cut < 0 ? 0.0 : cut;
  return Path()
    ..moveTo(0, 0)
    ..lineTo(size.width - c, 0)
    ..lineTo(size.width, c)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();
}

class CutCornerClipper extends CustomClipper<Path> {
  const CutCornerClipper(this.cut);
  final double cut;

  @override
  Path getClip(Size size) => cutCornerPath(size, cut);

  @override
  bool shouldReclip(covariant CutCornerClipper oldClipper) =>
      oldClipper.cut != cut;
}

// ─────────────────────────────────────────────────────────────
// FoldedCard: a card with its top-right corner folded over.
// ─────────────────────────────────────────────────────────────
class FoldedCard extends StatelessWidget {
  final Widget child;
  final double fold;
  final EdgeInsetsGeometry padding;
  final Color? background;
  final Color? borderColor;

  const FoldedCard({
    super.key,
    required this.child,
    this.fold = 30,
    this.padding = const EdgeInsets.fromLTRB(28, 32, 28, 32),
    this.background,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final origami = OrigamiColors.of(context);

    return CustomPaint(
      foregroundPainter: _FoldPainter(
        fold: fold,
        flapColor: origami.fold,
        borderColor: borderColor ?? scheme.outlineVariant,
      ),
      child: ClipPath(
        clipper: CutCornerClipper(fold),
        child: Container(
          color: background ?? scheme.surfaceContainer,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class _FoldPainter extends CustomPainter {
  final double fold;
  final Color flapColor;
  final Color borderColor;

  const _FoldPainter({
    required this.fold,
    required this.flapColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      cutCornerPath(size, fold),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = borderColor,
    );

    // The folded flap: the triangle that covers the cut corner.
    final flap = Path()
      ..moveTo(size.width - fold, 0)
      ..lineTo(size.width, fold)
      ..lineTo(size.width - fold, fold)
      ..close();
    canvas.drawPath(flap, Paint()..color = flapColor);
  }

  @override
  bool shouldRepaint(covariant _FoldPainter old) =>
      old.fold != fold ||
      old.flapColor != flapColor ||
      old.borderColor != borderColor;
}

// ─────────────────────────────────────────────────────────────
// OrigamiMark: the three-fold triangle used as the brand mark.
// ─────────────────────────────────────────────────────────────
class OrigamiMark extends StatelessWidget {
  final double size;
  const OrigamiMark({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(size: Size(size, size), painter: const _MarkPainter()),
  );
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    paintOrigamiMark(canvas, Offset.zero & size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────
// PaperTeeth: a strip of paper triangles that fold up one after another
// when [visible] turns true. Sits at the very bottom of the footer.
// ─────────────────────────────────────────────────────────────
class PaperTeeth extends StatefulWidget {
  const PaperTeeth({super.key, required this.visible, this.height = 26});

  final bool visible;
  final double height;

  @override
  State<PaperTeeth> createState() => _PaperTeethState();
}

class _PaperTeethState extends State<PaperTeeth>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void initState() {
    super.initState();
    if (widget.visible) _c.forward();
  }

  @override
  void didUpdateWidget(covariant PaperTeeth oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !oldWidget.visible) _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);
    return ExcludeSemantics(
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: CustomPaint(painter: _TeethPainter(_c, still)),
      ),
    );
  }
}

class _TeethPainter extends CustomPainter {
  _TeethPainter(this.progress, this.still) : super(repaint: progress);

  final Animation<double> progress;
  final bool still;

  static const double _w = 18;
  static const _palette = [
    AppColors.markPink,
    AppColors.markDeep,
    AppColors.markCoral,
    Color(0xFFFFD0DA),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final step = _w - 1;
    final n = (size.width / step).ceil() + 1;
    final live = still ? 1.0 : progress.value;
    for (var i = 0; i < n; i++) {
      final start = (i / n) * 0.7;
      final local = clampUnit((live - start) / 0.3);
      if (local <= 0) continue;
      final k = clampUnit(Curves.easeOutBack.transform(local), 0, 1.08);
      final x0 = i * step;
      final h = size.height * k;
      final path = Path()
        ..moveTo(x0, size.height)
        ..lineTo(x0 + _w / 2, size.height - h)
        ..lineTo(x0 + _w, size.height)
        ..close();
      canvas.drawPath(path, Paint()..color = _palette[i % _palette.length]);
    }
  }

  @override
  bool shouldRepaint(covariant _TeethPainter old) =>
      old.progress != progress || old.still != still;
}
