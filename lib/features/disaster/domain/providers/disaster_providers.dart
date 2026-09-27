import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/disaster_model.dart';
import '../../data/repositories/disaster_repository.dart';

final disasterRepositoryProvider = Provider<DisasterRepository>((ref) {
  return DisasterRepositoryImpl();
});

final disastersProvider = FutureProvider<List<DisasterModel>>((ref) async {
  final repo = ref.watch(disasterRepositoryProvider);
  return repo.getDisasters();
});
