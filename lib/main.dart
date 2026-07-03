import 'package:bma_portfolio/core/router/app_router.dart';
import 'package:bma_portfolio/core/themes/dark_theme.dart';
import 'package:bma_portfolio/core/themes/light_theme.dart';
import 'package:bma_portfolio/core/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
            title: ' BMA Three Minds. Infinite Solutions.',
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
