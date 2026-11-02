import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum HomeSection { hero, about, services, projects, contact, footer }

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

    // 2. Ask the viewport for the offset that puts the target at the top.
    // The keys sit on each sheet's Transform, so this is the sheet's natural
    // position even while it is translated into its sticky place.
    final revealedOffset = viewport.getOffsetToReveal(renderBox, 0.0).offset;

    // 3. Sheets stick to the top of the screen, so no extra padding is needed.
    final max = controller!.position.maxScrollExtent;
    final target = revealedOffset < 0
        ? 0.0
        : (revealedOffset > max ? max : revealedOffset);

    controller!.animateTo(
      target,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }
}
