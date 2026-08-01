import 'package:bma_portfolio/core/constants/app_colors.dart';
import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/core/utils/scroll_service.dart';
import 'package:bma_portfolio/presentation/shared_widgets/ghost_button.dart';
import 'package:bma_portfolio/presentation/shared_widgets/primary_button.dart';
import 'package:flutter/material.dart';

class HeroSection extends StatefulWidget {
  final ScrollService scrollService;

  const HeroSection({super.key, required this.scrollService});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final colors = Theme.of(context).colorScheme;

    final headlineStyle = isMobile
        ? AppTypogragh.displayMobile(color: colors.onSurface)
        : Theme.of(context).textTheme.displayLarge;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.sideMargin(context),
        isMobile ? 140 : 180,
        Responsive.sideMargin(context),
        80,
      ),
      child: isMobile
          ? _buildMobile(context, headlineStyle)
          : _buildDesktop(context, headlineStyle),
    );
  }

  Widget _buildDesktop(BuildContext context, TextStyle? headlineStyle) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 3, child: _buildContent(context, headlineStyle, colors)),
        const SizedBox(width: 40),
        Expanded(
          flex: 2,
          child: Center(child: _HoverLogo(isDark: isDark)),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context, TextStyle? headlineStyle) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Center(child: _HoverLogo(isDark: isDark)),
        const SizedBox(height: 32),

        _buildContent(context, headlineStyle, colors),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    TextStyle? headlineStyle,
    ColorScheme colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MOBILE ENGINEERING',
          style: AppTypogragh.headlineMobile(color: colors.primary),
        ),
        const SizedBox(height: 20),
        // Headline — each line reacts to hover independently
        _HoverText(
          text: 'Precisely crafted',
          style: AppTypogragh.origami(color: AppColors.darkPrimaryContainer),
          useGradientDefault: true, // this line starts as gradient
        ),
        _HoverText(
          text: 'mobile experiences',
          style: AppTypogragh.origami(color: AppColors.darkPrimaryContainer),
          useGradientDefault: true, // this line starts as gradient
        ),
        _HoverText(
          text: 'for visionary brands.',
          style: AppTypogragh.origami(color: AppColors.darkPrimaryContainer),
          useGradientDefault: true, // this line starts as gradient
        ),

        const SizedBox(height: 20),

        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: Text(
            'We blend architectural discipline with elite engineering '
            'to build high-performance mobile products that scale.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            PrimaryButton(
              label: 'VIEW OUR WORK',
              onPressed: () =>
                  widget.scrollService.scrollTo(HomeSection.projects),
            ),
            GhostButton(
              label: 'ABOUT US',
              onPressed: () => widget.scrollService.scrollTo(HomeSection.about),
            ),
          ],
        ),
      ],
    );
  }
}

class _HoverLogo extends StatefulWidget {
  final bool isDark;
  const _HoverLogo({required this.isDark});

  @override
  State<_HoverLogo> createState() => __HoverLogoState();
}

class __HoverLogoState extends State<_HoverLogo> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final defualtAsset = widget.isDark
        ? 'assets/images/logo/icon_dark.png'
        : 'assets/images/logo/icon_light.png';

    final hoverAsset = !widget.isDark
        ? 'assets/images/logo/icon_dark.png'
        : 'assets/images/logo/icon_light.png';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() {
        _hovered = true;
      }),
      onExit: (_) => setState(() {
        _hovered = false;
      }),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: _hovered ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 400),
            child: Image.asset(
              defualtAsset,
              key: ValueKey(_hovered),
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),
          ),
          AnimatedOpacity(
            opacity: _hovered ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 400),
            child: Image.asset(
              hoverAsset,
              key: ValueKey(_hovered),
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final bool useGradientDefault;

  const _HoverText({
    required this.text,
    required this.style,
    this.useGradientDefault = false,
  });

  @override
  State<_HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<_HoverText> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final showGradient = widget.useGradientDefault ? !_hovered : _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: showGradient ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: Text(
              widget.text,
              key: ValueKey('gradient_${widget.text}'),
              style: widget.style,
            ),
          ),
          AnimatedOpacity(
            opacity: showGradient ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: Text(
              widget.text,
              key: ValueKey('plain_${widget.text}'),
              style: widget.style.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
