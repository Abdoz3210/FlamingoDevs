import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/service_model.dart';

class ServiceRepository {
  static List<ServiceModel>? _cache;

  Future<List<ServiceModel>> getAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/services.json');
    final list = jsonDecode(raw) as List;
    _cache = list
        .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cache!;
  }
}
