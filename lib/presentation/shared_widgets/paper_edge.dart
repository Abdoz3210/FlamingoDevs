import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// Shared zigzag geometry. The header progress line, every sheet's top edge
// and the project page progress line all use the same tooth shape, so they
// read as one paper-cut system.
// ─────────────────────────────────────────────────────────────

/// Valley and peak heights of the zigzag, in logical pixels.
const double kZigLow = 12;
const double kZigHigh = 2;

/// Height of the painted line, including room for the marker.
const double kZigLineHeight = 18;

/// The line is drawn this far down so the marker has room above it.
const double kZigPad = 2;

/// Clamps [v] into [lo]..[hi]. A typed helper, so call sites stay `double`.
double clampUnit(double v, [double lo = 0, double hi = 1]) =>
    v < lo ? lo : (v > hi ? hi : v);

/// Number of zigzag segments for a given width. Always even, about one tooth
/// pair per 32 px, so teeth stay the same size on phones and desktops.
int zigSegments(double width) {
  final n = 2 * (width / 32).round();
  return n < 12 ? 12 : n;
}

/// Clips a box so its top edge becomes the zigzag. Used by every sheet.
class ZigzagTopClipper extends CustomClipper<Path> {
  const ZigzagTopClipper();

  @override
  Path getClip(Size size) {
    final n = zigSegments(size.width);
    final path = Path()..moveTo(0, kZigLow);
    for (var i = 1; i <= n; i++) {
      path.lineTo(size.width * i / n, i.isOdd ? kZigHigh : kZigLow);
    }
    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Paints the three-fold flamingo mark into [r].
void paintOrigamiMark(Canvas canvas, Rect r, {double opacity = 1}) {
  final s = r.width / 32;
  Offset p(double x, double y) => Offset(r.left + x * s, r.top + y * s);
  void tri(List<Offset> pts, Color c) => canvas.drawPath(
    Path()..addPolygon(pts, true),
    Paint()..color = c.withValues(alpha: opacity),
  );
  tri([p(16, 3), p(29, 27), p(16, 21)], AppColors.markPink);
  tri([p(16, 3), p(3, 27), p(16, 21)], AppColors.markCoral);
  tri([p(3, 27), p(29, 27), p(16, 21)], AppColors.markDeep);
}

class ZigzagLinePainter extends CustomPainter {
  const ZigzagLinePainter({
    required this.progress,
    required this.baseColor,
    required this.accentColor,
    this.showMarker = true,
    this.markerOpacity = 1,
  });

  /// 0..1: how much of the line is drawn in the accent color.
  final double progress;
  final Color baseColor;
  final Color accentColor;
  final bool showMarker;
  final double markerOpacity;

  static const double _markerSize = 18;

  @override
  void paint(Canvas canvas, Size size) {
    final n = zigSegments(size.width);
    final path = Path()..moveTo(0, kZigLow + kZigPad);
    for (var i = 1; i <= n; i++) {
      path.lineTo(
        size.width * i / n,
        (i.isOdd ? kZigHigh : kZigLow) + kZigPad,
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeJoin = StrokeJoin.round
        ..color = baseColor,
    );

    final p = clampUnit(progress);
    if (p > 0) {
      final accent = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..color = accentColor;
      for (final metric in path.computeMetrics()) {
        canvas.drawPath(metric.extractPath(0, metric.length * p), accent);
      }
    }

    if (showMarker && markerOpacity > 0.01) {
      // The marker slides along the line and never leaves the edges:
      // left = p * 100%, shifted back by p * its own width.
      final x = (size.width - _markerSize) * p;
      paintOrigamiMark(
        canvas,
        Rect.fromLTWH(x, 0, _markerSize, _markerSize),
        opacity: markerOpacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ZigzagLinePainter old) =>
      old.progress != progress ||
      old.baseColor != baseColor ||
      old.accentColor != accentColor ||
      old.showMarker != showMarker ||
      old.markerOpacity != markerOpacity;
}

/// The zigzag progress line. Place it so its vertical center sits on the edge
/// it decorates (the bottom of the header, the top of a sheet).
class ZigzagLine extends StatelessWidget {
  const ZigzagLine({
    super.key,
    required this.progress,
    this.baseColor,
    this.accentColor,
    this.showMarker = true,
    this.markerOpacity = 1,
  });

  final double progress;
  final Color? baseColor;
  final Color? accentColor;
  final bool showMarker;
  final double markerOpacity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: IgnorePointer(
        child: SizedBox(
          height: kZigLineHeight,
          width: double.infinity,
          child: CustomPaint(
            painter: ZigzagLinePainter(
              progress: progress,
              baseColor: baseColor ?? scheme.outlineVariant,
              accentColor: accentColor ?? scheme.primary,
              showMarker: showMarker,
              markerOpacity: markerOpacity,
            ),
          ),
        ),
      ),
    );
  }
}
