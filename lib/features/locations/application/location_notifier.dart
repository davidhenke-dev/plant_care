import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/location.dart';
import '../../../data/repositories/location_repository.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../plants/application/plant_notifier.dart';

class LocationNotifier extends AsyncNotifier<List<Location>> {
  late LocationRepository _repository;

  @override
  Future<List<Location>> build() async {
    _repository = ref.read(locationRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addLocation({
    required String name,
    required LightLevel lightLevel,
    required HumidityLevel humidityLevel,
    bool isDrafty = false,
    bool isHeatedInWinter = true,
  }) async {
    final location = Location(
      id: const Uuid().v4(),
      name: name,
      lightLevel: lightLevel.index,
      humidityLevel: humidityLevel.index,
      isDrafty: isDrafty,
      isHeatedInWinter: isHeatedInWinter,
      createdAt: DateTime.now(),
    );
    await _repository.save(location);
    ref.invalidateSelf();
  }

  Future<void> deleteLocation(String id) async {
    final plantRepo = ref.read(plantRepositoryProvider);
    await plantRepo.clearLocationId(id);
    await _repository.delete(id);
    ref.invalidateSelf();
    ref.invalidate(plantNotifierProvider);
  }

  Future<void> updateLocation({
    required String id,
    required String name,
    required LightLevel lightLevel,
    required HumidityLevel humidityLevel,
    required bool isDrafty,
    required bool isHeatedInWinter,
  }) async {
    final location = await _repository.getById(id);
    if (location != null) {
      location.name = name;
      location.lightLevel = lightLevel.index;
      location.humidityLevel = humidityLevel.index;
      location.isDrafty = isDrafty;
      location.isHeatedInWinter = isHeatedInWinter;
      await location.save();
      ref.invalidateSelf();
    }
  }
}

final locationNotifierProvider =
    AsyncNotifierProvider<LocationNotifier, List<Location>>(
  LocationNotifier.new,
);