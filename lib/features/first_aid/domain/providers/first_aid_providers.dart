import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/first_aid_model.dart';
import '../../data/repositories/first_aid_repository.dart';

final firstAidRepositoryProvider = Provider<FirstAidRepository>((ref) {
  return FirstAidRepositoryImpl();
});

final firstAidGuidesProvider = FutureProvider<List<FirstAidModel>>((ref) async {
  final repo = ref.watch(firstAidRepositoryProvider);
  return repo.getFirstAidGuides();
});
