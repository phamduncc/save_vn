import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/family_member_model.dart';
import '../../data/repositories/family_repository.dart';

final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  return FamilyRepositoryImpl();
});

class FamilyNotifier extends StateNotifier<AsyncValue<List<FamilyMemberModel>>> {
  final FamilyRepository _repository;

  FamilyNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    try {
      final list = await _repository.getMembers();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addMember(FamilyMemberModel member) async {
    final current = state.value ?? [];
    final updated = [...current, member];
    state = AsyncValue.data(updated);
    await _repository.saveMembers(updated);
  }

  Future<void> removeMember(String id) async {
    final current = state.value ?? [];
    final updated = current.where((m) => m.id != id).toList();
    state = AsyncValue.data(updated);
    await _repository.saveMembers(updated);
  }
}

final familyNotifierProvider =
    StateNotifierProvider<FamilyNotifier, AsyncValue<List<FamilyMemberModel>>>((ref) {
  final repo = ref.watch(familyRepositoryProvider);
  return FamilyNotifier(repo);
});

final meetingPointProvider = FutureProvider<String>((ref) async {
  final repo = ref.watch(familyRepositoryProvider);
  return repo.getMeetingPoint();
});
