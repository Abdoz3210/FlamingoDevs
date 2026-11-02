import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:flutter/material.dart';

class GhostButton extends StatefulWidget {
  const GhostButton({super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: _hovered ? scheme.primary : scheme.outline,
            ),
          ),
          child: Text(
            widget.label,
            style: AppTypogragh.mono(
              color: _hovered ? scheme.primary : scheme.onSurface,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
