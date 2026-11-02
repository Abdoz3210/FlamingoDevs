import 'dart:ui' as ui;

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

/// The flamingo logo as a decoded image, so the progress lines can draw it
/// as their marker. Loaded once for the whole app.
class FlamingoMark {
  FlamingoMark._();

  static const asset = 'assets/images/logo/flamingo_mark.png';

  /// Null until the image has loaded; painters repaint when it changes.
  static final ValueNotifier<ui.Image?> image = ValueNotifier<ui.Image?>(null);

  static bool _started = false;

  static void ensureLoaded() {
    if (_started) return;
    _started = true;
    final stream = const AssetImage(asset).resolve(ImageConfiguration.empty);
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        // Keep our own handle so the image cache can never dispose it.
        image.value = info.clone().image;
        stream.removeListener(listener);
      },
      onError: (error, stackTrace) {
        _started = false;
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
  }
}

class ZigzagLinePainter extends CustomPainter {
  ZigzagLinePainter({
    required this.progress,
    required this.baseColor,
    required this.accentColor,
    this.showMarker = true,
    this.markerOpacity = 1,
  }) : super(repaint: FlamingoMark.image);

  /// 0..1: how much of the line is drawn in the accent color.
  final double progress;
  final Color baseColor;
  final Color accentColor;
  final bool showMarker;
  final double markerOpacity;

  /// The flamingo stands on the line, so it is drawn this tall and its feet
  /// rest at [_feetY].
  static const double _markerHeight = 22;
  static const double _feetY = 13.5;

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

    final bird = FlamingoMark.image.value;
    if (showMarker && markerOpacity > 0.01 && bird != null) {
      final w = _markerHeight * bird.width / bird.height;
      // The bird slides along the line and never leaves the edges:
      // left = p * 100%, shifted back by p * its own width.
      final x = (size.width - w) * p;
      canvas.drawImageRect(
        bird,
        Rect.fromLTWH(0, 0, bird.width.toDouble(), bird.height.toDouble()),
        Rect.fromLTWH(x, _feetY - _markerHeight, w, _markerHeight),
        Paint()
          ..filterQuality = FilterQuality.medium
          ..color = Color.fromRGBO(255, 255, 255, markerOpacity.clamp(0.0, 1.0)),
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
    FlamingoMark.ensureLoaded();
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
