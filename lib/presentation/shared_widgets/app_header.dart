import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/core/utils/scroll_service.dart';
import 'package:bma_portfolio/presentation/shared_widgets/app_logo.dart';
import 'package:bma_portfolio/presentation/shared_widgets/ghost_button.dart';
import 'package:bma_portfolio/presentation/shared_widgets/paper_edge.dart';
import 'package:bma_portfolio/presentation/shared_widgets/sheet_stack.dart';
import 'package:bma_portfolio/presentation/shared_widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The fixed header. Its bottom edge is the zigzag scroll-progress line: the
/// accent stroke draws as the page scrolls and the origami mark rides its tip.
class AppHeader extends StatefulWidget {
  final ScrollService scrollservice;
  final HomeSection? activeSection;
  final bool isProjectPage;

  /// Drives the progress line (page scroll position).
  final ScrollController? controller;

  /// When set, the nav highlight and the "02 / 05" readout follow the sheet
  /// that currently owns the screen.
  final SheetLayout? layout;

  /// Text on the right of the nav for pages without sheets, e.g. "2 / 4".
  final String? trailingLabel;

  const AppHeader({
    super.key,
    required this.scrollservice,
    this.activeSection,
    this.isProjectPage = false,
    this.controller,
    this.layout,
    this.trailingLabel,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  bool _menuOpen = false;

  static const _navItems = [
    (HomeSection.hero, 'Home'),
    (HomeSection.about, 'About'),
    (HomeSection.services, 'Services'),
    (HomeSection.projects, 'Projects'),
    (HomeSection.contact, 'Contact'),
  ];

  void _goto(HomeSection section) {
    setState(() => _menuOpen = false);
    if (widget.isProjectPage) {
      context.goNamed(RouterNames.home, extra: section);
    } else {
      widget.scrollservice.scrollTo(section);
    }
  }

  double _progress() {
    final c = widget.controller;
    if (c == null || !c.hasClients) return 0;
    final max = c.position.maxScrollExtent;
    if (max <= 0) return 0;
    return clampUnit(c.offset / max);
  }

  HomeSection? _active(double vh) {
    final layout = widget.layout;
    if (layout == null) return widget.activeSection;
    final i = layout.activeIndex(vh);
    return _navItems[i < _navItems.length ? i : 0].$1;
  }

  String _readout(double vh) {
    final layout = widget.layout;
    if (layout == null) return widget.trailingLabel ?? '';
    final i = layout.activeIndex(vh);
    final idx = i < _navItems.length ? i : 0;
    return '0${idx + 1} / 0${_navItems.length} · ${_navItems[idx].$2}';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final scheme = Theme.of(context).colorScheme;
    final vh = MediaQuery.sizeOf(context).height;
    final listenable = Listenable.merge([widget.controller, widget.layout]);

    final brand = GestureDetector(
      onTap: () {
        if (widget.isProjectPage) {
          context.goNamed(RouterNames.home);
        } else {
          widget.scrollservice.scrollTo(HomeSection.hero);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AppLogo(size: isMobile ? 24 : 28),
      ),
    );

    final bar = Container(
      height: 56,
      color: scheme.surface.withValues(alpha: 0.92),
      padding: EdgeInsets.symmetric(horizontal: Responsive.sideMargin(context)),
      child: Row(
        children: [
          brand,
          const Spacer(),
          if (!isMobile)
            AnimatedBuilder(
              animation: listenable,
              builder: (context, _) {
                final active = _active(vh);
                final readout = _readout(vh);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final item in _navItems)
                      _NavLink(
                        label: item.$2,
                        isActive: active == item.$1,
                        onTap: () => _goto(item.$1),
                      ),
                    if (readout.isNotEmpty) ...[
                      const SizedBox(width: 18),
                      SizedBox(
                        width: 150,
                        child: Text(
                          readout,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypogragh.mono(
                            color: scheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          const SizedBox(width: 8),
          const ThemeToggleButton(),
          if (!isMobile) ...[
            const SizedBox(width: 12),
            GhostButton(
              compact: true,
              label: "Let's talk",
              onPressed: () => _goto(HomeSection.contact),
            ),
          ] else
            IconButton(
              tooltip: _menuOpen ? 'Close menu' : 'Open menu',
              onPressed: () => setState(() => _menuOpen = !_menuOpen),
              icon: Icon(
                _menuOpen ? Icons.close : Icons.menu,
                color: scheme.onSurface,
              ),
            ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            bar,
            Positioned(
              left: 0,
              right: 0,
              bottom: -kZigLineHeight / 2,
              height: kZigLineHeight,
              child: AnimatedBuilder(
                animation: listenable,
                builder: (context, _) => ZigzagLine(progress: _progress()),
              ),
            ),
          ],
        ),
        if (isMobile)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: _menuOpen
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final item in _navItems)
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _goto(item.$1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              child: Text(
                                item.$2,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final highlighted = widget.isActive || _hovered;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTypogragh.mono(
                  color: highlighted ? scheme.primary : scheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                height: 2,
                width: highlighted ? 16 : 0,
                color: scheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
