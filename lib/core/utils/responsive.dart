import 'package:bma_portfolio/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppSizes.mobile;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= AppSizes.mobile && w < AppSizes.tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppSizes.tablet;

  static double sideMargin(BuildContext context) =>
      isMobile(context) ? AppSizes.marginMobile : AppSizes.marginDesktop;

  static int gridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }
}
