import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/kit_item_model.dart';
import '../../data/repositories/survival_kit_repository.dart';

final survivalKitRepositoryProvider = Provider<SurvivalKitRepository>((ref) {
  return SurvivalKitRepositoryImpl();
});

class SurvivalKitNotifier extends StateNotifier<AsyncValue<List<KitItemModel>>> {
  final SurvivalKitRepository _repository;

  SurvivalKitNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      state = const AsyncValue.loading();
      final items = await _repository.getKitItems();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleItem(String id) async {
    final currentList = state.value;
    if (currentList == null) return;

    final index = currentList.indexWhere((i) => i.id == id);
    if (index == -1) return;

    final updatedItem = currentList[index].copyWith(isChecked: !currentList[index].isChecked);
    final newList = List<KitItemModel>.from(currentList);
    newList[index] = updatedItem;

    state = AsyncValue.data(newList);
    await _repository.toggleItem(id, updatedItem.isChecked);
  }

  Future<void> resetAll() async {
    await _repository.resetAll();
    await loadItems();
  }
}

final survivalKitNotifierProvider =
    StateNotifierProvider<SurvivalKitNotifier, AsyncValue<List<KitItemModel>>>((ref) {
  final repo = ref.watch(survivalKitRepositoryProvider);
  return SurvivalKitNotifier(repo);
});
