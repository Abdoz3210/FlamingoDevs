import 'package:bma_portfolio/presentation/shared_widgets/app_logo.dart';
import 'package:bma_portfolio/presentation/shared_widgets/primary_button.dart';
import 'package:bma_portfolio/presentation/shared_widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import '../../core/utils/scroll_service.dart';

class HomePage extends StatefulWidget {
  final HomeSection? initialSection;
  const HomePage({super.key, this.initialSection});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Home Page', style: Theme.of(context).textTheme.displayLarge),
            AppLogo(),
            ThemeToggleButton(),
            PrimaryButton(label: 'test', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
