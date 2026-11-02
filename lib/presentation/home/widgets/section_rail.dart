import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/core/utils/scroll_service.dart';
import 'package:bma_portfolio/presentation/shared_widgets/sheet_stack.dart';
import 'package:flutter/material.dart';

/// A thin rail of triangles on the right edge, one per sheet. The active sheet
/// shows a larger pointer and its name. Hidden on phones and over the footer.
class SectionRail extends StatelessWidget {
  const SectionRail({
    super.key,
    required this.layout,
    required this.scrollService,
    required this.footerKey,
  });

  final SheetLayout layout;
  final ScrollService scrollService;
  final GlobalKey footerKey;

  static const _items = [
    (HomeSection.hero, 'Home'),
    (HomeSection.about, 'About'),
    (HomeSection.services, 'Services'),
    (HomeSection.projects, 'Projects'),
    (HomeSection.contact, 'Contact'),
  ];

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final vh = MediaQuery.sizeOf(context).height;

    return AnimatedBuilder(
      animation: Listenable.merge([layout.controller, layout]),
      builder: (context, _) {
        final active = layout.activeIndex(vh);
        final foot = layout.measureKey(footerKey);
        final overFooter =
            foot != null && (foot.top - layout.scroll) < vh * 0.55;

        return Positioned(
          right: 14,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: overFooter,
            child: AnimatedOpacity(
              opacity: overFooter ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Positioned(
                      right: 6,
                      top: 8,
                      bottom: 8,
                      child: Container(
                        width: 1,
                        color: scheme.primary.withValues(alpha: 0.35),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (var i = 0; i < _items.length; i++)
                          _RailItem(
                            label: _items[i].$2,
                            active: i == active,
                            onTap: () => scrollService.scrollTo(_items[i].$1),
                          ),
                      ],
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

class _RailItem extends StatefulWidget {
  const _RailItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_RailItem> createState() => _RailItemState();
}

class _RailItemState extends State<_RailItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final showLabel = widget.active || _hovered;

    return Semantics(
      button: true,
      label: 'Go to ${widget.label}',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: SizedBox(
            height: 34,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: showLabel ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Text(
                      widget.label,
                      style: AppTypogragh.mono(
                        color: scheme.onSurface,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CustomPaint(
                    painter: _PointerPainter(
                      active: widget.active,
                      color: scheme.primary,
                    ),
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

class _PointerPainter extends CustomPainter {
  const _PointerPainter({required this.active, required this.color});

  final bool active;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    if (active) {
      // Larger, pointing down: "you are here".
      path
        ..moveTo(0, 1)
        ..lineTo(w, 1)
        ..lineTo(w / 2, h)
        ..close();
      canvas.drawPath(path, Paint()..color = AppColors.markPink);
    } else {
      path
        ..moveTo(w / 2 - 4, h / 2 + 3)
        ..lineTo(w / 2 + 4, h / 2 + 3)
        ..lineTo(w / 2, h / 2 - 4)
        ..close();
      canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.55));
    }
  }

  @override
  bool shouldRepaint(covariant _PointerPainter old) =>
      old.active != active || old.color != color;
}
