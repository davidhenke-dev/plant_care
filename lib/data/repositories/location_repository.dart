import 'package:hive_flutter/hive_flutter.dart';
import '../models/location.dart';
import 'base_repository.dart';

class LocationRepository implements BaseRepository<Location> {
  final Box<Location> _box;

  LocationRepository(this._box);

  @override
  Future<List<Location>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<Location?> getById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> save(Location item) async {
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
}