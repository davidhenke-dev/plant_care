import 'package:hive_flutter/hive_flutter.dart';
import '../models/watering_task.dart';
import 'base_repository.dart';

class WateringTaskRepository implements BaseRepository<WateringTask> {
  final Box<WateringTask> _box;

  WateringTaskRepository(this._box);

  @override
  Future<List<WateringTask>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<WateringTask?> getById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> save(WateringTask item) async {
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

  Future<List<WateringTask>> getOpenTasks() async {
    return _box.values.where((t) => !t.isDone).toList();
  }

  Future<List<WateringTask>> getTasksForPlant(String plantId) async {
    return _box.values.where((t) => t.plantId == plantId).toList();
  }

  Future<List<WateringTask>> getTasksForToday() async {
    final now = DateTime.now();
    return _box.values.where((t) {
      final scheduled = t.scheduledFor;
      return !t.isDone &&
          scheduled.year == now.year &&
          scheduled.month == now.month &&
          scheduled.day == now.day;
    }).toList();
  }

  Future<void> markAsDone(String id) async {
    final task = _box.get(id);
    if (task != null) {
      task.isDone = true;
      task.completedAt = DateTime.now();
      await task.save();
    }
  }
}