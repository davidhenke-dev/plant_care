import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/plant.dart';
import '../../../data/repositories/plant_repository.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../plants/application/plant_notifier.dart';

class HomeNotifier extends AsyncNotifier<List<Plant>> {
  late PlantRepository _repository;

  @override
  Future<List<Plant>> build() async {
    ref.watch(plantNotifierProvider);
    _repository = ref.read(plantRepositoryProvider);
    return _repository.getPlantsNeedingWater();
  }

  Future<void> markAsWatered(String id) async {
    final plant = await _repository.getById(id);
    if (plant != null) {
      plant.lastWateredAt = DateTime.now();
      await plant.save();
      ref.invalidateSelf();
    }
  }
}

final homeNotifierProvider =
    AsyncNotifierProvider<HomeNotifier, List<Plant>>(
  HomeNotifier.new,
);