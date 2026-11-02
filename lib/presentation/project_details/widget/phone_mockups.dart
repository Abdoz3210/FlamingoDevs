import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:bma_portfolio/presentation/shared_widgets/paper_edge.dart';
import 'package:flutter/material.dart';

/// Three phones that start stacked like folded paper and fan out as the stage
/// scrolls into view. On desktop the whole group tilts toward the pointer.
class PhoneMockups extends StatefulWidget {
  const PhoneMockups({super.key, required this.project, required this.scroll});

  final ProjectModel project;

  /// The page's scroll controller: it drives the fan-out.
  final ScrollController scroll;

  @override
  State<PhoneMockups> createState() => _PhoneMockupsState();
}

class _PhoneMockupsState extends State<PhoneMockups> {
  final _stageKey = GlobalKey();
  Offset _tilt = Offset.zero; // x: rotateX, y: rotateY (radians)

  @override
  void initState() {
    super.initState();
    // Measure once the first frame is laid out, in case the stage is already
    // on screen and no scroll event will fire.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  /// 0 when the stage is just entering from below, 1 once it is well inside.
  double _fan(double vh) {
    final ro = _stageKey.currentContext?.findRenderObject();
    if (ro is! RenderBox || !ro.attached || !ro.hasSize) return 0;
    final top = ro.localToGlobal(Offset.zero).dy;
    return clampUnit((vh * 0.95 - top) / (vh * 0.7));
  }

  void _onHover(PointerEvent e) {
    final ro = _stageKey.currentContext?.findRenderObject();
    if (ro is! RenderBox || !ro.hasSize) return;
    final local = ro.globalToLocal(e.position);
    final nx = clampUnit(local.dx / ro.size.width) - 0.5;
    final ny = clampUnit(local.dy / ro.size.height) - 0.5;
    setState(() => _tilt = Offset(-ny * 0.14, nx * 0.14));
  }

  @override
  Widget build(BuildContext context) {
    final gallery = widget.project.gallery;
    if (gallery.isEmpty) return const SizedBox.shrink();

    final isMobile = Responsive.isMobile(context);
    final reduced = MediaQuery.disableAnimationsOf(context);
    final vh = MediaQuery.sizeOf(context).height;
    final phoneW = isMobile ? 138.0 : 220.0;
    final spread = isMobile ? 112.0 : 250.0;
    final stageH = phoneW * 19.5 / 9 + 70;

    String at(int i) => gallery[i % gallery.length].path;
    final tallIdx = gallery.indexWhere((g) => g.size == GalleryImageSize.tall);
    final centerImg = at(tallIdx >= 0 ? tallIdx : 2);
    final leftImg = at(0);
    final rightImg = at(1);

    return MouseRegion(
      onHover: isMobile ? null : _onHover,
      onExit: (_) => setState(() => _tilt = Offset.zero),
      child: SizedBox(
        key: _stageKey,
        height: stageH,
        width: double.infinity,
        child: TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(end: reduced ? Offset.zero : _tilt),
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          builder: (context, tilt, _) => AnimatedBuilder(
            animation: widget.scroll,
            builder: (context, _) {
              final q = reduced ? 1.0 : _fan(vh);
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateX(tilt.dx)
                  ..rotateY(tilt.dy),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    _fanned(
                      dx: -spread * q,
                      dy: 26 * q,
                      angle: -0.14 * q,
                      scale: 0.94,
                      child: _Phone(image: leftImg, width: phoneW),
                    ),
                    _fanned(
                      dx: spread * q,
                      dy: 26 * q,
                      angle: 0.14 * q,
                      scale: 0.94,
                      child: _Phone(image: rightImg, width: phoneW),
                    ),
                    _fanned(
                      dx: 0,
                      dy: -14 * q,
                      angle: 0,
                      scale: 1 + 0.03 * q,
                      child: _Phone(image: centerImg, width: phoneW),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _fanned({
    required double dx,
    required double dy,
    required double angle,
    required double scale,
    required Widget child,
  }) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.translationValues(dx, dy, 0)
        ..multiply(Matrix4.diagonal3Values(scale, scale, 1))
        ..multiply(Matrix4.rotationZ(angle)),
      child: child,
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone({required this.image, required this.width});

  final String image;
  final double width;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final height = width * 19.5 / 9;
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(width * 0.035),
      decoration: BoxDecoration(
        color: const Color(0xFF14090F),
        borderRadius: BorderRadius.circular(width * 0.14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 40,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width * 0.11),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: scheme.surfaceContainerHighest,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                excludeFromSemantics: true,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: width * 0.04),
                width: width * 0.28,
                height: width * 0.05,
                decoration: BoxDecoration(
                  color: const Color(0xFF14090F),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
