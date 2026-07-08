import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedSectionWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AnimatedSectionWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedSectionWrapper> createState() => _AnimatedSectionWrapperState();
}

class _AnimatedSectionWrapperState extends State<AnimatedSectionWrapper> {
  bool _visible = false;
  late final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (!_visible && info.visibleFraction > 0.12) {
          setState(() => _visible = true);
        }
      },
      child: AnimatedOpacity(
        opacity: 1,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
