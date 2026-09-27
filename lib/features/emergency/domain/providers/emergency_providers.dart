import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/emergency_situation_model.dart';
import '../../data/repositories/emergency_repository.dart';

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  return EmergencyRepositoryImpl();
});

final emergencySituationsProvider = FutureProvider<List<EmergencySituationModel>>((ref) async {
  final repo = ref.watch(emergencyRepositoryProvider);
  return repo.getSituations();
});
