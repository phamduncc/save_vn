import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/hotline_model.dart';

abstract class HotlineRepository {
  Future<List<HotlineModel>> getHotlines();
}

class HotlineRepositoryImpl implements HotlineRepository {
  List<HotlineModel>? _cached;

  @override
  Future<List<HotlineModel>> getHotlines() async {
    if (_cached != null) return _cached!;

    final jsonString = await rootBundle.loadString('assets/data/hotlines.json');
    final dynamic decoded = json.decode(jsonString);
    if (decoded is List) {
      _cached = decoded
          .map((item) => HotlineModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return _cached!;
    }
    return [];
  }
}
