import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:bma_portfolio/data/repositories/project_repository.dart';
import 'package:bma_portfolio/presentation/home/widgets/project_card.dart';
import 'package:bma_portfolio/presentation/shared_widgets/reveal.dart';
import 'package:bma_portfolio/presentation/shared_widgets/section_title.dart';
import 'package:flutter/material.dart';

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
    if (mounted) setState(() => _projects = projects);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final columns = Responsive.gridColumns(context);
    final vh = MediaQuery.sizeOf(context).height;
    const gap = 24.0;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: vh),
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Responsive.sideMargin(context),
            isMobile ? 88 : 112,
            Responsive.sideMargin(context),
            isMobile ? 56 : 96,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                eyebrow: 'Selected work',
                title: 'Open a project to',
                accent: 'unfold it',
              ),
              const SizedBox(height: 48),
              if (_projects.isEmpty)
                const SizedBox(height: 200)
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width =
                        (constraints.maxWidth - gap * (columns - 1)) / columns;
                    return Wrap(
                      spacing: gap,
                      runSpacing: 40,
                      children: [
                        for (var i = 0; i < _projects.length; i++)
                          SizedBox(
                            width: width,
                            child: Reveal(
                              delay: Duration(milliseconds: 250 + i * 80),
                              child: _projects[i].isPlaceholder
                                  ? const ComingSoonCard()
                                  : ProjectCard(project: _projects[i]),
                            ),
                          ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
