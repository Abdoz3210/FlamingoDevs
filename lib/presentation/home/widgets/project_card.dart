import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:bma_portfolio/presentation/home/widgets/project_cover.dart';
import 'package:bma_portfolio/presentation/shared_widgets/origami_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A project on the home page: its cover with a folded corner, the title and
/// an "Open" cue. Tapping unfolds the cover into the project page.
class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;
  bool _focused = false;

  void _open() {
    context.pushNamed(
      RouterNames.projectDetails,
      pathParameters: {'slug': widget.project.slug},
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final p = widget.project;
    final lit = _hovered || _focused;

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowHoverHighlight: (v) => setState(() => _hovered = v),
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _open();
            return null;
          },
        ),
      },
      child: Semantics(
        button: true,
        label: 'Open ${p.title}',
        child: GestureDetector(
          onTap: _open,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(0, lit ? -6 : 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProjectCover(project: p),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.category.toUpperCase(),
                            style: AppTypogragh.mono(
                              color: scheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 220),
                      offset: Offset(lit ? 0.15 : 0, 0),
                      child: Text(
                        'OPEN →',
                        style: AppTypogragh.mono(
                          color: scheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Inert card for the "Coming Soon" entries in projects.json.
class ComingSoonCard extends StatelessWidget {
  const ComingSoonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: FoldedCard(
            fold: 28,
            padding: EdgeInsets.zero,
            background: scheme.surfaceContainerLow,
            child: Center(
              child: Text(
                'COMING SOON',
                style: AppTypogragh.mono(
                  color: scheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Next project', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          'IN PROGRESS',
          style: AppTypogragh.mono(color: scheme.onSurfaceVariant, fontSize: 11),
        ),
      ],
    );
  }
}
