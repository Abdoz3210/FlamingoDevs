import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/core/utils/scroll_service.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:bma_portfolio/data/repositories/project_repository.dart';
import 'package:bma_portfolio/presentation/home/widgets/app_footer.dart';
import 'package:bma_portfolio/presentation/project_details/widget/next_project_link.dart';
import 'package:bma_portfolio/presentation/project_details/widget/phone_mockups.dart';
import 'package:bma_portfolio/presentation/project_details/widget/project_description.dart';
import 'package:bma_portfolio/presentation/project_details/widget/project_gallery.dart';
import 'package:bma_portfolio/presentation/project_details/widget/project_hero.dart';
import 'package:bma_portfolio/presentation/shared_widgets/app_header.dart';
import 'package:bma_portfolio/presentation/shared_widgets/reveal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String slug;
  const ProjectDetailsPage({super.key, required this.slug});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  final _repo = ProjectRepository();
  final _scrollService = ScrollService();
  final _scroll = ScrollController();
  ProjectModel? _project;
  ProjectModel? _next;
  int _index = 0;
  int _total = 0;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant ProjectDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slug != widget.slug) {
      if (_scroll.hasClients) _scroll.jumpTo(0);
      _load();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final all = await _repo.getAll();
    // "Coming Soon" entries are not projects: leave them out of the order.
    final real = all.where((p) => !p.isPlaceholder).toList();
    final i = real.indexWhere((p) => p.slug == widget.slug);

    if (!mounted) return;
    if (i < 0) {
      setState(() => _notFound = true);
      return;
    }
    setState(() {
      _project = real[i];
      _next = real.length > 1 ? real[(i + 1) % real.length] : null;
      _index = i;
      _total = real.length;
      _notFound = false;
    });
  }

  void _backToTop() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_notFound) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Project not found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.goNamed(RouterNames.home),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      );
    }
    if (_project == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final project = _project!;
    final scheme = Theme.of(context).colorScheme;
    final side = Responsive.sideMargin(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scroll,
            child: Column(
              children: [
                ProjectHero(project: project),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(side, 72, side, 8),
                          child: Reveal(
                            child: Text(
                              'SCREENS',
                              style: AppTypogragh.mono(
                                color: scheme.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        PhoneMockups(project: project, scroll: _scroll),
                        ProjectDescription(project: project),
                        ProjectGallery(project: project),
                        const SizedBox(height: 48),
                        if (_next != null) NextProjectLink(next: _next!),
                      ],
                    ),
                  ),
                ),
                AppFooter(
                  onNavigate: (section) =>
                      context.goNamed(RouterNames.home, extra: section),
                  onBackToTop: _backToTop,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(
              scrollservice: _scrollService,
              isProjectPage: true,
              activeSection: HomeSection.projects,
              controller: _scroll,
              trailingLabel: '${_index + 1} / $_total',
            ),
          ),
        ],
      ),
    );
  }
}
