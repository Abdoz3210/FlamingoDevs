import 'package:flutter/material.dart';

class ProjectDetailsPage extends StatelessWidget {
  final String slug;
  const ProjectDetailsPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Project: $slug',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
