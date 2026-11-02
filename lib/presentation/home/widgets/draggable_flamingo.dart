import 'dart:math' as math;

import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/presentation/shared_widgets/paper_edge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

/// The origami flamingo from the hero. Drag it anywhere on screen: it keeps
/// its momentum, bounces off the screen edges and leans into the throw.
/// Double-tap, Escape or Home sends it back; the arrow keys nudge it.
///
/// Light mode shows the pink bird, dark mode the plum one.
class DraggableFlamingo extends StatefulWidget {
  const DraggableFlamingo({super.key, this.height = 520});

  final double height;

  @override
  State<DraggableFlamingo> createState() => _DraggableFlamingoState();
}

enum _Motion { idle, fling, home }

class _DraggableFlamingoState extends State<DraggableFlamingo>
    with TickerProviderStateMixin {
  static const _pinkAsset = 'assets/images/flamingo/flamingo_pink.webp';
  static const _plumAsset = 'assets/images/flamingo/flamingo_plum.webp';

  late final Ticker _ticker = createTicker(_tick);
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  Offset _pos = Offset.zero;
  Offset _vel = Offset.zero;
  double _angle = 0;
  _Motion _motion = _Motion.idle;
  bool _dragging = false;
  bool _touched = false;
  double _last = 0;

  // Allowed translation range, measured when a drag starts.
  double _minX = -double.infinity;
  double _maxX = double.infinity;
  double _minY = -double.infinity;
  double _maxY = double.infinity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _float.stop();
    } else if (!_float.isAnimating) {
      _float.repeat();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _float.dispose();
    super.dispose();
  }

  void _startTicker() {
    _last = 0;
    if (!_ticker.isActive) _ticker.start();
  }

  /// Work out how far the bird may travel so it stays inside the screen.
  /// The bird is centered in this widget and about 0.7 x as wide as it is tall.
  void _measureBounds() {
    final ro = context.findRenderObject();
    if (ro is! RenderBox || !ro.hasSize) return;
    final screen = MediaQuery.sizeOf(context);
    final origin = ro.localToGlobal(Offset.zero);
    final birdW = widget.height * 0.7;
    final left = origin.dx + (ro.size.width - birdW) / 2;
    _minX = -left;
    _maxX = screen.width - (left + birdW);
    _minY = -origin.dy;
    _maxY = screen.height - (origin.dy + widget.height);
  }

  Offset _clampToBounds(Offset p) => Offset(
    clampUnit(p.dx, _minX, _maxX),
    clampUnit(p.dy, _minY, _maxY),
  );

  void _onPanStart(DragStartDetails d) {
    _measureBounds();
    _ticker.stop();
    setState(() {
      _dragging = true;
      _touched = true;
      _motion = _Motion.idle;
      _vel = Offset.zero;
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _pos = _clampToBounds(_pos + d.delta);
      _angle = clampUnit(_angle + d.delta.dx / 900, -0.45, 0.45);
    });
  }

  void _onPanEnd(DragEndDetails d) {
    setState(() {
      _dragging = false;
      _vel = d.velocity.pixelsPerSecond;
      _motion = _Motion.fling;
    });
    _startTicker();
  }

  void _sendHome() {
    if (_pos == Offset.zero && _angle == 0) return;
    _motion = _Motion.home;
    _startTicker();
  }

  void _nudge(Offset by) {
    _measureBounds();
    setState(() {
      _touched = true;
      _pos = _clampToBounds(_pos + by);
      _angle = clampUnit(by.dx / 120, -0.3, 0.3);
    });
    _motion = _Motion.fling;
    _vel = Offset.zero;
    _startTicker();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final step = HardwareKeyboard.instance.isShiftPressed ? 96.0 : 28.0;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      _nudge(Offset(-step, 0));
    } else if (key == LogicalKeyboardKey.arrowRight) {
      _nudge(Offset(step, 0));
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _nudge(Offset(0, -step));
    } else if (key == LogicalKeyboardKey.arrowDown) {
      _nudge(Offset(0, step));
    } else if (key == LogicalKeyboardKey.escape ||
        key == LogicalKeyboardKey.home) {
      _sendHome();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  void _tick(Duration elapsed) {
    final now = elapsed.inMicroseconds / 1000000.0;
    final dt = math.min(0.05, math.max(0.0, now - _last));
    _last = now;

    if (_motion == _Motion.fling) {
      _vel = _vel * math.pow(0.12, dt).toDouble(); // friction
      var p = _pos + _vel * dt;
      var v = _vel;
      if (p.dx < _minX) {
        p = Offset(_minX, p.dy);
        v = Offset(-v.dx * 0.55, v.dy);
      } else if (p.dx > _maxX) {
        p = Offset(_maxX, p.dy);
        v = Offset(-v.dx * 0.55, v.dy);
      }
      if (p.dy < _minY) {
        p = Offset(p.dx, _minY);
        v = Offset(v.dx, -v.dy * 0.55);
      } else if (p.dy > _maxY) {
        p = Offset(p.dx, _maxY);
        v = Offset(v.dx, -v.dy * 0.55);
      }
      _pos = p;
      _vel = v;
      if (_vel.distance < 14) {
        _vel = Offset.zero;
        _motion = _Motion.idle;
      }
    } else if (_motion == _Motion.home) {
      // A damped spring pulls the bird back to where it started.
      const k = 110.0;
      const c = 15.0;
      final acc = _pos * -k - _vel * c;
      _vel = _vel + acc * dt;
      _pos = _pos + _vel * dt;
      if (_pos.distance < 0.6 && _vel.distance < 6) {
        _pos = Offset.zero;
        _vel = Offset.zero;
        _motion = _Motion.idle;
      }
    }

    // Lean into the motion, then settle upright.
    final target = clampUnit(_vel.dx / 1700, -0.45, 0.45);
    _angle += (target - _angle) * (1 - math.exp(-dt * 7));

    final settled = _motion == _Motion.idle && _angle.abs() < 0.003;
    if (settled) {
      _angle = 0;
      _ticker.stop();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final h = widget.height;

    final bird = SizedBox(
      height: h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: isDark ? 0 : 1,
            duration: const Duration(milliseconds: 350),
            child: Image.asset(
              _pinkAsset,
              height: h,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              excludeFromSemantics: true,
            ),
          ),
          AnimatedOpacity(
            opacity: isDark ? 1 : 0,
            duration: const Duration(milliseconds: 350),
            child: Image.asset(
              _plumAsset,
              height: h,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              excludeFromSemantics: true,
            ),
          ),
        ],
      ),
    );

    final hint = reduced || _touched
        ? ''
        : 'drag me · double-click to send home';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Focus(
          onKeyEvent: _onKey,
          child: Semantics(
            image: true,
            label:
                'Origami flamingo made of folded paper. Drag it, or use the '
                'arrow keys to move it. Press Escape to send it home.',
            child: MouseRegion(
              cursor: _dragging
                  ? SystemMouseCursors.grabbing
                  : SystemMouseCursors.grab,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                onDoubleTap: _sendHome,
                child: AnimatedBuilder(
                  animation: _float,
                  child: bird,
                  builder: (context, child) {
                    final bob = (reduced || _dragging || _motion != _Motion.idle)
                        ? 0.0
                        : math.sin(_float.value * 2 * math.pi) * 5;
                    return Transform.translate(
                      offset: _pos + Offset(0, bob),
                      child: Transform.rotate(angle: _angle, child: child),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedOpacity(
          opacity: hint.isEmpty ? 0 : 1,
          duration: const Duration(milliseconds: 400),
          child: Text(
            hint.isEmpty ? ' ' : hint,
            style: AppTypogragh.mono(
              color: scheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
