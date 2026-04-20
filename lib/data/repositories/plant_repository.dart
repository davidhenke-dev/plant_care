import 'package:hive_flutter/hive_flutter.dart';
import '../models/plant.dart';
import 'base_repository.dart';

class PlantRepository implements BaseRepository<Plant> {
  final Box<Plant> _box;

  PlantRepository(this._box);

  @override
  Future<List<Plant>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<Plant?> getById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> save(Plant item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> deleteAll() async {
    await _box.clear();
  }

  Future<List<Plant>> getByLocation(String locationId) async {
    return _box.values
        .where((p) => p.locationId == locationId)
        .toList();
  }

  Future<List<Plant>> getPlantsNeedingWater() async {
    return _box.values
        .where((p) => p.needsWateringToday)
        .toList();
  }
}