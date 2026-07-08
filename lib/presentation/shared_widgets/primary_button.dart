import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/themes/app_gradient.dart';
import 'package:flutter/material.dart';

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

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final labelColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkSurfaceContainerLowest
        : AppColors.lightSurfaceContainerLowest;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() {
        _hovered = true;
      }),
      onExit: (_) => setState(() {
        _hovered = false;
      }),

      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.loading ? null : widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            decoration: BoxDecoration(
              gradient: AppGradient.of(context),
              borderRadius: BorderRadius.circular(9999),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppGradient.of(
                          context,
                        ).colors.last.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: widget.loading
                ? SizedBox(
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
                    ).copyWith(fontSize: 14),
                  ),
          ),
        ),
      ),
    );
  }
}
