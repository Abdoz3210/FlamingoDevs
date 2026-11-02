import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:flutter/material.dart';

/// The quiet button: a paper pill with a thin border. On hover the border
/// turns to the accent color and the pill lifts a little.
class GhostButton extends StatefulWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.compact = false,
  });

  final String label;
  final VoidCallback onPressed;

  /// A smaller pill for the header and footer.
  final bool compact;

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lit = _hovered || _focused;

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowHoverHighlight: (v) => setState(() => _hovered = v),
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed();
            return null;
          },
        ),
      },
      child: Semantics(
        button: true,
        label: widget.label,
        excludeSemantics: true,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.ease,
            transform: Matrix4.translationValues(0, lit ? -1 : 0, 0),
            padding: widget.compact
                ? const EdgeInsets.symmetric(horizontal: 14, vertical: 9)
                : const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(
                color: lit ? scheme.primary : scheme.outlineVariant,
              ),
            ),
            child: Text(
              widget.label,
              style: AppTypogragh.mono(
                color: scheme.onSurface,
                fontSize: widget.compact ? 12 : 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
