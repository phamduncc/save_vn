import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/emergency_situation_model.dart';

abstract class EmergencyRepository {
  Future<List<EmergencySituationModel>> getSituations();
}

class EmergencyRepositoryImpl implements EmergencyRepository {
  List<EmergencySituationModel>? _cached;

  @override
  Future<List<EmergencySituationModel>> getSituations() async {
    if (_cached != null) return _cached!;

    final jsonString = await rootBundle.loadString('assets/data/emergency_situations.json');
    final dynamic decoded = json.decode(jsonString);
    if (decoded is List) {
      _cached = decoded
          .map((item) => EmergencySituationModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return _cached!;
    }
    return [];
  }
}
