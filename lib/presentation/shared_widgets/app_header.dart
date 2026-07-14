import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/core/utils/scroll_service.dart';
import 'package:bma_portfolio/presentation/shared_widgets/app_logo.dart';
import 'package:bma_portfolio/presentation/shared_widgets/ghost_button.dart';
import 'package:bma_portfolio/presentation/shared_widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends StatefulWidget {
  final ScrollService scrollservice;
  final HomeSection? activeSection;
  final bool isProjectPage;

  const AppHeader({
    super.key,
    required this.scrollservice,
    this.activeSection,
    this.isProjectPage = false,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  bool _menuOpen = false;

  static const _navItems = [
    (HomeSection.about, 'About'),
    (HomeSection.services, 'Services'),
    (HomeSection.projects, 'Projects'),
    (HomeSection.footer, 'Contact'),
  ];

  void _goto(HomeSection section) {
    setState(() => _menuOpen = false);
    if (widget.isProjectPage) {
      context.goNamed(RouterNames.home, extra: section);
    } else {
      widget.scrollservice.scrollTo(section);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.sideMargin(context),
            vertical: 18,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.isProjectPage) {
                    context.goNamed(RouterNames.home);
                  } else {
                    widget.scrollservice.scrollTo(HomeSection.hero);
                  }
                },
                child: const AppLogo(size: 82),
              ),
              Spacer(),
              if (!isMobile) ...[
                for (final item in _navItems)
                  _NavLink(
                    label: item.$2,
                    isActive: widget.activeSection == item.$1,
                    onTap: () => _goto(item.$1),
                  ),
                const SizedBox(width: 8),
                const ThemeToggleButton(),
                const SizedBox(width: 12),
                GhostButton(
                  label: "let's TALK",
                  onPressed: () => _goto(HomeSection.contact),
                ),
              ] else ...[
                const ThemeToggleButton(),
                IconButton(
                  onPressed: () => setState(() => _menuOpen = !_menuOpen),
                  icon: Icon(
                    _menuOpen ? Icons.close : Icons.menu,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ],
          ),
        ),

        if (isMobile)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: _menuOpen
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final item in _navItems)
                          GestureDetector(
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
  State<_NavLink> createState() => __NavLinkState();
}

class __NavLinkState extends State<_NavLink> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final highligted = widget.isActive || _hovered;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTypogragh.mono(
                  color: highligted ? colors.primary : colors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                height: 2,
                width: highligted ? 16 : 0,
                color: colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
