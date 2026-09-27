import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/hotline_model.dart';
import '../../data/repositories/hotline_repository.dart';

final hotlineRepositoryProvider = Provider<HotlineRepository>((ref) {
  return HotlineRepositoryImpl();
});

final hotlinesProvider = FutureProvider<List<HotlineModel>>((ref) async {
  final repo = ref.watch(hotlineRepositoryProvider);
  return repo.getHotlines();
});
