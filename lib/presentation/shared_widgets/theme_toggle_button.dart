import 'package:bma_portfolio/core/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    final color = Theme.of(context).colorScheme.onSurface;

    return IconButton(
      onPressed: () => context.read<ThemeProvider>().toggle(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => RotationTransition(
          turns: animation,
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Icon(
          provider.isDark
              ? Icons.dark_mode_outlined
              : Icons.light_mode_outlined,
          key: ValueKey(provider.isDark),
          color: color,
          size: 20,
        ),
      ),
    );
  }
}
