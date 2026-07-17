import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/core/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/project_model.dart';

class NextProjectLink extends StatefulWidget {
  final ProjectModel next;
  const NextProjectLink({super.key, required this.next});

  @override
  State<NextProjectLink> createState() => _NextProjectLinkState();
}

class _NextProjectLinkState extends State<NextProjectLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.sideMargin(context),
        vertical: 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: colors.outlineVariant),
          const SizedBox(height: 32),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              onTap: () => context.goNamed(
                RouterNames.projectDetails,
                pathParameters: {'slug': widget.next.slug},
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NEXT PROJECT',
                          style: AppTypogragh.mono(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.next.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                  // Circular arrow button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _hovered
                            ? colors.primary
                            : colors.outlineVariant,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: _hovered
                          ? colors.primary
                          : colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
