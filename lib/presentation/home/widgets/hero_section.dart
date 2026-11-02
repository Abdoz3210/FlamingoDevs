import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/core/utils/scroll_service.dart';
import 'package:bma_portfolio/presentation/home/widgets/draggable_flamingo.dart';
import 'package:bma_portfolio/presentation/shared_widgets/ghost_button.dart';
import 'package:bma_portfolio/presentation/shared_widgets/primary_button.dart';
import 'package:bma_portfolio/presentation/shared_widgets/reveal.dart';
import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  final ScrollService scrollService;

  const HeroSection({super.key, required this.scrollService});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final vh = MediaQuery.sizeOf(context).height;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: vh),
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Responsive.sideMargin(context),
            isMobile ? 88 : 96,
            Responsive.sideMargin(context),
            isMobile ? 48 : 64,
          ),
          child: isMobile ? _buildMobile(context) : _buildDesktop(context),
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 3, child: _buildContent(context, false)),
        const SizedBox(width: 40),
        const Expanded(
          flex: 2,
          child: Center(child: DraggableFlamingo(height: 520)),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    // The text is laid out under the bird's spot, and the bird comes last in
    // the stack, so when it is dragged over the text it passes in front.
    const birdHeight = 300.0;
    const birdBlock = birdHeight + 22; // the bird plus its "drag me" hint
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            const SizedBox(height: birdBlock + 24),
            _buildContent(context, true),
          ],
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Reveal(child: DraggableFlamingo(height: birdHeight)),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, bool isMobile) {
    final scheme = Theme.of(context).colorScheme;
    final headline = isMobile
        ? AppTypogragh.displayMobile(color: scheme.onSurface)
        : Theme.of(context).textTheme.displayLarge!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(
          child: Text(
            'FLAMINGO DEVS · MOBILE & WEB STUDIO',
            style: AppTypogragh.mono(color: scheme.primary, fontSize: 12),
          ),
        ),
        const SizedBox(height: 22),
        FoldHeadline(
          lead: 'We fold ideas into',
          accent: 'apps that ship.',
          style: headline,
        ),
        const SizedBox(height: 24),
        Reveal(
          delay: const Duration(milliseconds: 600),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              'Three developers, one studio. We design and build Flutter and '
              'iOS apps and websites, from the first sketch to the store '
              'listing.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Reveal(
          delay: const Duration(milliseconds: 750),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              PrimaryButton(
                label: 'See the work',
                onPressed: () => scrollService.scrollTo(HomeSection.projects),
              ),
              GhostButton(
                label: 'Contact',
                onPressed: () => scrollService.scrollTo(HomeSection.contact),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        Reveal(
          delay: const Duration(milliseconds: 900),
          child: Text(
            'scroll · each section is a sheet of paper',
            style: AppTypogragh.mono(
              color: scheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
