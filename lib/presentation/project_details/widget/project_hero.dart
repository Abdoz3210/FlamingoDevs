import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectHero extends StatelessWidget {
  final ProjectModel project;
  const ProjectHero({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.sideMargin(context),
        isMobile ? 110 : 140,
        Responsive.sideMargin(context),
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.goNamed(RouterNames.home),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 14,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  'Back to projects',
                  style: AppTypogragh.mono(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          isMobile ? _buildMobile(context) : _buildDesktop(context),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _buildInfo(context)),
        const SizedBox(width: 40),
        Expanded(flex: 6, child: _buildCoverImage(context)),
        _GitHubButton(url: project.githubUrl),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfo(context),
        const SizedBox(height: 28),
        _buildCoverImage(context),
        // GitHub button — only shows if repo URL is provided
        if (project.githubUrl.isNotEmpty) ...[
          const SizedBox(height: 20),
          _GitHubButton(url: project.githubUrl),
        ],
      ],
    );
  }

  Widget _buildInfo(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colors.primaryContainer.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            project.category.toUpperCase(),
            style: AppTypogragh.mono(color: colors.primary, fontSize: 11),
          ),
        ),
        const SizedBox(height: 16),
        Text(project.title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            project.tagline,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          children: project.platforms
              .map((p) => _PlatformPill(platform: p))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          project.coverImage,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Center(
            child: Icon(Icons.image_outlined, color: colors.outline, size: 48),
          ),
        ),
      ),
    );
  }
}

class _PlatformPill extends StatelessWidget {
  final String platform;
  const _PlatformPill({required this.platform});

  IconData get _icon {
    switch (platform.toLowerCase()) {
      case 'ios':
        return Icons.phone_iphone;
      case 'android':
        return Icons.android;
      case 'flutter':
        return Icons.flutter_dash;
      default:
        return Icons.devices_other;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 13, color: colors.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            platform.toUpperCase(),
            style: AppTypogragh.mono(
              color: colors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _GitHubButton extends StatefulWidget {
  final String url;
  const _GitHubButton({required this.url});

  @override
  State<_GitHubButton> createState() => _GitHubButtonState();
}

class _GitHubButtonState extends State<_GitHubButton> {
  bool _hovered = false;

  Future<void> _open() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _hovered ? colors.primary : colors.outlineVariant,
            ),
            color: _hovered
                ? colors.primary.withValues(alpha: 0.08)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code,
                size: 16,
                color: _hovered ? colors.primary : colors.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'VIEW ON GITHUB',
                style: AppTypogragh.mono(
                  color: _hovered ? colors.primary : colors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
