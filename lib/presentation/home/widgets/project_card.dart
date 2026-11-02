import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:bma_portfolio/presentation/home/widgets/project_cover.dart';
import 'package:bma_portfolio/presentation/shared_widgets/origami_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Height of the folded corner on a project card.
const double _kCardFold = 28;

/// A project on the home page: a paper card with cover art, a phone peeking
/// out of the bottom, the title and an "Open" cue. Hover or focus it and the
/// card lifts, the folds drift and the phone rises. Tapping unfolds the cover
/// into the project page.
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
    final palette = ProjectPalette.forSlug(p.slug);
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
        excludeSemantics: true,
        child: GestureDetector(
          onTap: _open,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: kFoldCurve,
            transform: Matrix4.translationValues(0, lit ? -5 : 0, 0),
            child: FoldedCard(
              fold: _kCardFold,
              padding: EdgeInsets.zero,
              background: scheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ProjectCover(project: p, aspectRatio: null, lit: lit),
                        IgnorePointer(
                          child: ProjectMiniPhone(palette: palette, lit: lit),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                p.category,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypogragh.mono(
                                  color: scheme.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease,
                          transform: Matrix4.translationValues(
                            lit ? 4 : 0,
                            0,
                            0,
                          ),
                          child: Text(
                            'Open →',
                            style: AppTypogragh.mono(
                              color: scheme.primary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Inert card for the "Coming Soon" entries in projects.json: a dashed paper
/// outline with nothing inside yet.
class ComingSoonCard extends StatelessWidget {
  const ComingSoonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FoldedCard(
      fold: _kCardFold,
      padding: EdgeInsets.zero,
      background: Colors.transparent,
      dashed: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ColoredBox(
              color: scheme.surfaceContainerLow,
              child: Center(
                child: Text(
                  'Coming soon',
                  style: AppTypogragh.mono(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next project',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  'In progress',
                  style: AppTypogragh.mono(
                    color: scheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
