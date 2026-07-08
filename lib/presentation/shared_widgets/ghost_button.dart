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
  bool _hoverd = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoverd = true),
      onExit: (_) => setState(() => _hoverd = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: _hoverd
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.outline,
            ),
          ),

          child: Text(
            widget.label,
            style: AppTypogragh.origami(
              color: Theme.of(context).colorScheme.onSurface,
            ).copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
