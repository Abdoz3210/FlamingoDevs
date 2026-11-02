import 'dart:math' as math;

import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/presentation/shared_widgets/paper_edge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Where a sheet sits inside the scroll content.
class SheetMetrics {
  const SheetMetrics(this.top, this.height);

  /// Offset of the sheet's top edge from the top of the scroll content.
  final double top;
  final double height;
}

/// Measures the sheets inside the scroll view so they can behave like sticky,
/// stacking sheets of paper: every sheet sticks to the top of the screen and
/// the next one slides over it.
///
/// A sheet whose content is taller than the screen scrolls until its bottom
/// edge meets the bottom of the screen, then sticks (the same rule as CSS
/// `position: sticky; top: min(0, 100vh - height)`).
class SheetLayout extends ChangeNotifier {
  SheetLayout({required this.controller, required this.keys});

  final ScrollController controller;

  /// One key per sheet, in order. Each key sits on the sheet's Transform, so
  /// measuring it gives the sheet's natural (untranslated) position.
  final List<GlobalKey> keys;

  int get count => keys.length;

  double get scroll => controller.hasClients ? controller.offset : 0.0;

  /// Ask every sheet to read its position again (after a resize, say).
  void remeasure() => notifyListeners();

  SheetMetrics? measureKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final ro = ctx.findRenderObject();
    if (ro is! RenderBox || !ro.attached || !ro.hasSize) return null;
    final viewport = RenderAbstractViewport.maybeOf(ro);
    if (viewport == null) return null;
    return SheetMetrics(
      viewport.getOffsetToReveal(ro, 0.0).offset,
      ro.size.height,
    );
  }

  SheetMetrics? measure(int i) => measureKey(keys[i]);

  /// Where sheet [i]'s top edge is on screen right now, or null before the
  /// first layout.
  double? screenTop(int i, double viewportHeight) {
    final m = measure(i);
    if (m == null) return null;
    final natural = m.top - scroll;
    if (i >= count - 1) return natural; // the last sheet scrolls normally
    final stick = math.min(0.0, viewportHeight - m.height);
    return math.max(natural, stick);
  }

  /// Index of the sheet that currently owns the screen.
  int activeIndex(double viewportHeight) {
    var act = 0;
    for (var i = 0; i < count; i++) {
      final t = screenTop(i, viewportHeight);
      if (t != null && t <= viewportHeight * 0.5) act = i;
    }
    return act;
  }
}

/// One sheet of paper in the stack.
///
/// Put every sheet in a Column inside a SingleChildScrollView. The sheet keeps
/// its natural place in the layout; a transform makes it stick, and the sheet
/// above it scales, tilts and dims while this one slides over.
class SheetSlot extends StatelessWidget {
  const SheetSlot({
    super.key,
    required this.index,
    required this.layout,
    required this.background,
    required this.child,
    this.theme,
    this.tilt = 0,
  });

  final int index;
  final SheetLayout layout;
  final Color background;
  final Widget child;

  /// Overrides the theme for this sheet (the contact sheet uses the night
  /// palette in both modes).
  final ThemeData? theme;

  /// Degrees the sheet tilts by when it is fully covered.
  final double tilt;

  @override
  Widget build(BuildContext context) {
    final vh = MediaQuery.sizeOf(context).height;
    final still = MediaQuery.disableAnimationsOf(context);
    final sheetTheme = theme ?? Theme.of(context);
    final scheme = sheetTheme.colorScheme;
    final shadow =
        (sheetTheme.extension<OrigamiColors>() ?? OrigamiColors.of(context))
            .shadow;
    final body = theme == null ? child : Theme(data: theme!, child: child);
    final zig = index > 0 ? const ZigzagTopClipper() : null;

    return AnimatedBuilder(
      animation: Listenable.merge([layout.controller, layout]),
      child: body,
      builder: (context, content) {
        final s = layout.scroll;
        final m = layout.measure(index);
        var dy = 0.0;
        var cover = 0.0;
        var screenTop = vh; // unknown before the first layout: below the fold

        if (m != null) {
          final natural = m.top - s;
          screenTop = natural;
          if (index < layout.count - 1) {
            final stick = math.min(0.0, vh - m.height);
            dy = math.max(0.0, stick - natural);
            screenTop = natural + dy;
            if (!still) {
              final next = layout.screenTop(index + 1, vh);
              if (next != null) cover = clampUnit((vh - next) / vh);
            }
          }
        }

        // The accent line along this sheet's top edge draws as it rises.
        final edge = still ? 1.0 : clampUnit(1 - screenTop / (vh * 0.92));
        final scale = 1 - 0.06 * cover;
        final angle = tilt * cover * math.pi / 180;
        final Matrix4 matrix = Matrix4.translationValues(0, dy, 0)
          ..multiply(Matrix4.diagonal3Values(scale, scale, 1))
          ..multiply(Matrix4.rotationZ(angle));

        return Transform(
          key: layout.keys[index],
          alignment: Alignment.center,
          transform: matrix,
          // A fully covered sheet stops painting but keeps its size: Offstage
          // would collapse it to zero height and shift every sheet below.
          child: Visibility(
            visible: cover < 0.999,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            child: SizedBox(
              width: double.infinity,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: vh),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (index > 0)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: -26,
                        height: 44,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [shadow, shadow, const Color(0x00000000)],
                                stops: const [0, 18 / 44, 1],
                              ),
                            ),
                          ),
                        ),
                      ),
                    Positioned.fill(
                      child: zig == null
                          ? ColoredBox(color: background)
                          : ClipPath(
                              clipper: zig,
                              child: ColoredBox(color: background),
                            ),
                    ),
                    if (index > 0)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: -kZigPad,
                        height: kZigLineHeight,
                        child: ZigzagLine(
                          progress: edge,
                          baseColor: scheme.outlineVariant,
                          accentColor: scheme.primary,
                          markerOpacity: (edge > 0.01 && edge < 0.985) ? 1 : 0,
                        ),
                      ),
                    content!,
                    if (cover > 0)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: zig == null
                              ? ColoredBox(
                                  color: AppColors.dim.withValues(
                                    alpha: cover * 0.34,
                                  ),
                                )
                              : ClipPath(
                                  clipper: zig,
                                  child: ColoredBox(
                                    color: AppColors.dim.withValues(
                                      alpha: cover * 0.34,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
