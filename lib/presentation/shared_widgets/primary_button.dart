import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/themes/app_gradient.dart';
import 'package:flutter/material.dart';

/// The main call-to-action: a gradient pill that lifts a little and lets a
/// band of light sweep across it when you hover or focus it.
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  bool _hovered = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null && !widget.loading;
  bool get _lit => _enabled && (_hovered || _focused);

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  void _setHover(bool v) {
    if (v == _hovered) return;
    setState(() => _hovered = v);
    if (v) _playShimmer();
  }

  void _setFocus(bool v) {
    if (v == _focused) return;
    setState(() => _focused = v);
    if (v) _playShimmer();
  }

  void _playShimmer() {
    if (!_enabled || MediaQuery.disableAnimationsOf(context)) return;
    _shimmer.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    const labelColor = AppColors.onGradient;
    final scheme = Theme.of(context).colorScheme;

    return FocusableActionDetector(
      enabled: _enabled,
      mouseCursor: _enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onShowHoverHighlight: _setHover,
      onShowFocusHighlight: _setFocus,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          },
        ),
      },
      child: Semantics(
        button: true,
        enabled: _enabled,
        label: widget.label,
        excludeSemantics: true,
        child: GestureDetector(
          onTap: _enabled ? widget.onPressed : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.ease,
            transform: Matrix4.translationValues(0, _lit ? -2 : 0, 0),
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            decoration: BoxDecoration(
              gradient: AppGradient.of(context),
              borderRadius: BorderRadius.circular(9999),
            ),
            // A focused button also gets a ring, so keyboard users can see it.
            // It is drawn on top, so it never changes the button's size.
            foregroundDecoration: _focused
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: scheme.onSurface, width: 2),
                  )
                : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _ShimmerPainter(_shimmer)),
                  ),
                ),
                widget.loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(labelColor),
                        ),
                      )
                    : Text(
                        widget.label,
                        style: AppTypogragh.mono(
                          color: labelColor,
                          fontSize: 13,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A diagonal band of light that sweeps across the button once. It moves the
/// same way as the one in the design: a 115 degree highlight on a layer 2.2x
/// as wide as the button, slid from one side to the other with an "ease" curve.
class _ShimmerPainter extends CustomPainter {
  _ShimmerPainter(this.t) : super(repaint: t);

  final Animation<double> t;

  static const _clear = Color(0x00FFFFFF);
  static const _glow = Color(0x8CFFFFFF); // white at 55%

  @override
  void paint(Canvas canvas, Size size) {
    final v = t.value;
    if (v <= 0 || v >= 1) return;

    final w = size.width;
    final h = size.height;
    final layerW = w * 2.2;
    final fromX = w * 1.8;
    final toX = -w * 3.0;
    final left = fromX + (toX - fromX) * Curves.ease.transform(v);

    const angle = 115 * math.pi / 180;
    final dir = Offset(math.sin(angle), -math.cos(angle));
    final length = (layerW * dir.dx).abs() + (h * dir.dy).abs();
    final center = Offset(left + layerW / 2, h / 2);

    final shader = ui.Gradient.linear(
      center - dir * (length / 2),
      center + dir * (length / 2),
      const [_clear, _glow, _clear],
      const [0.30, 0.48, 0.66],
    );
    canvas.drawRect(Rect.fromLTWH(left, 0, layerW, h), Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter old) => old.t != t;
}
