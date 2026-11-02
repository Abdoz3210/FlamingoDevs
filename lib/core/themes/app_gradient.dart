import 'package:flutter/material.dart';

/// Flamingo gradients.
/// [of] fills buttons and icon tiles (dark ink text sits on it).
/// [textOf] is a deeper pair for gradient headline words, so large text still
/// reaches 3:1 against the paper background in light mode.
class AppGradient {
  AppGradient._();

  static bool _isDark(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark;

  static LinearGradient of(BuildContext context) => LinearGradient(
    colors: _isDark(context)
        ? const [Color(0xFFFF6B9D), Color(0xFFFFB38A)]
        : const [Color(0xFFFF5C8A), Color(0xFFFF9E7A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient textOf(BuildContext context) => LinearGradient(
    colors: _isDark(context)
        ? const [Color(0xFFFF6B9D), Color(0xFFFFB38A)]
        : const [Color(0xFFD81B60), Color(0xFFE4502F)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Paints [child] with the text gradient, only where the child has pixels.
  static Widget text({
    required BuildContext context,
    required Widget child,
    Key? key,
  }) => ShaderMask(
    key: key,
    blendMode: BlendMode.srcIn,
    shaderCallback: (bounds) => textOf(context).createShader(bounds),
    child: child,
  );
}
