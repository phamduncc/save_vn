import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/disaster_model.dart';

abstract class DisasterRepository {
  Future<List<DisasterModel>> getDisasters();
}

class DisasterRepositoryImpl implements DisasterRepository {
  List<DisasterModel>? _cached;

  @override
  Future<List<DisasterModel>> getDisasters() async {
    if (_cached != null) return _cached!;

    final jsonString = await rootBundle.loadString('assets/data/disasters.json');
    final dynamic decoded = json.decode(jsonString);
    if (decoded is List) {
      _cached = decoded
          .map((item) => DisasterModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return _cached!;
    }
    return [];
  }
}
