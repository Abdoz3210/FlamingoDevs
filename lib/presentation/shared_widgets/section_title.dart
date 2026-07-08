import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;
  final TextAlign align;

  const SectionTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: align == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: align,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ],
    );
  }
}
