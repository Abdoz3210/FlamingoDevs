import 'dart:async';
import 'dart:math' as math;

import 'package:bma_portfolio/core/themes/app_gradient.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Fades and lifts [child] into place the first time it scrolls into view.
/// [delay] staggers siblings, like the stacked entrance of the paper sheets.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 22,
    this.duration = const Duration(milliseconds: 800),
  });

  final Widget child;
  final Duration delay;
  final double offset;
  final Duration duration;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _a = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutCubic,
  );
  final _visibilityKey = UniqueKey();
  Timer? _timer;
  bool _started = false;

  void _start() {
    if (_started) return;
    _started = true;
    if (widget.delay == Duration.zero) {
      _c.forward();
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.06) _start();
      },
      child: AnimatedBuilder(
        animation: _a,
        child: widget.child,
        builder: (context, child) => Opacity(
          opacity: _a.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _a.value) * widget.offset),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A headline whose words fold open one after another, like paper being
/// unfolded. [lead] is plain, [accent] is painted with the pink gradient.
class FoldHeadline extends StatefulWidget {
  const FoldHeadline({
    super.key,
    required this.lead,
    this.accent = '',
    required this.style,
    this.textAlign = WrapAlignment.start,
    this.startDelay = const Duration(milliseconds: 100),
  });

  final String lead;
  final String accent;
  final TextStyle style;
  final WrapAlignment textAlign;
  final Duration startDelay;

  @override
  State<FoldHeadline> createState() => _FoldHeadlineState();
}

class _FoldHeadlineState extends State<FoldHeadline>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );
  final _visibilityKey = UniqueKey();
  Timer? _timer;
  bool _started = false;

  void _start() {
    if (_started) return;
    _started = true;
    _timer = Timer(widget.startDelay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  List<String> _words(String s) =>
      s.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

  @override
  Widget build(BuildContext context) {
    final lead = _words(widget.lead);
    final accent = _words(widget.accent);
    final total = lead.length + accent.length;
    final still = MediaQuery.disableAnimationsOf(context);
    final gap = widget.style.fontSize == null ? 10.0 : widget.style.fontSize! * 0.28;

    Widget word(String text, int i, bool gradient) {
      Widget t = Text(text, style: widget.style);
      if (gradient) t = AppGradient.text(context: context, child: t);
      if (still) return t;
      // Each word has its own slice of the controller's timeline.
      final start = total <= 1 ? 0.0 : (i / total) * 0.55;
      final curve = _c.drive(
        CurveTween(
          curve: Interval(
            start,
            math.min(1.0, start + 0.45),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
      return AnimatedBuilder(
        animation: curve,
        child: t,
        builder: (context, child) {
          final v = curve.value;
          return Opacity(
            opacity: v,
            child: Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateX((1 - v) * -1.1),
              child: child,
            ),
          );
        },
      );
    }

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1) _start();
      },
      child: Semantics(
        header: true,
        label: '${widget.lead} ${widget.accent}'.trim(),
        child: ExcludeSemantics(
          child: Wrap(
            alignment: widget.textAlign,
            spacing: gap,
            runSpacing: 0,
            children: [
              for (var i = 0; i < lead.length; i++) word(lead[i], i, false),
              for (var i = 0; i < accent.length; i++)
                word(accent[i], lead.length + i, true),
            ],
          ),
        ),
      ),
    );
  }
}
