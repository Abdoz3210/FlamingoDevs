import 'dart:convert';

import 'package:bma_portfolio/data/models/project_model.dart';
import 'package:flutter/services.dart';

class ProjectRepository {
  static List<ProjectModel>? _cache;

  Future<List<ProjectModel>> getAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/projects.json');
    final list = jsonDecode(raw) as List;
    _cache = list
        .map(
          (element) => ProjectModel.fromJson(element as Map<String, dynamic>),
        )
        .toList();
    return _cache!;
  }

  Future<ProjectModel?> getBySlug(String slug) async {
    final all = await getAll();
    for (final p in all) {
      if (p.slug == slug) return p;
    }
    return null;
  }
}
