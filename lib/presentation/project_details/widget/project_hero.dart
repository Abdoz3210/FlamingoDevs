import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:bma_portfolio/presentation/home/widgets/project_cover.dart';
import 'package:bma_portfolio/presentation/shared_widgets/primary_button.dart';
import 'package:bma_portfolio/presentation/shared_widgets/reveal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// Top of the project page: the cover band the card unfolded into, then the
/// title, tagline and a small facts row.
class ProjectHero extends StatelessWidget {
  final ProjectModel project;
  const ProjectHero({super.key, required this.project});

  Future<void> _openGithub() async {
    final uri = Uri.parse(project.githubUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }

  void _back(BuildContext context) {
    // Pop so the cover folds back into its card; fall back to home when the
    // page was opened directly from a link.
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouterNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final scheme = Theme.of(context).colorScheme;
    final side = Responsive.sideMargin(context);
    final bandHeight = isMobile ? 240.0 : 360.0;
    final titleStyle = isMobile
        ? AppTypogragh.displayMobile(color: scheme.onSurface)
        : Theme.of(context).textTheme.displayMedium!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The band: same Hero tag as the card cover on the home page.
        SizedBox(
          height: bandHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ProjectCover(project: project, cut: 44, aspectRatio: null),
              // Soft scrim so the header stays readable over the image.
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        AppColors.dim.withValues(alpha: 0.35),
                        AppColors.dim.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Padding(
              padding: EdgeInsets.fromLTRB(side, 36, side, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BackLink(onTap: () => _back(context)),
                  const SizedBox(height: 28),
                  Reveal(
                    child: Text(
                      project.category.toUpperCase(),
                      style: AppTypogragh.mono(
                        color: scheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FoldHeadline(lead: project.title, style: titleStyle),
                  const SizedBox(height: 20),
                  Reveal(
                    delay: const Duration(milliseconds: 450),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Text(
                        project.tagline,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Reveal(
                    delay: const Duration(milliseconds: 600),
                    child: _Facts(project: project),
                  ),
                  if (project.githubUrl.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Reveal(
                      delay: const Duration(milliseconds: 700),
                      child: PrimaryButton(
                        label: 'View on GitHub ↗',
                        onPressed: _openGithub,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BackLink extends StatefulWidget {
  const _BackLink({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_BackLink> createState() => _BackLinkState();
}

class _BackLinkState extends State<_BackLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _hovered ? scheme.primary : scheme.onSurfaceVariant;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              'All projects',
              style: AppTypogragh.mono(color: color, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// Platform / type / source, in a hairline-topped row.
class _Facts extends StatelessWidget {
  const _Facts({required this.project});
  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final facts = <(String, String)>[
      ('PLATFORM', project.platforms.join(', ')),
      ('TYPE', project.category),
      ('SOURCE', project.githubUrl.isEmpty ? 'Private' : 'Public on GitHub'),
    ];

    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Wrap(
        spacing: 48,
        runSpacing: 20,
        children: [
          for (final f in facts)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.$1,
                  style: AppTypogragh.mono(color: scheme.primary, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Text(
                  f.$2,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
