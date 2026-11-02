import 'package:bma_portfolio/core/router/app_router.dart';
import 'package:bma_portfolio/core/themes/dark_theme.dart';
import 'package:bma_portfolio/core/themes/light_theme.dart';
import 'package:bma_portfolio/core/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  // Reveal animations should start as soon as something scrolls into view.
  VisibilityDetectorController.instance.updateInterval = const Duration(
    milliseconds: 80,
  );
  runApp(const BmaApp());
}

class BmaApp extends StatelessWidget {
  const BmaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'Flamingo Devs · Three minds. Infinite solutions.',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.mode,
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
