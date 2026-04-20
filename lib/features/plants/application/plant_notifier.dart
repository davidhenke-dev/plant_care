import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/plant.dart';
import '../../../data/repositories/plant_repository.dart';
import '../../../data/repositories/repository_providers.dart';

class PlantNotifier extends AsyncNotifier<List<Plant>> {
  late PlantRepository _repository;

  @override
  Future<List<Plant>> build() async {
    _repository = ref.read(plantRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addPlant({
    required String name,
    required String locationId,
    required int wateringIntervalDays,
    String? imagePath,
    String? notes,
  }) async {
    final plant = Plant(
      id: const Uuid().v4(),
      name: name,
      locationId: locationId,
      wateringIntervalDays: wateringIntervalDays,
      imagePath: imagePath,
      notes: notes,
      createdAt: DateTime.now(),
    );
    await _repository.save(plant);
    ref.invalidateSelf();
  }

  Future<void> deletePlant(String id) async {
    await _repository.delete(id);
    ref.invalidateSelf();
  }

  Future<void> markAsWatered(String id) async {
    final plant = await _repository.getById(id);
    if (plant != null) {
      plant.lastWateredAt = DateTime.now();
      await plant.save();
      ref.invalidateSelf();
    }
  }

  Future<void> updateImagePath(String id, String imagePath) async {
    final plant = await _repository.getById(id);
    if (plant != null) {
      plant.imagePath = imagePath;
      await plant.save();
      ref.invalidateSelf();
    }
  }
}

final plantNotifierProvider =
    AsyncNotifierProvider<PlantNotifier, List<Plant>>(
  PlantNotifier.new,
);