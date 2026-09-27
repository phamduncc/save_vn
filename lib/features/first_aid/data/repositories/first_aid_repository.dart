import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/first_aid_model.dart';

abstract class FirstAidRepository {
  Future<List<FirstAidModel>> getFirstAidGuides();
}

class FirstAidRepositoryImpl implements FirstAidRepository {
  List<FirstAidModel>? _cached;

  @override
  Future<List<FirstAidModel>> getFirstAidGuides() async {
    if (_cached != null) return _cached!;

    final jsonString = await rootBundle.loadString('assets/data/first_aid.json');
    final dynamic decoded = json.decode(jsonString);
    if (decoded is List) {
      _cached = decoded
          .map((item) => FirstAidModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return _cached!;
    }
    return [];
  }
}
