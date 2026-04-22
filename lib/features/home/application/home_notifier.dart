import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/plant.dart';
import '../../../data/repositories/plant_repository.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../plants/application/plant_notifier.dart';

class HomeState {
  final List<Plant> needsWatering;
  final List<Plant> needsFertilizing;

  const HomeState({
    required this.needsWatering,
    required this.needsFertilizing,
  });
}

class HomeNotifier extends AsyncNotifier<HomeState> {
  late PlantRepository _repository;

  @override
  Future<HomeState> build() async {
    await ref.watch(plantNotifierProvider.future);
    _repository = ref.read(plantRepositoryProvider);
    return HomeState(
      needsWatering: await _repository.getPlantsNeedingWater(),
      needsFertilizing: await _repository.getPlantsNeedingFertilizing(),
    );
  }

  Future<void> markAsWatered(String id) async {
    await ref.read(plantNotifierProvider.notifier).markAsWatered(id);
  }

  Future<void> markAsFertilized(String id) async {
    await ref.read(plantNotifierProvider.notifier).markAsFertilized(id);
  }
}

final homeNotifierProvider =
    AsyncNotifierProvider<HomeNotifier, HomeState>(HomeNotifier.new);