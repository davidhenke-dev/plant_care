import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/location.dart';
import '../../../data/repositories/location_repository.dart';
import '../../../data/repositories/repository_providers.dart';

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
    await _repository.delete(id);
    ref.invalidateSelf();
  }
}

final locationNotifierProvider =
    AsyncNotifierProvider<LocationNotifier, List<Location>>(
  LocationNotifier.new,
);