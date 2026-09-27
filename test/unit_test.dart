import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_vn/features/disaster/data/models/disaster_model.dart';
import 'package:save_vn/features/emergency/data/models/emergency_situation_model.dart';
import 'package:save_vn/features/first_aid/data/models/first_aid_model.dart';
import 'package:save_vn/features/survival_kit/data/models/kit_item_model.dart';
import 'package:save_vn/features/hotlines/data/models/hotline_model.dart';

void main() {
  group('JSON Assets & Domain Models Verification', () {
    test('disasters.json is valid and parses into DisasterModel', () {
      final file = File('assets/data/disasters.json');
      expect(file.existsSync(), isTrue);
      final jsonList = json.decode(file.readAsStringSync()) as List<dynamic>;
      expect(jsonList.isNotEmpty, isTrue);

      final models = jsonList
          .map((e) => DisasterModel.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(models.length, jsonList.length);
      for (final m in models) {
        expect(m.id.isNotEmpty, isTrue);
        expect(m.name.isNotEmpty, isTrue);
        expect(m.phases.before.isNotEmpty, isTrue);
        expect(m.phases.during.isNotEmpty, isTrue);
      }
    });

    test('emergency_situations.json is valid and parses into EmergencySituationModel', () {
      final file = File('assets/data/emergency_situations.json');
      expect(file.existsSync(), isTrue);
      final jsonList = json.decode(file.readAsStringSync()) as List<dynamic>;
      expect(jsonList.isNotEmpty, isTrue);

      final models = jsonList
          .map((e) => EmergencySituationModel.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(models.length, jsonList.length);
      for (final m in models) {
        expect(m.id.isNotEmpty, isTrue);
        expect(m.title.isNotEmpty, isTrue);
        expect(m.steps.isNotEmpty, isTrue);
      }
    });

    test('first_aid.json is valid and parses into FirstAidModel', () {
      final file = File('assets/data/first_aid.json');
      expect(file.existsSync(), isTrue);
      final jsonList = json.decode(file.readAsStringSync()) as List<dynamic>;
      expect(jsonList.isNotEmpty, isTrue);

      final models = jsonList
          .map((e) => FirstAidModel.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(models.length, jsonList.length);
      for (final m in models) {
        expect(m.id.isNotEmpty, isTrue);
        expect(m.title.isNotEmpty, isTrue);
        expect(m.steps.isNotEmpty, isTrue);
      }
    });

    test('emergency_kit.json is valid and parses into KitItemModel', () {
      final file = File('assets/data/emergency_kit.json');
      expect(file.existsSync(), isTrue);
      final jsonList = json.decode(file.readAsStringSync()) as List<dynamic>;
      expect(jsonList.isNotEmpty, isTrue);

      final models = jsonList
          .map((e) => KitItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(models.length, jsonList.length);
    });

    test('hotlines.json is valid and parses into HotlineModel', () {
      final file = File('assets/data/hotlines.json');
      expect(file.existsSync(), isTrue);
      final jsonList = json.decode(file.readAsStringSync()) as List<dynamic>;
      expect(jsonList.isNotEmpty, isTrue);

      final models = jsonList
          .map((e) => HotlineModel.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(models.length, jsonList.length);
    });
  });
}
