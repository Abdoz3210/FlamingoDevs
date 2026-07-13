import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:bma_portfolio/core/utils/scroll_service.dart';
import 'package:bma_portfolio/presentation/home_page.dart';
import 'package:bma_portfolio/presentation/project_details_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<void> _buildPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    child: child,
    key: key,
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 400),

    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: RouterNames.home,
      pageBuilder: (context, state) {
        final target = state.extra is HomeSection
            ? state.extra as HomeSection
            : null;
        return _buildPage(
          key: state.pageKey,
          child: HomePage(initialSection: target),
        );
      },
    ),

    GoRoute(
      path: '/projects/:slug',
      name: RouterNames.projectDetails,
      pageBuilder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return _buildPage(
          key: state.pageKey,
          child: ProjectDetailsPage(slug: slug),
        );
      },
    ),
  ],
);
