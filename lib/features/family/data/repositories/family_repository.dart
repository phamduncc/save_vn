import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/family_member_model.dart';

abstract class FamilyRepository {
  Future<List<FamilyMemberModel>> getMembers();
  Future<void> saveMembers(List<FamilyMemberModel> members);
  Future<String> getMeetingPoint();
  Future<void> saveMeetingPoint(String point);
}

class FamilyRepositoryImpl implements FamilyRepository {
  static const String _membersKey = 'family_members_list_v1';
  static const String _meetingPointKey = 'family_meeting_point_v1';

  @override
  Future<List<FamilyMemberModel>> getMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_membersKey);
    if (jsonStr == null || jsonStr.isEmpty) {
      return [];
    }
    try {
      final decoded = json.decode(jsonStr) as List<dynamic>;
      return decoded
          .map((m) => FamilyMemberModel.fromJson(m as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveMembers(List<FamilyMemberModel> members) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(members.map((m) => m.toJson()).toList());
    await prefs.setString(_membersKey, jsonStr);
  }

  @override
  Future<String> getMeetingPoint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_meetingPointKey) ?? '';
  }

  @override
  Future<void> saveMeetingPoint(String point) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_meetingPointKey, point);
  }
}
