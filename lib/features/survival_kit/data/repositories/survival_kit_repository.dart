import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/kit_item_model.dart';

abstract class SurvivalKitRepository {
  Future<List<KitItemModel>> getKitItems();
  Future<void> toggleItem(String itemId, bool isChecked);
  Future<void> resetAll();
}

class SurvivalKitRepositoryImpl implements SurvivalKitRepository {
  static const String _prefKeyPrefix = 'kit_checked_';

  @override
  Future<List<KitItemModel>> getKitItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = await rootBundle.loadString('assets/data/emergency_kit.json');
    final dynamic decoded = json.decode(jsonString);

    if (decoded is List) {
      return decoded.map((item) {
        final map = item as Map<String, dynamic>;
        final id = map['id'] as String;
        final isChecked = prefs.getBool('$_prefKeyPrefix$id') ?? false;
        return KitItemModel.fromJson(map, isChecked: isChecked);
      }).toList();
    }
    return [];
  }

  @override
  Future<void> toggleItem(String itemId, bool isChecked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefKeyPrefix$itemId', isChecked);
  }

  @override
  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefKeyPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
