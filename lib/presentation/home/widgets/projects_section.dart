import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:bma_portfolio/data/repositories/project_repository.dart';
import 'package:bma_portfolio/presentation/home/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final _repo = ProjectRepository();

  List<ProjectModel> _projects = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final projects = await _repo.getAll();
    if (mounted) {
      setState(() {
        _projects = projects;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final colume = Responsive.gridColumns(context);
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: Responsive.sideMargin(context),
        vertical: isMobile ? 40 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PORTFOLIO',
                      style: AppTypogragh.mono(color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Selected Works',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              Text(
                'ALL PROJECTS →',
                style: AppTypogragh.mono(color: colors.primary),
              ),
            ],
          ),

          const SizedBox(height: 48),

          if (_projects.isEmpty)
            const SizedBox(height: 200)
          else
            AnimationLimiter(
              child: Wrap(
                spacing: 24,
                runSpacing: 32,
                children: List.generate(_projects.length, (index) {
                  final cardWidth =
                      (MediaQuery.sizeOf(context).width -
                          (Responsive.sideMargin(context) * 2) -
                          (24 * (colume - 1))) /
                      colume;

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 450),
                    child: FadeInAnimation(
                      child: SlideAnimation(
                        verticalOffset: 24,
                        child: SizedBox(
                          width: cardWidth,
                          // height: cardWidth * 2,
                          child: ProjectCard(project: _projects[index]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
