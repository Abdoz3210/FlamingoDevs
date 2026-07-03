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
        child: Text(
          'Home Page',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
