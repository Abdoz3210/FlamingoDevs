import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/core/themes/night_theme.dart';
import 'package:bma_portfolio/presentation/home/widgets/about_section.dart';
import 'package:bma_portfolio/presentation/home/widgets/app_footer.dart';
import 'package:bma_portfolio/presentation/home/widgets/contact_section.dart';
import 'package:bma_portfolio/presentation/home/widgets/hero_section.dart';
import 'package:bma_portfolio/presentation/home/widgets/projects_section.dart';
import 'package:bma_portfolio/presentation/home/widgets/section_rail.dart';
import 'package:bma_portfolio/presentation/home/widgets/service_section.dart';
import 'package:bma_portfolio/presentation/shared_widgets/app_header.dart';
import 'package:bma_portfolio/presentation/shared_widgets/sheet_stack.dart';
import 'package:flutter/material.dart';
import 'package:bma_portfolio/core/utils/scroll_service.dart';

/// The home page: five sheets of paper that stack as you scroll, then the
/// footer. Each sheet sticks to the screen while the next one slides over it.
class HomePage extends StatefulWidget {
  final HomeSection? initialSection;

  const HomePage({super.key, this.initialSection});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollService = ScrollService();
  final _scrollController = ScrollController();
  late final SheetLayout _layout;

  /// Degrees each sheet tilts by when the next one has fully covered it.
  static const _tilts = [-0.7, 0.6, -0.5, 0.7, 0.0];

  @override
  void initState() {
    super.initState();
    _scrollService.controller = _scrollController;
    _layout = SheetLayout(
      controller: _scrollController,
      keys: [
        for (final s in HomeSection.values.take(5)) _scrollService.keyFor(s),
      ],
    );

    if (widget.initialSection != null) _scrollToInitial();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSection != null &&
        widget.initialSection != oldWidget.initialSection) {
      _scrollToInitial();
    }
  }

  void _scrollToInitial() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.initialSection != null) {
        _scrollService.scrollTo(widget.initialSection!);
      }
    });
  }

  void _backToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _layout.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final origami = OrigamiColors.of(context);

    // After any rebuild (a resize, a theme switch) the sheets read their
    // positions again once layout has settled.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _layout.remeasure();
    });

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SheetSlot(
                  index: 0,
                  layout: _layout,
                  background: scheme.surface,
                  tilt: _tilts[0],
                  child: HeroSection(scrollService: _scrollService),
                ),
                SheetSlot(
                  index: 1,
                  layout: _layout,
                  background: scheme.surfaceContainerLow,
                  tilt: _tilts[1],
                  child: const AboutSection(),
                ),
                SheetSlot(
                  index: 2,
                  layout: _layout,
                  background: origami.sheetAlt,
                  tilt: _tilts[2],
                  child: const ServicesSection(),
                ),
                SheetSlot(
                  index: 3,
                  layout: _layout,
                  background: scheme.surface,
                  tilt: _tilts[3],
                  child: const ProjectsSection(),
                ),
                SheetSlot(
                  index: 4,
                  layout: _layout,
                  background: origami.footer,
                  theme: nightTheme,
                  tilt: _tilts[4],
                  child: const ContactSection(),
                ),
                SizedBox(
                  key: _scrollService.keyFor(HomeSection.footer),
                  width: double.infinity,
                  child: AppFooter(
                    onNavigate: _scrollService.scrollTo,
                    onBackToTop: _backToTop,
                  ),
                ),
              ],
            ),
          ),
          SectionRail(
            layout: _layout,
            scrollService: _scrollService,
            footerKey: _scrollService.keyFor(HomeSection.footer),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(
              scrollservice: _scrollService,
              controller: _scrollController,
              layout: _layout,
            ),
          ),
        ],
      ),
    );
  }
}
