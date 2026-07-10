import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/service_model.dart';
import '../../../data/repositories/service_repository.dart';
import '../../shared_widgets/section_title.dart';
import 'service_card.dart';

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

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.sideMargin(context),
        vertical: isMobile ? 40 : 80,
      ),
      child: Column(
        children: [
          const SectionTitle(
            eyebrow: 'Capabilities',
            title: 'Technical Excellence',
            align: TextAlign.center,
          ),
          const SizedBox(height: 48),
          if (_services.isEmpty)
            const SizedBox(height: 200)
          else
            AnimationLimiter(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: List.generate(_services.length, (index) {
                  // Each card takes roughly 1/columns of the available width
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 450),
                    child: FadeInAnimation(
                      child: SlideAnimation(
                        verticalOffset: 24,
                        child: SizedBox(
                          width:
                              (MediaQuery.sizeOf(context).width -
                                  (Responsive.sideMargin(context) * 2) -
                                  (20 * (columns - 1))) /
                              columns,
                          child: ServiceCard(service: _services[index]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
