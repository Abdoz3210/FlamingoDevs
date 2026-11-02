import 'package:bma_portfolio/core/utils/responsive.dart';
import 'package:bma_portfolio/data/models/service_model.dart';
import 'package:bma_portfolio/data/repositories/service_repository.dart';
import 'package:bma_portfolio/presentation/home/widgets/service_card.dart';
import 'package:bma_portfolio/presentation/shared_widgets/reveal.dart';
import 'package:bma_portfolio/presentation/shared_widgets/section_title.dart';
import 'package:flutter/material.dart';

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  final _repo = ServiceRepository();
  List<ServiceModel> _services = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final services = await _repo.getAll();
    if (mounted) setState(() => _services = services);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final columns = Responsive.gridColumns(context);
    final vh = MediaQuery.sizeOf(context).height;
    const gap = 20.0;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: vh),
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Responsive.sideMargin(context),
            isMobile ? 88 : 112,
            Responsive.sideMargin(context),
            isMobile ? 56 : 96,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                eyebrow: 'Services',
                title: 'What we',
                accent: 'build',
              ),
              const SizedBox(height: 48),
              if (_services.isEmpty)
                const SizedBox(height: 200)
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width =
                        (constraints.maxWidth - gap * (columns - 1)) / columns;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (var i = 0; i < _services.length; i++)
                          SizedBox(
                            width: width,
                            child: Reveal(
                              delay: Duration(milliseconds: 150 + i * 80),
                              child: ServiceCard(service: _services[i]),
                            ),
                          ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
