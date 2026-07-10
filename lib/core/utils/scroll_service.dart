import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum HomeSection { hero, about, services, projects, contact }

class ScrollService {
  ScrollService._internal();
  static final ScrollService _instance = ScrollService._internal();
  factory ScrollService() => _instance;

  final Map<HomeSection, GlobalKey> _key = {
    for (final s in HomeSection.values) s: GlobalKey(),
  };

  ScrollController? controller;
  GlobalKey keyFor(HomeSection section) => _key[section]!;

  void scrollTo(HomeSection section) {
    if (controller == null || !controller!.hasClients) {
      print(
        "⚠️ ScrollService Error: Controller is not attached to any scroll view!",
      );
      return;
    }

    final key = _key[section];
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;

    final renderBox = ctx.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // 1. Locate the closest viewport structure containing this box
    final viewport = RenderAbstractViewport.maybeOf(renderBox);
    if (viewport == null) return;

    // 2. Ask the viewport for the precise offset required to align the target widget
    // at the top (alignment: 0.0)
    final revealedOffset = viewport.getOffsetToReveal(renderBox, 0.0).offset;

    // 3. Apply your padding modification (-80) and boundary boundaries
    final target = (revealedOffset - 80).clamp(
      0.0,
      controller!.position.maxScrollExtent,
    );

    controller!.animateTo(
      target,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }
}
