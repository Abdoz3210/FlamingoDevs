import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:bma_portfolio/core/themes/night_theme.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/core/utils/scroll_service.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:bma_portfolio/data/repositories/project_repository.dart';
import 'package:bma_portfolio/presentation/shared_widgets/app_logo.dart';
import 'package:bma_portfolio/presentation/shared_widgets/ghost_button.dart';
import 'package:bma_portfolio/presentation/shared_widgets/origami_widgets.dart';
import 'package:bma_portfolio/presentation/shared_widgets/paper_edge.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// The footer: a dark sheet with a paper-cut top edge, four link columns and a
/// strip of paper teeth that fold up when it scrolls into view.
class AppFooter extends StatefulWidget {
  const AppFooter({
    super.key,
    required this.onNavigate,
    required this.onBackToTop,
  });

  /// Jump to a section of the home page.
  final void Function(HomeSection section) onNavigate;
  final VoidCallback onBackToTop;

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  static const _socials = [
    ('TikTok', 'https://www.tiktok.com/@flamingodevsofficial'),
    ('Instagram', 'https://www.instagram.com/flamingodevsofficial/'),
    ('X / Twitter', 'https://x.com/FlamingoDevs'),
    ('LinkedIn', 'https://linkedin.com/flamingo-devs-official'),
    ('GitHub', 'https://github.com/Abdoz3210'),
    ('Fiverr', 'https://www.fiverr.com/s/rEWarQj'),
    ('Freelancer', 'https://www.freelancer.com/u/flamingodevs'),
    ('Upwork', 'https://www.upwork.com/freelancers/~012c563d8b6649e09f'),
    ('WhatsApp', 'https://wa.me/201033388204'),
  ];

  static const _legal = [
    (
      'Privacy Policy',
      'https://docs.google.com/document/d/1YiC9om3W6GjVZvGc-OhnLdXRzYsFV0ft2A53fFxkkwU/edit?usp=sharing',
    ),
    (
      'Terms of Service',
      'https://docs.google.com/document/d/1k85H-Mb11UnnLKuNhGkVDnIuoQTurzTiy2RHfC7UCfY/edit?usp=sharing',
    ),
    (
      'Careers',
      'https://docs.google.com/document/d/1oxe8ybZqKmdVctCMyOZmgcrs4r96fSybjgtJwTZAyp8/edit?usp=sharing',
    ),
  ];

  static const _explore = [
    (HomeSection.hero, 'Home'),
    (HomeSection.about, 'About'),
    (HomeSection.services, 'Services'),
    (HomeSection.projects, 'Projects'),
    (HomeSection.contact, 'Contact'),
  ];

  final _repo = ProjectRepository();
  final _visibilityKey = UniqueKey();
  List<ProjectModel> _projects = [];
  bool _inView = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await _repo.getAll();
    if (!mounted) return;
    setState(() => _projects = all.where((p) => !p.isPlaceholder).toList());
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }

  @override
  Widget build(BuildContext context) {
    // The page footer color, pushed a third of the way toward black so it
    // reads as the darkest sheet.
    final base = OrigamiColors.of(context).footer;
    final bg = Color.lerp(base, Colors.black, 0.32)!;

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: (info) {
        if (!_inView && info.visibleFraction > 0.15) {
          setState(() => _inView = true);
        }
      },
      child: Theme(
        data: nightTheme,
        child: Builder(
          builder: (context) => Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                color: bg,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        Responsive.sideMargin(context),
                        64,
                        Responsive.sideMargin(context),
                        0,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1120),
                          child: _buildContent(context),
                        ),
                      ),
                    ),
                    PaperTeeth(visible: _inView),
                  ],
                ),
              ),
              // The paper-cut top edge, hanging over the sheet above.
              Positioned(
                top: -kZigLow,
                left: 0,
                right: 0,
                height: kZigLow + 2,
                child: ClipPath(
                  clipper: const ZigzagTopClipper(),
                  child: ColoredBox(color: bg),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final scheme = Theme.of(context).colorScheme;

    final brand = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLogo(size: 34),
        const SizedBox(height: 14),
        Text(
          'THREE MINDS. INFINITE SOLUTIONS.',
          style: AppTypogragh.mono(color: scheme.primary, fontSize: 11),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Text(
            'A three-person studio building Flutter and iOS apps and '
            'websites.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );

    final toTop = GhostButton(
      label: '↑ BACK TO TOP',
      onPressed: widget.onBackToTop,
    );

    final columns = <Widget>[
      _FootColumn(
        title: 'Explore',
        links: [
          for (final e in _explore)
            _FootLink(label: e.$2, onTap: () => widget.onNavigate(e.$1)),
        ],
      ),
      _FootColumn(
        title: 'Projects',
        links: [
          for (final p in _projects)
            _FootLink(
              label: p.title,
              onTap: () => context.pushNamed(
                RouterNames.projectDetails,
                pathParameters: {'slug': p.slug},
              ),
            ),
        ],
      ),
      _FootColumn(
        title: 'Find us',
        links: [
          for (final s in _socials)
            _FootLink(label: '${s.$1} ↗', onTap: () => _openUrl(s.$2)),
        ],
      ),
      _FootColumn(
        title: 'Legal',
        links: [
          for (final l in _legal)
            _FootLink(label: '${l.$1} ↗', onTap: () => _openUrl(l.$2)),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile) ...[brand, const SizedBox(height: 24), toTop] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [brand, toTop],
          ),
        const SizedBox(height: 44),
        Divider(color: scheme.outlineVariant, height: 1),
        const SizedBox(height: 40),
        if (isMobile)
          LayoutBuilder(
            builder: (context, c) {
              final w = (c.maxWidth - 24) / 2;
              return Wrap(
                spacing: 24,
                runSpacing: 32,
                children: [
                  for (final col in columns) SizedBox(width: w, child: col),
                ],
              );
            },
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [for (final col in columns) Expanded(child: col)],
          ),
        const SizedBox(height: 48),
        Divider(color: scheme.outlineVariant, height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 16,
            runSpacing: 8,
            children: [
              Text(
                '© ${DateTime.now().year} Flamingo Devs. All rights reserved.',
                style: AppTypogragh.mono(
                  color: scheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              Text(
                'WhatsApp +20 103 338 8204',
                style: AppTypogragh.mono(
                  color: scheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FootColumn extends StatelessWidget {
  const _FootColumn({required this.title, required this.links});

  final String title;
  final List<Widget> links;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppTypogragh.mono(color: scheme.primary, fontSize: 11),
        ),
        const SizedBox(height: 16),
        for (final l in links) ...[l, const SizedBox(height: 10)],
      ],
    );
  }
}

class _FootLink extends StatefulWidget {
  const _FootLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_FootLink> createState() => _FootLinkState();
}

class _FootLinkState extends State<_FootLink> {
  bool _lit = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowHoverHighlight: (v) => setState(() => _lit = v),
      onShowFocusHighlight: (v) => setState(() => _lit = v),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap();
            return null;
          },
        ),
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            color: _lit ? scheme.primary : scheme.onSurface,
            decoration: _lit ? TextDecoration.underline : TextDecoration.none,
            decorationColor: scheme.primary,
          ),
        ),
      ),
    );
  }
}
