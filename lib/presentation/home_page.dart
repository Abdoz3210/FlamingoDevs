import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/presentation/shared_widgets/animated_section_wrapper.dart';
import 'package:bma_portfolio/presentation/shared_widgets/app_header.dart';
import 'package:flutter/material.dart';
import '../../core/utils/scroll_service.dart';

class HomePage extends StatefulWidget {
  final HomeSection? initialSection;

  const HomePage({super.key, this.initialSection});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollService = ScrollService();
  final _scrollController = ScrollController();
  HomeSection? _activeSection;
  bool _headerSolid = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    if (widget.initialSection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollService.scrollTo(widget.initialSection!);
      });
    }
  }

  void _onScroll() {
    final solid = _scrollController.offset > 80;
    if (solid != _headerSolid) {
      setState(() => _headerSolid = solid);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                KeyedSubtree(
                  key: _scrollService.keyFor(HomeSection.hero),
                  child: _buildPlaceholderSection('Hero Section', 600),
                ),

                KeyedSubtree(
                  key: _scrollService.keyFor(HomeSection.about),
                  child: AnimatedSectionWrapper(
                    child: _buildPlaceholderSection('About Section', 400),
                  ),
                ),
                KeyedSubtree(
                  key: _scrollService.keyFor(HomeSection.service),
                  child: AnimatedSectionWrapper(
                    child: _buildPlaceholderSection('Services Section', 500),
                  ),
                ),
                KeyedSubtree(
                  key: _scrollService.keyFor(HomeSection.projects),
                  child: AnimatedSectionWrapper(
                    child: _buildPlaceholderSection('Projects Section', 600),
                  ),
                ),
                KeyedSubtree(
                  key: _scrollService.keyFor(HomeSection.contact),
                  child: AnimatedSectionWrapper(
                    child: _buildPlaceholderSection('Contact Section', 400),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: _headerSolid
                    ? colors.surface.withValues(alpha: 0.9)
                    : colors.surface.withValues(alpha: 0.0),
                boxShadow: _headerSolid
                    ? [
                        BoxShadow(
                          color: AppColors.darkSurfaceContainerLowest
                              .withValues(alpha: 0.09),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: AppHeader(
                scrollservice: ScrollService(),
                activeSection: _activeSection,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderSection(String label, double height) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: colors.surfaceContainerLow,
      child: Center(
        child: Text(label, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
