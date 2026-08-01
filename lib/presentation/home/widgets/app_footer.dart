import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/presentation/shared_widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  // final _emailCtrl = TextEditingController();
  // bool _subscribed = false;
  final _socials = [
    (
      'TikTok',
      'https://www.tiktok.com/@flamingodevsofficial',
      'assets/images/logo/icons8-tiktok-50.png',
    ),
    (
      'Instagram',
      'https://www.instagram.com/flamingodevsofficial/',
      'assets/images/logo/icons8-instagram-50.png',
    ),
    (
      'X / Twitter',
      'https://x.com/FlamingoDevs',
      'assets/images/logo/icons8-x-50.png',
    ),
    (
      'LinkedIn',
      'https://linkedin.com/flamingo-devs-official',
      'assets/images/logo/icons8-linkedin-2-50.png',
    ),
    (
      'Fiverr',
      'https://www.fiverr.com/s/rEWarQj',
      'assets/images/logo/icons8-fiverr-50.png',
    ),
    (
      'Freelancer',
      'https://www.freelancer.com/u/flamingodevs',
      'assets/images/logo/pngegg.png',
    ),
    (
      'Upwork',
      'https://www.upwork.com/freelancers/~012c563d8b6649e09f',
      'assets/images/logo/icons8-upwork-50.png',
    ),
    (
      'WhatsApp',
      'https://wa.me/201033388204',
      'assets/images/logo/icons8-whatsapp-50.png',
    ),
    ('Discord', '', 'assets/images/logo/icons8-discord-50.png'),
    ('Github', '', 'assets/images/logo/icons8-github-50.png'),
    ('Figma', '', 'assets/images/logo/icons8-figma-50.png'),
    ('Behance', '', 'assets/images/logo/icons8-behance-50.png'),
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

  Future<void> _openUrl(String url) async {
    final urllast = Uri.parse(url);
    if (await canLaunchUrl(urllast)) await launchUrl(urllast);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: colors.surfaceContainerLow,
      padding: EdgeInsets.fromLTRB(
        Responsive.sideMargin(context),
        64,
        Responsive.sideMargin(context),
        28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile ? _buildMobile(context) : _buildDesktop(context),
          const SizedBox(height: 48),
          Divider(color: colors.outlineVariant),
          const SizedBox(height: 20),
          Text(
            '© ${DateTime.now().year} Flamingo. '
            'Three Minds. Infinite Solutions.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Row();
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildBrand(context)),
        Expanded(flex: 2, child: _buildLegal(context)),
        Expanded(flex: 3, child: _buildSocial(context)),
        // Expanded(flex: 2, child: _buildNewsletter(context)),
        // _buildNewsletter(context),
      ],
    );
  }

  Widget _buildBrand(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLogo(size: 22),
        const SizedBox(height: 12),
        SizedBox(
          width: 240,
          child: Text(
            'Three minds. Infinite Solutions.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildLegal(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LEGAL', style: AppTypogragh.mono(color: colors.onSurfaceVariant)),
        const SizedBox(height: 16),
        for (final item in _legal)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => _openUrl(item.$2),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  item.$1,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSocial(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONNECT',
          style: AppTypogragh.mono(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final s in _socials)
              _SocialIcon(icon: s.$3, label: s.$1, onTap: () => _openUrl(s.$2)),
          ],
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  const _SocialIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Tooltip(
      message: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() {
          _hovered = true;
        }),
        onExit: (_) => setState(() {
          _hovered = false;
        }),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // border: Border.all(
              //   color: _hovered ? colors.primary : colors.outlineVariant,
              // ),
              color: _hovered
                  ? colors.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
            ),
            child: ImageIcon(
              AssetImage(widget.icon),
              size: 16,
              color: _hovered ? colors.primary : colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
