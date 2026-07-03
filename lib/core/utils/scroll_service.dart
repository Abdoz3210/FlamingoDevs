import 'package:flutter/material.dart';

enum HomeSection { hero, about, service, projects, contact }

class ScrollService {
  final Map<HomeSection, GlobalKey> _key = {
    for (final s in HomeSection.values) s: GlobalKey(),
  };

  GlobalKey keyFor(HomeSection section) => _key[section]!;

  void scrollTo(HomeSection section) {
    final ctx = _key[section]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }
}
