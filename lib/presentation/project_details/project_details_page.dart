import 'dart:convert';

import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:bma_portfolio/core/utils/scroll_service.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:bma_portfolio/data/repositories/project_repository.dart';
import 'package:bma_portfolio/presentation/home/widgets/app_footer.dart';
import 'package:bma_portfolio/presentation/project_details/widget/project_description.dart';
import 'package:bma_portfolio/presentation/project_details/widget/project_hero.dart';
import 'package:bma_portfolio/presentation/shared_widgets/app_header.dart';
import 'package:flutter/foundation.dart';
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
  ProjectModel? _project;
  ProjectModel? _next;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void didUpdateWidget(covariant ProjectDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.slug != widget.slug) _load();
  }

  Future<void> _load() async {
    final project = await _repo.getBySlug(widget.slug);

    if (project == null) {
      if (mounted) setState(() => _notFound = true);
      return;
    }
    final next = project.nextProjectSlug != null
        ? await _repo.getBySlug(project.nextProjectSlug!)
        : null;
    if (mounted) {
      setState(() {
        _project = project;
        _next = next;
        _notFound = false;
      });
    }
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
                'Project Not found,',
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
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ProjectHero(project: _project!),
                const SizedBox(height: 40),
                ProjectDescription(project: _project!),
                AppFooter(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,

            child: Container(
              color: colors.surface.withValues(alpha: 0.92),
              child: AppHeader(
                scrollservice: _scrollService,
                isProjectPage: true,
                activeSection: HomeSection.projects,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
